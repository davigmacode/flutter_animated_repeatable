import 'package:flutter/widgets.dart';
import 'widget.dart';

/// Used within the [AnimatedRepeatable] widget to specify
/// the animation function that controls how the child widget
/// is transformed during the animation cycle.
typedef AnimatedRepeatableBuilder = Widget Function(
  Widget child,
  AnimatedRepeatableState state,
);

/// Provides a way to dynamically position a gradient
/// within a defined area by sliding it in a specified direction
/// with a controllable amount of movement.
class GradientSlide extends GradientTransform {
  const GradientSlide({
    this.direction = AxisDirection.right,
    required this.progress,
    this.from = -1.0,
    this.to = 1.0,
  }) : assert(progress >= 0 && progress <= 1);

  /// Defines the direction in which the gradient will slide.
  /// Defaults to AxisDirection.right.
  final AxisDirection direction;

  /// A value between 0.0 and 1.0 that controls the position of the slide.
  final double progress;

  /// The starting offset multiplier relative to the bounds.
  /// Defaults to `-1.0` (starts completely outside the entry edge).
  final double from;

  /// The ending offset multiplier relative to the bounds.
  /// Defaults to `1.0` (exits completely outside the exit edge).
  final double to;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final factor = from + (to - from) * progress;
    double offset = 0;
    // horizontal direction
    if (direction == AxisDirection.right || direction == AxisDirection.left) {
      offset = bounds.width * factor;
      offset = direction == AxisDirection.left ? -offset : offset;
      return Matrix4.translationValues(offset, 0.0, 0.0);
    }
    // vertical direction
    offset = bounds.height * factor;
    offset = direction == AxisDirection.up ? -offset : offset;
    return Matrix4.translationValues(0.0, offset, 0.0);
  }
}
