import 'dart:io' as io;

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patrol/src/binding.dart';
import 'package:patrol/src/native/contracts/contracts.pbgrpc.dart';

/// Thrown when a native action fails.
class PatrolActionException implements Exception {
  /// Creates a new [PatrolActionException].
  PatrolActionException(this.message);

  /// Message that the native part returned.
  String message;

  @override
  String toString() => 'Patrol action failed: $message';
}

/// Bindings available to use with [NativeAutomator].
enum BindingType {
  /// Initialize [PatrolBinding].
  patrol,

  /// Initializes [IntegrationTestWidgetsFlutterBinding]
  integrationTest,

  /// Doesn't initialize any binding.
  none,
}

void _defaultPrintLogger(String message) {
  if (const bool.fromEnvironment('PATROL_VERBOSE')) {
    // ignore: avoid_print
    print('Patrol (native): $message');
  }
}

/// Configuration for [NativeAutomator].
class NativeAutomatorConfig {
  /// Creates a new [NativeAutomatorConfig].
  const NativeAutomatorConfig({
    this.host = const String.fromEnvironment(
      'PATROL_HOST',
      defaultValue: 'localhost',
    ),
    this.port = const String.fromEnvironment(
      'PATROL_PORT',
      defaultValue: '8081',
    ),
    this.packageName = const String.fromEnvironment('PATROL_APP_PACKAGE_NAME'),
    this.bundleId = const String.fromEnvironment('PATROL_APP_BUNDLE_ID'),
    this.connectionTimeout = const Duration(seconds: 60),
    this.findTimeout = const Duration(seconds: 10),
    this.logger = _defaultPrintLogger,
  });

  /// Host on which Patrol server instrumentation is running.
  final String host;

  /// Port on [host] on which Patrol server instrumentation is running.
  final String port;

  /// Time after which the connection with the native automator will fail.
  ///
  /// It must be longer than [findTimeout].
  final Duration connectionTimeout;

  /// Time to wait for native views to appear.
  final Duration findTimeout;

  /// Package name of the application under test.
  ///
  /// Android only.
  final String packageName;

  /// Bundle identifier name of the application under test.
  ///
  /// iOS only.
  final String bundleId;

  /// Called when a native action is performed.
  final void Function(String) logger;

  /// Creates a copy of this config but with the given fields replaced with the
  /// new values.
  NativeAutomatorConfig copyWith({
    String? host,
    String? port,
    String? packageName,
    String? bundleId,
    Duration? connectionTimeout,
    Duration? findTimeout,
    void Function(String)? logger,
  }) {
    return NativeAutomatorConfig(
      host: host ?? this.host,
      port: port ?? this.port,
      packageName: packageName ?? this.packageName,
      bundleId: bundleId ?? this.bundleId,
      connectionTimeout: connectionTimeout ?? this.connectionTimeout,
      findTimeout: findTimeout ?? this.findTimeout,
      logger: logger ?? this.logger,
    );
  }
}

