//Generated by the protocol buffer compiler. DO NOT EDIT!
// source: contracts.proto

package pl.leancode.patrol.automator.contracts;

@kotlin.jvm.JvmName("-initializetapRequest")
public inline fun tapRequest(block: pl.leancode.patrol.automator.contracts.TapRequestKt.Dsl.() -> kotlin.Unit): pl.leancode.patrol.automator.contracts.Contracts.TapRequest =
  pl.leancode.patrol.automator.contracts.TapRequestKt.Dsl._create(pl.leancode.patrol.automator.contracts.Contracts.TapRequest.newBuilder()).apply { block() }._build()
public object TapRequestKt {
  @kotlin.OptIn(com.google.protobuf.kotlin.OnlyForUseByGeneratedProtoCode::class)
  @com.google.protobuf.kotlin.ProtoDslMarker
  public class Dsl private constructor(
    private val _builder: pl.leancode.patrol.automator.contracts.Contracts.TapRequest.Builder
  ) {
    public companion object {
      @kotlin.jvm.JvmSynthetic
      @kotlin.PublishedApi
      internal fun _create(builder: pl.leancode.patrol.automator.contracts.Contracts.TapRequest.Builder): Dsl = Dsl(builder)
    }

    @kotlin.jvm.JvmSynthetic
    @kotlin.PublishedApi
    internal fun _build(): pl.leancode.patrol.automator.contracts.Contracts.TapRequest = _builder.build()

    /**
     * <code>.patrol.Selector selector = 1;</code>
     */
    public var selector: pl.leancode.patrol.automator.contracts.Contracts.Selector
      @JvmName("getSelector")
      get() = _builder.getSelector()
      @JvmName("setSelector")
      set(value) {
        _builder.setSelector(value)
      }
    /**
     * <code>.patrol.Selector selector = 1;</code>
     */
    public fun clearSelector() {
      _builder.clearSelector()
    }
    /**
     * <code>.patrol.Selector selector = 1;</code>
     * @return Whether the selector field is set.
     */
    public fun hasSelector(): kotlin.Boolean {
      return _builder.hasSelector()
    }

    /**
     * <code>string appId = 2;</code>
     */
    public var appId: kotlin.String
      @JvmName("getAppId")
      get() = _builder.getAppId()
      @JvmName("setAppId")
      set(value) {
        _builder.setAppId(value)
      }
    /**
     * <code>string appId = 2;</code>
     */
    public fun clearAppId() {
      _builder.clearAppId()
    }
  }
}
public inline fun pl.leancode.patrol.automator.contracts.Contracts.TapRequest.copy(block: pl.leancode.patrol.automator.contracts.TapRequestKt.Dsl.() -> kotlin.Unit): pl.leancode.patrol.automator.contracts.Contracts.TapRequest =
  pl.leancode.patrol.automator.contracts.TapRequestKt.Dsl._create(this.toBuilder()).apply { block() }._build()

public val pl.leancode.patrol.automator.contracts.Contracts.TapRequestOrBuilder.selectorOrNull: pl.leancode.patrol.automator.contracts.Contracts.Selector?
  get() = if (hasSelector()) getSelector() else null
