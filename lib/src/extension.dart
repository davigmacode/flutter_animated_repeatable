import 'package:flutter/widgets.dart';
import 'types.dart';
import 'widget.dart';

/// Extension methods on [Widget] to easily wrap widgets with [AnimatedRepeatable].
extension AnimatedRepeatableWidgetExtension on Widget {
  /// Wraps this widget in an [AnimatedRepeatable] transition.
  Widget animateRepeatable({
    Key? key,
    int repeat = -1,
    bool pause = false,
    bool continuity = true,
    bool mirror = false,
    bool reverse = false,
    AnimatedRepeatableBuilder transition = AnimatedRepeatable.fade,
    Curve curve = Curves.linear,
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 200),
    AnimatedRepeatableBuilder? reverseTransition,
    Curve? reverseCurve,
    Duration? reverseDelay,
    Duration? reverseDuration,
    VoidCallback? onStart,
    VoidCallback? onPause,
    VoidCallback? onContinue,
    ValueSetter<int>? onCycle,
    VoidCallback? onComplete,
    AnimatedRepeatableBuilder? wrapper,
    bool? disableAnimations,
  }) {
    return AnimatedRepeatable(
      key: key,
      repeat: repeat,
      pause: pause,
      continuity: continuity,
      mirror: mirror,
      reverse: reverse,
      transition: transition,
      curve: curve,
      delay: delay,
      duration: duration,
      reverseTransition: reverseTransition,
      reverseCurve: reverseCurve,
      reverseDelay: reverseDelay,
      reverseDuration: reverseDuration,
      onStart: onStart,
      onPause: onPause,
      onContinue: onContinue,
      onCycle: onCycle,
      onComplete: onComplete,
      wrapper: wrapper,
      disableAnimations: disableAnimations,
      child: this,
    );
  }

  /// Shorthand to animate repeating fade on this widget.
  Widget repeatFade({
    Key? key,
    int repeat = -1,
    bool mirror = false,
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
    bool? disableAnimations,
  }) {
    return animateRepeatable(
      key: key,
      repeat: repeat,
      mirror: mirror,
      duration: duration,
      curve: curve,
      transition: AnimatedRepeatable.fade,
      disableAnimations: disableAnimations,
    );
  }

  /// Shorthand to animate repeating spin/rotation on this widget.
  Widget repeatSpin({
    Key? key,
    int repeat = -1,
    bool mirror = false,
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
    bool? disableAnimations,
  }) {
    return animateRepeatable(
      key: key,
      repeat: repeat,
      mirror: mirror,
      duration: duration,
      curve: curve,
      transition: AnimatedRepeatable.spin,
      disableAnimations: disableAnimations,
    );
  }

  /// Shorthand to animate repeating zoom/scale on this widget.
  Widget repeatZoom({
    Key? key,
    int repeat = -1,
    bool mirror = false,
    double from = 0,
    double to = 1,
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
    bool? disableAnimations,
  }) {
    return animateRepeatable(
      key: key,
      repeat: repeat,
      mirror: mirror,
      duration: duration,
      curve: curve,
      transition: AnimatedRepeatable.zoom(from, to),
      disableAnimations: disableAnimations,
    );
  }

  /// Shorthand to animate repeating horizontal or vertical shake on this widget.
  Widget repeatShake({
    Key? key,
    int repeat = -1,
    Axis direction = Axis.horizontal,
    double distance = 5,
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
    bool? disableAnimations,
  }) {
    return animateRepeatable(
      key: key,
      repeat: repeat,
      duration: duration,
      curve: curve,
      transition: AnimatedRepeatable.shake(
        direction: direction,
        distance: distance,
      ),
      disableAnimations: disableAnimations,
    );
  }

  /// Shorthand to animate repeating shimmer on this widget.
  Widget repeatShimmer({
    Key? key,
    int repeat = -1,
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.centerRight,
    TileMode tileMode = TileMode.clamp,
    AxisDirection direction = AxisDirection.right,
    BlendMode blendMode = BlendMode.srcATop,
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
    bool? disableAnimations,
  }) {
    return animateRepeatable(
      key: key,
      repeat: repeat,
      duration: duration,
      curve: curve,
      transition: AnimatedRepeatable.shimmer(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
        direction: direction,
        blendMode: blendMode,
      ),
      disableAnimations: disableAnimations,
    );
  }
}
