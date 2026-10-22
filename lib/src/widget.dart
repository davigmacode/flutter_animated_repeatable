import 'dart:async';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'types.dart';

/// The AnimatedRepeatable widget provides a way to create animated transitions
/// on a child widget that repeat a certain number of times.
///
/// This widget offers features like:
/// * Pre-built transitions (`fade`, `spin`, `slide`, `zoom`, `shimmer`)
/// * Customizable transitions using a [AnimatedRepeatableBuilder]
/// * Animation control through properties like `duration`, `curve`, `delay`, and `repeat`
/// * Reversible animation direction (forward, backward, or mirroring)
/// * Pause and resume control
/// * Callbacks for animation lifecycle events (`onStart`, `onPause`, `onContinue`, `onCycle`, `onComplete`)
class AnimatedRepeatable extends StatefulWidget {
  /// Creates a repeatable transition widget.
  ///
  /// This constructor allows you to specify the following properties:
  ///
  /// [repeat]: The number of times to repeat the animation loop. Defaults to `-1` (infinite).
  ///
  /// [pause]: Whether to start the animation. Defaults to `false`.
  ///
  /// [continuity]: Controls whether the animation should maintain continuity when paused.
  ///
  /// [mirror]: Whether the animation should play forward, then backward in a mirroring effect.
  /// Defaults to false.
  ///
  /// [reverse]: Whether the animation plays backward initially. Defaults to `false`.
  ///
  /// [transition]: The [AnimatedRepeatableBuilder] function that defines the animation behavior.
  /// Defaults to [AnimatedRepeatable.fade].
  ///
  /// [curve]: The animation curve that controls the easing of the animation.
  /// Defaults to `Curves.linear`.
  ///
  /// [delay]: The delay before the animation starts. Defaults to `Duration.zero`.
  ///
  /// [duration]: The duration of the animation. Defaults to `Duration(milliseconds: 200)`.
  ///
  /// [reverseTransition]: Defines the type of animation applied to the child widget
  /// for the backward direction (only applicable if [mirror] is `true`). Defaults to [transition] value.
  ///
  /// [reverseCurve]: The curve to use in the reverse direction.
  /// (only applicable if [mirror] is `true`). Defaults to [curve] value.
  ///
  /// [reverseDelay]: The delay before the backward animation starts. Defaults to [delay] value.
  ///
  /// [reverseDuration]: The duration of the backward animation. Defaults to [duration] value.
  ///
  /// [onStart]: A callback function called only once at the very beginning when the animation starts playing.
  ///
  /// [onPause]: A callback function called whenever the animation is paused.
  ///
  /// [onContinue]: A callback function called whenever the animation is resumed after being paused.
  ///
  /// [onCycle]: A callback function called every time the animation completes
  /// a single loop iteration (forward and potentially backward if reverse is true).
  ///
  /// [onComplete]: A callback function called only once when all loops
  /// have finished playing (if repeat is not set to `-1` for infinite loops).
  ///
  /// [wrapper]: control how the child widget is transformed based on
  /// the animation's progress and current state.
  ///
  /// [child]: The widget that will be animated during the transition.
  /// This is a required parameter.
  const AnimatedRepeatable({
    super.key,
    this.repeat = -1,
    this.pause = false,
    this.continuity = true,
    this.mirror = false,
    this.reverse = false,
    this.transition = AnimatedRepeatable.fade,
    this.curve = Curves.linear,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 200),
    this.reverseTransition,
    this.reverseCurve,
    this.reverseDelay,
    this.reverseDuration,
    this.onStart,
    this.onPause,
    this.onContinue,
    this.onCycle,
    this.onComplete,
    this.wrapper,
    this.disableAnimations,
    required this.child,
  }) : assert(repeat >= -1);

  /// Controls how many times the entire animation loop
  /// (forward and potentially backward if [mirror] is `true`) will be played.
  /// Regardless of the [repeat] value, the animation will always play through
  /// one complete cycle (forward and potentially backward) before considering the [repeat] condition.
  ///
  /// Here's how repeat actually works:
  /// * `repeat = -1` (default): Plays the animation indefinitely (loops forever).
  /// * `repeat = 0`: Plays the animation one time only (one cycle).
  /// * `repeat = 1`: Plays the animation twice (one complete loop, then repeats the entire loop again).
  /// * `repeat > 1`: Plays the animation for the specified number of loops in addition to the initial cycle. For example, repeat = 3 plays the animation four times in total (one initial cycle + three repeats).
  ///
  /// In essence, the repeat property doesn't affect whether the animation plays one cycle initially. It controls how many times the entire loop repeats after the first cycle.
  final int repeat;

  /// When set to `true`, the animation playback is paused.
  /// When set to `false` (default), the animation plays normally
  /// according to the defined loop count [repeat].
  final bool pause;

  /// Controls whether the animation should maintain continuity when paused.
  final bool continuity;

  /// Defines whether the animation should play forward, then backward in a mirroring effect.
  final bool mirror;

  /// When set to `true`, the animation plays backward initially.
  final bool reverse;

  /// Defines the type of animation applied to the child widget.
  /// By default, it uses a fade transition (AnimatedRepeatable.fade).
  /// You can potentially provide your own custom transition function here.
  final AnimatedRepeatableBuilder transition;

  /// The [curve] of the animation. By default it's [Curves.linear].
  final Curve curve;

  /// The delay before the animation starts.
  final Duration delay;

  /// The [duration] of the animation.
  final Duration duration;

  /// Defines the type of animation applied to the child widget for the backward direction
  /// (only applicable if [mirror] is `true`).
  ///
  /// Allows for specifying a different animation than the forward transition
  /// for a more complex mirroring effect.
  ///
  /// Defaults to `null`, which means the backward animation will use the same
  /// transition function as the forward animation specified by the [transition] property.
  final AnimatedRepeatableBuilder? reverseTransition;

  /// The curve to use in the backward direction.
  /// (only applicable if [mirror] is `true`).
  ///
  /// Defaults to `null`, which means the backward animation will use
  /// the same curve as the forward animation specified by the [curve] property.
  final Curve? reverseCurve;

  /// The delay before the animation starts playing in the backward direction
  /// (only applicable if [mirror] is `true`). This allows for a slight pause between
  /// the forward and backward animations in the mirroring effect.
  ///
  /// Defaults to `null`, which means the backward animation will use
  /// the same delay as the forward animation specified by the [delay] property.
  final Duration? reverseDelay;

  /// An optional duration that can be specified for the backward animation
  /// (only applicable if [mirror] is `true`), allowing for a different duration
  /// compared to the forward animation, creating an asymmetrical mirroring effect.
  ///
  /// Defaults to `null`, which means the backward animation will use the same duration
  /// as the forward animation specified by the duration property.
  final Duration? reverseDuration;

  /// Called only once at the very beginning when
  /// the animation starts playing for the first time.
  final VoidCallback? onStart;

  /// Called when the animation is paused.
  final VoidCallback? onPause;

  /// Called when the animation is resumed after being paused.
  final VoidCallback? onContinue;

  /// Called when a complete loop iteration finishes.
  final ValueSetter<int>? onCycle;

  /// Called when all specified loops have finished playing
  /// (if repeat is not set to `-1` for infinite loops).
  final VoidCallback? onComplete;

  /// It allows you to control how the child widget
  /// is transformed based on the animation's progress
  /// and current state (LoopAnimationStatus).
  final AnimatedRepeatableBuilder? wrapper;

  /// Whether to disable animations, typically used to respect user accessibility
  /// preferences or for testing. When `null` (default), it automatically respects
  /// the system-wide reduced motion setting via [MediaQuery.maybeDisableAnimationsOf].
  final bool? disableAnimations;

  /// The mandatory widget that will be animated during the transition.
  final Widget child;

  /// Creates a smooth fading effect on the child widget during the animation cycle.
  static const fade = _fade;
  static Widget _fade(Widget child, AnimatedRepeatableState state) {
    return FadeTransition(
      opacity: state.animation,
      child: child,
    );
  }

  /// Animates [child] by rotating them around a central point.
  static const spin = _spin;
  static Widget _spin(Widget child, AnimatedRepeatableState state) {
    return RotationTransition(
      turns: state.animation,
      child: child,
    );
  }

  /// Provides a convenient way to create basic sliding animations
  /// for your [child] widget within the AnimatedRepeatable framework.
  /// Control the direction and distance of the slide using the [to] and [from] offsets.
  ///
  /// **[to]** (required, Offset) : Defines the ending position of
  /// the slide animation relative to the child widget's original location.
  /// This offset specifies the horizontal and vertical movement
  /// of the child widget during the animation.
  ///
  /// **[from]** (optional, Offset, defaults to Offset.zero) :
  /// Defines the starting position of the slide animation relative to
  /// the child widget's original location. Defaults to Offset.zero,
  /// which means the animation starts with the child widget in its original position.
  static AnimatedRepeatableBuilder slide(
    Offset to, [
    Offset from = Offset.zero,
  ]) {
    return (child, final state) {
      final tween = Tween<Offset>(
        begin: from,
        end: to,
      );

      return SlideTransition(
        position: tween.animate(state.animation),
        child: child,
      );
    };
  }

  /// Creates a transition builder that produces a zooming effect on the [child] widget.
  ///
  /// **[from]** (optional, double) : Defines the starting scale of the [child] widget
  /// during the animation cycle. Defaults to 0.0, which means the [child] widget starts off
  /// completely zoomed out (invisible).
  ///
  /// **[to]** (optional, double) : Defines the ending scale of the [child] widget
  /// during the animation cycle. Defaults to 1.0, which means the [child] widget ends up
  /// at its original size.
  static AnimatedRepeatableBuilder zoom([
    double from = 0,
    double to = 1,
  ]) {
    return (child, final state) {
      final tween = Tween<double>(
        begin: from,
        end: to,
      );
      return ScaleTransition(
        scale: tween.animate(state.animation),
        child: child,
      );
    };
  }

  /// Creates a transition builder specifically
  /// designed for creating a shimmering effect.
  ///
  /// **[colors]** (required, List<Color>) : A list of colors
  /// used to create the shimmering effect. The animation cycles
  /// through these colors to produce the shimmer.
  ///
  /// **[stops]** (optional, List<double>) : A list of values between 0.0 and 1.0
  /// that specify the position of each color within the gradient. If omitted,
  /// colors will be spread evenly.
  ///
  /// **[begin]** (optional, AlignmentGeometry) : Defines the starting point of
  /// the shimmer gradient. Defaults to Alignment.topLeft.
  ///
  /// **[end]** (optional, AlignmentGeometry) : Defines the ending point of the shimmer gradient.
  /// Defaults to Alignment.centerRight. This controls the direction of the shimmer animation.
  ///
  /// **[tileMode]** (optional, TileMode) : Specifies how the gradient should be tiled
  /// if the child widget is larger than the gradient itself. Defaults to TileMode.clamp,
  /// which clamps the gradient to the edges of the child widget.
  ///
  /// **[direction]** (optional, AxisDirection) : Defines the direction in which
  /// the shimmer animation moves. Defaults to AxisDirection.right,
  /// which means the shimmer moves from left to right.
  ///
  /// **[blendMode]** (optional, BlendMode) : Determines how the shimmer gradient
  /// is blended with the child widget. Defaults to BlendMode.srcATop,
  /// which places the source color over the destination color.
  /// **[from]** (optional, double) : The starting offset multiplier relative to the bounds.
  /// Defaults to `-1.0` (starts completely outside the entry edge).
  ///
  /// **[to]** (optional, double) : The ending offset multiplier relative to the bounds.
  /// Defaults to `1.0` (exits completely outside the exit edge).
  static AnimatedRepeatableBuilder shimmer({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.centerRight,
    TileMode tileMode = TileMode.clamp,
    AxisDirection direction = AxisDirection.right,
    BlendMode blendMode = BlendMode.srcATop,
    double from = -1.0,
    double to = 1.0,
  }) {
    return (child, final state) {
      return AnimatedBuilder(
        animation: state.animation,
        builder: (context, child) {
          final gradient = LinearGradient(
            colors: colors,
            stops: stops,
            begin: begin,
            end: end,
            tileMode: tileMode,
            transform: GradientSlide(
              direction: direction,
              progress: state.animation.value,
              from: from,
              to: to,
            ),
          );
          return ShaderMask(
            blendMode: blendMode,
            shaderCallback: (bounds) {
              return gradient.createShader(bounds);
            },
            child: child,
          );
        },
        child: child,
      );
    };
  }

  /// Creates a transition builder for that animates [child]
  /// by shaking it horizontally or vertically.
  ///
  /// [direction] (optional): An `Axis` value that controls the shaking direction.
  /// Defaults to `Axis.horizontal`, which shakes the widget back and forth horizontally.
  /// You can also use `Axis.vertical` to shake the widget up and down vertically.
  ///
  /// [distance] (optional): A `double` value that determines
  /// the maximum offset of the shaking movement. Defaults to `3.0`,
  /// which creates a moderate shaking effect. Higher values will
  /// result in more pronounced shaking.
  static AnimatedRepeatableBuilder shake({
    Axis direction = Axis.horizontal,
    double distance = 5,
  }) {
    return (child, final state) {
      final isHorizontal = direction == Axis.horizontal;
      return AnimatedBuilder(
        animation: state.animation,
        builder: (context, child) {
          final d = sin(state.animation.value * pi * distance) * distance;
          return Transform.translate(
            offset: Offset(
              isHorizontal ? d : 0.0,
              isHorizontal ? 0 : d,
            ),
            child: child,
          );
        },
        child: child,
      );
    };
  }

  /// Animates [child] by shake them along the horizontal axis.
  static const shakeX = _shakeX;
  static Widget _shakeX(Widget child, AnimatedRepeatableState state) {
    return shake(direction: Axis.horizontal)(child, state);
  }

  /// Animates [child] by shake them along the vertical axis.
  static const shakeY = _shakeY;
  static Widget _shakeY(Widget child, AnimatedRepeatableState state) {
    return shake(direction: Axis.vertical)(child, state);
  }

  /// The [AnimatedRepeatableState] from the closest instance of
  /// this class that encloses the given context.
  static AnimatedRepeatableState? of(BuildContext context) {
    return context.findAncestorStateOfType<AnimatedRepeatableState>();
  }

  @override
  State<AnimatedRepeatable> createState() => AnimatedRepeatableState();
}