/// Provides functionality to interact with the OS that the app under test is
/// running on.
///
/// Communicates over gRPC with the native automation server running on the
/// target device.
class NativeAutomator {
  /// Creates a new [NativeAutomator].
  NativeAutomator({required NativeAutomatorConfig config})
      : assert(
          config.connectionTimeout > config.findTimeout,
          'find timeout is longer than connection timeout',
        ),
        _config = config {
    if (_config.packageName.isEmpty && io.Platform.isAndroid) {
      config.logger("packageName is not set. It's recommended to set it.");
    }
    if (_config.bundleId.isEmpty && io.Platform.isIOS) {
      config.logger("bundleId is not set. It's recommended to set it.");
    }

    final channel = ClientChannel(
      config.host,
      port: int.parse(config.port),
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    _client = NativeAutomatorClient(
      channel,
      options: CallOptions(timeout: _config.connectionTimeout),
    );
  }

  final NativeAutomatorConfig _config;

  late final NativeAutomatorClient _client;

  /// Returns the platform-dependent unique identifier of the app under test.
  String get resolvedAppId {
    if (io.Platform.isAndroid) {
      return _config.packageName;
    } else if (io.Platform.isIOS) {
      return _config.bundleId;
    }

    throw StateError('unsupported platform');
  }

  Future<T> _wrapRequest<T>(String name, Future<T> Function() request) async {
    _config.logger('$name() started');
    try {
      final result = await request();
      _config.logger('$name() succeeded');
      return result;
    } on GrpcError catch (err) {
      _config.logger('$name() failed');
      final log = '$name() failed with code ${err.codeName} (${err.message})';
      throw PatrolActionException(log);
    } catch (err) {
      _config.logger('$name() failed');
      rethrow;
    }
  }

  /// Configures the native automator.
  ///
  /// Must be called before using any native features.
  Future<void> configure() async {
    await _wrapRequest(
      'configure',
      () => _client.configure(
        ConfigureRequest(
          findTimeoutMillis: Int64(_config.findTimeout.inMilliseconds),
        ),
      ),
    );
  }

  /// Presses the back button.
  ///
  /// See also:
  ///  * <https://developer.android.com/reference/androidx/test/uiautomator/UiDevice#pressback>,
  ///    which is used on Android.
  Future<void> pressBack() async {
    await _wrapRequest('pressBack', () => _client.pressBack(Empty()));
  }

  /// Presses the home button.
  ///
  /// See also:
  ///  * <https://developer.android.com/reference/androidx/test/uiautomator/UiDevice#presshome>,
  ///    which is used on Android
  ///
  /// * <https://developer.apple.com/documentation/xctest/xcuidevice/button/home>,
  ///   which is used on iOS
  Future<void> pressHome() async {
    await _wrapRequest('pressHome', () => _client.pressHome(Empty()));
  }

  /// Opens the app specified by [appId]. If [appId] is null, then the app under
  /// test is started (using [resolvedAppId]).
  ///
  /// On Android [appId] is the package name. On iOS [appId] is the bundle name.
  Future<void> openApp({String? appId}) async {
    await _wrapRequest(
      'openApp',
      () => _client.openApp(OpenAppRequest(appId: appId ?? resolvedAppId)),
    );
  }

  /// Presses the recent apps button.
  ///
  /// See also:
  ///  * <https://developer.android.com/reference/androidx/test/uiautomator/UiDevice#pressrecentapps>,
  ///    which is used on Android
  Future<void> pressRecentApps() async {
    await _wrapRequest(
      'pressRecentApps',
      () => _client.pressRecentApps(Empty()),
    );
  }

  /// Double presses the recent apps button.
  Future<void> pressDoubleRecentApps() async {
    await _wrapRequest(
      'pressDoubleRecentApps',
      () => _client.doublePressRecentApps(Empty()),
    );
  }

  /// Opens the notification shade.
  ///
  /// See also:
  ///  * <https://developer.android.com/reference/androidx/test/uiautomator/UiDevice#opennotification>,
  ///    which is used on Android
  Future<void> openNotifications() async {
    await _wrapRequest(
      'openNotifications',
      () => _client.openNotifications(Empty()),
    );
  }

  /// Opens the quick settings shade.
  ///
  /// See also:
  ///  * <https://developer.android.com/reference/androidx/test/uiautomator/UiDevice#openquicksettings>,
  ///    which is used on Android
  Future<void> openQuickSettings() async {
    await _wrapRequest(
      'openQuickSettings',
      () => _client.openQuickSettings(OpenQuickSettingsRequest()),
    );
  }

  /// Returns the first, topmost visible notification.
  ///
  /// Notification shade has to be opened with [openNotifications].
  Future<Notification> getFirstNotification() async {
    final response = await _wrapRequest(
      'getFirstNotification',
      () => _client.getNotifications(
        GetNotificationsRequest(),
      ),
    );

    return response.notifications.first;
  }

  /// Returns notifications that are visible in the notification shade.
  ///
  /// Notification shade has to be opened with [openNotifications].
  Future<List<Notification>> getNotifications() async {
    final response = await _wrapRequest(
      'getNotifications',
      () => _client.getNotifications(
        GetNotificationsRequest(),
      ),
    );

    return response.notifications;
  }

  /// Closes the currently visible heads up notification (iOS only).
  ///
  /// If no heads up notification is visible, the behavior is undefined.
  Future<void> closeHeadsUpNotification() async {
    await _wrapRequest(
      'closeHeadsUpNotification',
      () => _client.closeHeadsUpNotification(Empty()),
    );
  }

  /// Taps on the [index]-th visible notification.
  ///
  /// Notification shade has to be opened with [openNotifications].
  Future<void> tapOnNotificationByIndex(int index) async {
    await _wrapRequest(
      'tapOnNotificationByIndex',
      () => _client.tapOnNotification(TapOnNotificationRequest(index: index)),
    );
  }

  /// Taps on the visible notification using [selector].
  ///
  /// Notification shade will be opened automatically.
  ///
  /// On iOS, only [Selector.textContains] is taken into account.
  Future<void> tapOnNotificationBySelector(Selector selector) async {
    await _wrapRequest(
      'tapOnNotificationBySelector',
      () => _client.tapOnNotification(
        TapOnNotificationRequest(selector: selector),
      ),
    );
  }

  /// Enables dark mode.
  Future<void> enableDarkMode({String? appId}) async {
    await _wrapRequest(
      'enableDarkMode',
      () => _client.enableDarkMode(
        DarkModeRequest(appId: appId ?? resolvedAppId),
      ),
    );
  }

  /// Disables dark mode.
  Future<void> disableDarkMode({String? appId}) async {
    await _wrapRequest(
      'disableDarkMode',
      () => _client.disableDarkMode(
        DarkModeRequest(appId: appId ?? resolvedAppId),
      ),
    );
  }

  /// Enables airplane mode.
  Future<void> enableAirplaneMode() async {
    await _wrapRequest(
      'enableAirplaneMode',
      () => _client.enableAirplaneMode(Empty()),
    );
  }

  /// Enables airplane mode.
  Future<void> disableAirplaneMode() async {
    await _wrapRequest(
      'disableAirplaneMode',
      () => _client.disableAirplaneMode(Empty()),
    );
  }

  /// Enables cellular (aka mobile data connection).
  Future<void> enableCellular() async {
    await _wrapRequest(
      'enableCellular',
      () => _client.enableCellular(Empty()),
    );
  }

  /// Disables cellular (aka mobile data connection).
  Future<void> disableCellular() {
    return _wrapRequest(
      'disableCellular',
      () => _client.disableCellular(Empty()),
    );
  }

  /// Enables Wi-Fi.
  Future<void> enableWifi() async {
    await _wrapRequest(
      'enableWifi',
      () => _client.enableWiFi(Empty()),
    );
  }

  /// Disables Wi-Fi.
  Future<void> disableWifi() async {
    await _wrapRequest(
      'disableWifi',
      () => _client.disableWiFi(Empty()),
    );
  }

  /// Enables bluetooth.
  Future<void> enableBluetooth() async {
    await _wrapRequest(
      'enableBluetooth',
      () => _client.enableBluetooth(Empty()),
    );
  }

  /// Disables bluetooth.
  Future<void> disableBluetooth() async {
    await _wrapRequest(
      'disableBluetooth',
      () => _client.disableBluetooth(Empty()),
    );
  }

  /// Taps on the native view specified by [selector].
  ///
  /// If the native view is not found, an exception is thrown.
  Future<void> tap(Selector selector, {String? appId}) async {
    await _wrapRequest('tap', () async {
      await _client.tap(
        TapRequest(
          selector: selector,
          appId: appId ?? resolvedAppId,
        ),
      );
    });
  }

  /// Double taps on the native view specified by [selector].
  ///
  /// If the native view is not found, an exception is thrown.
  Future<void> doubleTap(Selector selector, {String? appId}) async {
    await _wrapRequest(
      'doubleTap',
      () => _client.doubleTap(
        TapRequest(
          selector: selector,
          appId: appId ?? resolvedAppId,
        ),
      ),
    );
  }

  /// Enters text to the native view specified by [selector].
  ///
  /// The native view specified by selector must be an EditText on Android.
  Future<void> enterText(
    Selector selector, {
    required String text,
    String? appId,
  }) async {
    await _wrapRequest(
      'enterText',
      () => _client.enterText(
        EnterTextRequest(
          data: text,
          selector: selector,
          appId: appId ?? resolvedAppId,
        ),
      ),
    );
  }

  /// Enters text to the [index]-th visible text field.
  Future<void> enterTextByIndex(
    String text, {
    required int index,
    String? appId,
  }) async {
    await _wrapRequest(
      'enterTextByIndex',
      () => _client.enterText(
        EnterTextRequest(
          data: text,
          index: index,
          appId: appId ?? resolvedAppId,
        ),
      ),
    );
  }

  /// Swipes from [from] to [to].
  Future<void> swipe({
    required Offset from,
    required Offset to,
    int steps = 2,
  }) async {
    await _wrapRequest(
      'swipe',
      () => _client.swipe(
        SwipeRequest(
          startX: from.dx,
          startY: from.dy,
          endX: to.dx,
          endY: to.dy,
          steps: steps,
        ),
      ),
    );
  }

  /// Returns a list of currently visible native UI controls, specified by
  /// [selector], which are currently visible on screen.
  Future<List<NativeView>> getNativeViews(Selector selector) async {
    final response = await _wrapRequest(
      'getNativeViews',
      () => _client.getNativeViews(GetNativeViewsRequest(selector: selector)),
    );

    return response.nativeViews;
  }

  /// Checks if a native permission request dialog is from now until [timeout]
  /// passees.
  Future<bool> isPermissionDialogVisible({
    Duration timeout = const Duration(seconds: 1),
  }) async {
    final response = await _wrapRequest(
      'isPermissionDialogVisible',
      () => _client.isPermissionDialogVisible(
        PermissionDialogVisibleRequest(
          timeoutMillis: Int64(timeout.inMilliseconds),
        ),
      ),
    );

    return response.visible;
  }

  /// Grants the permission that the currently visible native permission request
  /// dialog is asking for.
  ///
  /// Throws if no permission request dialog is present.
  Future<void> grantPermissionWhenInUse() async {
    await _wrapRequest(
      'grantPermissionWhenInUse',
      () => _client.handlePermissionDialog(
        HandlePermissionRequest(code: HandlePermissionRequest_Code.WHILE_USING),
      ),
    );
  }

  /// Grants the permission that the currently visible native permission request
  /// dialog is asking for.
  ///
  /// Throws if no permission request dialog is present.
  ///
  /// On iOS, this is the same as [grantPermissionWhenInUse] except for the
  /// location permission.
  Future<void> grantPermissionOnlyThisTime() async {
    await _wrapRequest(
      'grantPermissionOnlyThisTime',
      () => _client.handlePermissionDialog(
        HandlePermissionRequest(
          code: HandlePermissionRequest_Code.ONLY_THIS_TIME,
        ),
      ),
    );
  }

  /// Denies the permission that the currently visible native permission request
  /// dialog is asking for.
  ///
  /// Throws if no permission request dialog is present.
  Future<void> denyPermission() async {
    await _wrapRequest(
      'denyPermission',
      () => _client.handlePermissionDialog(
        HandlePermissionRequest(code: HandlePermissionRequest_Code.DENIED),
      ),
    );
  }

  /// Select the "coarse location" (aka "approximate") setting on the currently
  /// visible native permission request dialog.
  ///
  /// Throws if no permission request dialog is present.
  Future<void> selectCoarseLocation() async {
    await _wrapRequest(
      'selectCoarseLocation',
      () => _client.setLocationAccuracy(
        SetLocationAccuracyRequest(
          locationAccuracy: SetLocationAccuracyRequest_LocationAccuracy.COARSE,
        ),
      ),
    );
  }

  /// Select the "fine location" (aka "precise") setting on the currently
  /// visible native permission request dialog.
  ///
  /// Throws if no permission request dialog is present.
  Future<void> selectFineLocation() async {
    await _wrapRequest(
      'selectFineLocation',
      () => _client.setLocationAccuracy(
        SetLocationAccuracyRequest(
          locationAccuracy: SetLocationAccuracyRequest_LocationAccuracy.FINE,
        ),
      ),
    );
  }
}
