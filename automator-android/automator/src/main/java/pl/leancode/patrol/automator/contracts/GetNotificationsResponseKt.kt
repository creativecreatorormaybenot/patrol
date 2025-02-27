//Generated by the protocol buffer compiler. DO NOT EDIT!
// source: contracts.proto

package pl.leancode.patrol.automator.contracts;

@kotlin.jvm.JvmName("-initializegetNotificationsResponse")
public inline fun getNotificationsResponse(block: pl.leancode.patrol.automator.contracts.GetNotificationsResponseKt.Dsl.() -> kotlin.Unit): pl.leancode.patrol.automator.contracts.Contracts.GetNotificationsResponse =
  pl.leancode.patrol.automator.contracts.GetNotificationsResponseKt.Dsl._create(pl.leancode.patrol.automator.contracts.Contracts.GetNotificationsResponse.newBuilder()).apply { block() }._build()
public object GetNotificationsResponseKt {
  @kotlin.OptIn(com.google.protobuf.kotlin.OnlyForUseByGeneratedProtoCode::class)
  @com.google.protobuf.kotlin.ProtoDslMarker
  public class Dsl private constructor(
    private val _builder: pl.leancode.patrol.automator.contracts.Contracts.GetNotificationsResponse.Builder
  ) {
    public companion object {
      @kotlin.jvm.JvmSynthetic
      @kotlin.PublishedApi
      internal fun _create(builder: pl.leancode.patrol.automator.contracts.Contracts.GetNotificationsResponse.Builder): Dsl = Dsl(builder)
    }

    @kotlin.jvm.JvmSynthetic
    @kotlin.PublishedApi
    internal fun _build(): pl.leancode.patrol.automator.contracts.Contracts.GetNotificationsResponse = _builder.build()

    /**
     * An uninstantiable, behaviorless type to represent the field in
     * generics.
     */
    @kotlin.OptIn(com.google.protobuf.kotlin.OnlyForUseByGeneratedProtoCode::class)
    public class NotificationsProxy private constructor() : com.google.protobuf.kotlin.DslProxy()
    /**
     * <code>repeated .patrol.Notification notifications = 2;</code>
     */
     public val notifications: com.google.protobuf.kotlin.DslList<pl.leancode.patrol.automator.contracts.Contracts.Notification, NotificationsProxy>
      @kotlin.jvm.JvmSynthetic
      get() = com.google.protobuf.kotlin.DslList(
        _builder.getNotificationsList()
      )
    /**
     * <code>repeated .patrol.Notification notifications = 2;</code>
     * @param value The notifications to add.
     */
    @kotlin.jvm.JvmSynthetic
    @kotlin.jvm.JvmName("addNotifications")
    public fun com.google.protobuf.kotlin.DslList<pl.leancode.patrol.automator.contracts.Contracts.Notification, NotificationsProxy>.add(value: pl.leancode.patrol.automator.contracts.Contracts.Notification) {
      _builder.addNotifications(value)
    }
    /**
     * <code>repeated .patrol.Notification notifications = 2;</code>
     * @param value The notifications to add.
     */
    @kotlin.jvm.JvmSynthetic
    @kotlin.jvm.JvmName("plusAssignNotifications")
    @Suppress("NOTHING_TO_INLINE")
    public inline operator fun com.google.protobuf.kotlin.DslList<pl.leancode.patrol.automator.contracts.Contracts.Notification, NotificationsProxy>.plusAssign(value: pl.leancode.patrol.automator.contracts.Contracts.Notification) {
      add(value)
    }
    /**
     * <code>repeated .patrol.Notification notifications = 2;</code>
     * @param values The notifications to add.
     */
    @kotlin.jvm.JvmSynthetic
    @kotlin.jvm.JvmName("addAllNotifications")
    public fun com.google.protobuf.kotlin.DslList<pl.leancode.patrol.automator.contracts.Contracts.Notification, NotificationsProxy>.addAll(values: kotlin.collections.Iterable<pl.leancode.patrol.automator.contracts.Contracts.Notification>) {
      _builder.addAllNotifications(values)
    }
    /**
     * <code>repeated .patrol.Notification notifications = 2;</code>
     * @param values The notifications to add.
     */
    @kotlin.jvm.JvmSynthetic
    @kotlin.jvm.JvmName("plusAssignAllNotifications")
    @Suppress("NOTHING_TO_INLINE")
    public inline operator fun com.google.protobuf.kotlin.DslList<pl.leancode.patrol.automator.contracts.Contracts.Notification, NotificationsProxy>.plusAssign(values: kotlin.collections.Iterable<pl.leancode.patrol.automator.contracts.Contracts.Notification>) {
      addAll(values)
    }
    /**
     * <code>repeated .patrol.Notification notifications = 2;</code>
     * @param index The index to set the value at.
     * @param value The notifications to set.
     */
    @kotlin.jvm.JvmSynthetic
    @kotlin.jvm.JvmName("setNotifications")
    public operator fun com.google.protobuf.kotlin.DslList<pl.leancode.patrol.automator.contracts.Contracts.Notification, NotificationsProxy>.set(index: kotlin.Int, value: pl.leancode.patrol.automator.contracts.Contracts.Notification) {
      _builder.setNotifications(index, value)
    }
    /**
     * <code>repeated .patrol.Notification notifications = 2;</code>
     */
    @kotlin.jvm.JvmSynthetic
    @kotlin.jvm.JvmName("clearNotifications")
    public fun com.google.protobuf.kotlin.DslList<pl.leancode.patrol.automator.contracts.Contracts.Notification, NotificationsProxy>.clear() {
      _builder.clearNotifications()
    }
  }
}
public inline fun pl.leancode.patrol.automator.contracts.Contracts.GetNotificationsResponse.copy(block: pl.leancode.patrol.automator.contracts.GetNotificationsResponseKt.Dsl.() -> kotlin.Unit): pl.leancode.patrol.automator.contracts.Contracts.GetNotificationsResponse =
  pl.leancode.patrol.automator.contracts.GetNotificationsResponseKt.Dsl._create(this.toBuilder()).apply { block() }._build()