class AnimatedRepeatableState extends State<AnimatedRepeatable>
    with SingleTickerProviderStateMixin {
  /// The [AnimationController] that controls the animation.
  late AnimationController controller;

  /// The [Animation] that is driven by the [AnimationController].
  late Animation<double> animation;

  /// Internal curved animation reference to properly dispose.
  CurvedAnimation? _curvedAnimation;

  /// Timer used to handle delays gracefully and cancel them when paused/disposed.
  Timer? _delayTimer;

  /// The effective transition builder should use.
  AnimatedRepeatableBuilder get _transition {
    return controller.status == AnimationStatus.reverse
        ? widget.reverseTransition ?? widget.transition
        : widget.transition;
  }

  /// Track of how many times the animation cycle has finished playing.
  int cycle = 0;

  /// Indicates that the [cycle] has exceed the [widget.repeat] limit
  bool get _cycleExceed => cycle > widget.repeat;

  /// Track whether the animation has initially run.
  bool isInitialized = false;

  /// Track whether all specified loops have finished playing
  /// (if [widget.repeat] is not set to `-1` for infinite loops).
  bool isCompleted = false;

  /// Track whether the animation is running.
  bool get isAnimating => controller.isAnimating;

  /// Track whether the animation is not running.
  bool get isIdle => !isAnimating;

  /// Indicates the animation should play forward, then backward in a mirroring effect.
  bool get isMirror => widget.mirror;

  /// Indicates the animation should play in straight direction.
  bool get isNotMirror => !isMirror;

  /// Indicates repeat definitely
  bool get isDefinitely => widget.repeat > -1;

  /// Indicates repeat indefinitely
  bool get isIndefinitely => !isDefinitely;

  /// Plays the animation or resumes it from a paused state.
  ///
  /// Optionally accepts a `reset` parameter (defaults to `false`).
  /// If `reset` is set to `true`, the animation progress and cycle count
  /// will be reset before starting playback. This is useful when you want to
  /// ensure the animation starts from the beginning even if it was paused
  /// mid-cycle in the previous playback.
  void play({bool reset = false}) {
    if (reset) _resetAnimation();

    if (isCompleted) return;

    if (widget.pause) return pause();

    if (isInitialized) {
      if (isIdle) {
        widget.onContinue?.call();
      }
      if (!widget.continuity) {
        _forwardAnimation(from: 0);
        return;
      }
    } else {
      isInitialized = true;
      widget.onStart?.call();
    }

    // Resume the animation
    if (controller.status == AnimationStatus.reverse) {
      _backwardAnimation();
    } else {
      _forwardAnimation();
    }
  }

  /// Pauses the animation playback.
  void pause() {
    _delayTimer?.cancel();
    _delayTimer = null;
    controller.stop();
    if (isInitialized && !isCompleted) widget.onPause?.call();
  }

  /// Connects curve with the controller and plays the animation
  void _initAnimation({bool autoPlay = true}) {
    _curvedAnimation?.dispose();
    _curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: widget.curve,
      reverseCurve: widget.reverseCurve,
    );

    final tween = widget.reverse
        ? Tween<double>(begin: 1, end: 0)
        : Tween<double>(begin: 0, end: 1);
    animation = tween.animate(_curvedAnimation!);

    // Plays the animation or resumes it from a paused state if autoPlay is requested.
    if (autoPlay) {
      play();
    }
  }

  /// Reset animation to the initial state
  void _resetAnimation() {
    _delayTimer?.cancel();
    _delayTimer = null;
    cycle = 0;
    isInitialized = false;
    isCompleted = false;
    controller.reset();
  }

  /// Move forward
  void _forwardAnimation({double? from}) {
    _delayTimer?.cancel();
    _delayTimer = null;

    if (from != null) {
      controller.value = from;
    }

    if (widget.delay > Duration.zero && controller.value == 0.0) {
      _delayTimer = Timer(widget.delay, () {
        if (!mounted || widget.pause) return;
        controller.forward(from: from);
      });
    } else {
      if (widget.pause) return;
      controller.forward(from: from);
    }
  }

  /// Move backward
  void _backwardAnimation() {
    _delayTimer?.cancel();
    _delayTimer = null;

    final delay = widget.reverseDelay ?? widget.delay;
    if (delay > Duration.zero && controller.value == 1.0) {
      _delayTimer = Timer(delay, () {
        if (!mounted || widget.pause) return;
        controller.reverse();
      });
    } else {
      if (widget.pause) return;
      controller.reverse();
    }
  }

  /// End the animation
  bool _endAnimation() {
    // Increase cycle counter then invoke the callback
    cycle++;
    widget.onCycle?.call(cycle);

    // End the animation if cycle has exceed
    if (isDefinitely && _cycleExceed) {
      setState(() => isCompleted = true);
      widget.onComplete?.call();
      return true;
    }
    return false;
  }

  /// Handle animation status changes
  void _handleStatus(AnimationStatus status) {
    if (isMirror) {
      if (status == AnimationStatus.completed) {
        _backwardAnimation();
      } else if (status == AnimationStatus.dismissed && isInitialized) {
        if (_endAnimation()) return;
        _forwardAnimation();
      }
    } else {
      if (status == AnimationStatus.completed) {
        if (_endAnimation()) return;
        _forwardAnimation(from: 0);
      }
    }
    setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    // Create controller and register the status listener
    controller = AnimationController(
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      vsync: this,
    )..addStatusListener(_handleStatus);

    // Initiate the animation
    _initAnimation();
  }

  @override
  void didUpdateWidget(AnimatedRepeatable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!mounted) return;

    // Duration might have changed, so update the [AnimationController]
    if (widget.duration != oldWidget.duration) {
      controller.duration = widget.duration;
    }
    if (widget.reverseDuration != oldWidget.reverseDuration) {
      controller.reverseDuration = widget.reverseDuration;
    }

    final bool curveChanged = widget.curve != oldWidget.curve ||
        widget.reverseCurve != oldWidget.reverseCurve ||
        widget.reverse != oldWidget.reverse;

    if (curveChanged) {
      _initAnimation(autoPlay: false);
    }

    final bool resetNeeded = widget.repeat != oldWidget.repeat ||
        widget.continuity != oldWidget.continuity ||
        widget.mirror != oldWidget.mirror;

    if (resetNeeded) {
      _resetAnimation();
      if (!widget.pause) {
        play();
      }
    } else if (widget.pause != oldWidget.pause) {
      if (widget.pause) {
        pause();
      } else {
        play();
      }
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _delayTimer = null;
    _curvedAnimation?.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool shouldDisable = widget.disableAnimations ??
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false);

    if (shouldDisable) {
      return widget.child;
    }

    final child = widget.wrapper?.call(widget.child, this) ?? widget.child;
    return _transition(child, this);
  }
}
