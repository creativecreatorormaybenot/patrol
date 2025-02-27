import 'dart:io' as io;

import 'package:archive/archive.dart' as archive;
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:patrol_cli/src/common/artifacts_repository.dart';
import 'package:patrol_cli/src/common/logger.dart' as logger;
import 'package:patrol_cli/src/features/devices/device_finder.dart';
import 'package:patrol_cli/src/features/drive/flutter_tool.dart';
import 'package:patrol_cli/src/features/drive/platform/android_driver.dart';
import 'package:patrol_cli/src/features/drive/platform/ios_driver.dart';
import 'package:process/process.dart' as process;
import 'package:pub_updater/pub_updater.dart' as pub;

class MockHttpClient extends Mock implements http.Client {}

class MockZipDecoder extends Mock implements archive.ZipDecoder {}

class MockPubUpdater extends Mock implements pub.PubUpdater {}

class MockProcess extends Mock implements io.Process {}

class MockProcessManager extends Mock implements process.ProcessManager {}

class MockProgress extends Mock implements logger.Progress {}

class MockTask extends Mock implements logger.ProgressTask {}

class MockLogger extends Mock implements logger.Logger {}

class MockArtifactsRepository extends Mock implements ArtifactsRepository {}

class MockDeviceFinder extends Mock implements DeviceFinder {}

class MockAndroidDriver extends Mock implements AndroidDriver {}

class MockIOSDriver extends Mock implements IOSDriver {}

class MockFlutterTool extends Mock implements FlutterTool {}
