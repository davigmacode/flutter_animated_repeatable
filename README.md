# animated_repeatable

> [!IMPORTANT]
> **Repository Moved to Monorepo**: Active development of `animated_repeatable` has migrated to the official [**davigmacode/flutter_wx**](https://github.com/davigmacode/flutter_wx) monorepo under [`packages/animated_repeatable`](https://github.com/davigmacode/flutter_wx/tree/main/packages/animated_repeatable).

[![Pub Version](https://img.shields.io/pub/v/animated_repeatable)](https://pub.dev/packages/animated_repeatable) ![GitHub](https://img.shields.io/github/license/davigmacode/flutter_animated_repeatable) [![GitHub](https://badgen.net/badge/icon/buymeacoffee?icon=buymeacoffee&color=yellow&label)](https://www.buymeacoffee.com/davigmacode) [![GitHub](https://badgen.net/badge/icon/ko-fi?icon=kofi&color=red&label)](https://ko-fi.com/davigmacode)

The `animated_repeatable` package offers a versatile widget called `AnimatedRepeatable` (and convenient Widget extensions) that allows you to apply repeatable animated transitions to a child widget. These transitions cycle through a specified number of times, creating dynamic effects within your UI.

[![Preview](https://github.com/davigmacode/flutter_animated_repeatable/raw/main/media/preview.gif)](https://davigmacode.github.io/flutter_animated_repeatable)

[Demo](https://davigmacode.github.io/flutter_animated_repeatable)

## Features

* Applies repeatable animated transitions to any child widget.
* Offers various built-in transition functions (`fade`, `spin`, `slide`, `zoom`, `shimmer`, `shakeX`, `shakeY`).
* Convenient **Widget Extension methods** (`animateRepeatable`, `repeatFade`, `repeatSpin`, `repeatZoom`, `repeatShake`, `repeatShimmer`) for fluent chaining.
* Allows customization of transitions using `AnimatedRepeatableBuilder`.
* Supports pausing and resuming playback using the `pause` property or programmatically (`play()`, `pause()`).
* Provides fine-grained animation control:
  * `repeat`: Number of times to repeat the animation loop (`-1` for infinite, `0` for 1 cycle).
  * `pause`: Whether to pause the animation.
  * `continuity`: Controls whether the animation should maintain continuity when resumed from paused state.
  * `mirror`: Whether the animation should play forward, then backward in a mirroring effect.
  * `reverse`: Controls the initial animation direction (forward or backward).
  * `transition`: The `AnimatedRepeatableBuilder` function that defines the animation behavior.
  * `curve`: The animation curve that controls the easing of the animation.
  * `delay`: Delay before the animation starts or between cycles.
  * `duration`: Animation duration for each direction (forward and backward if applicable).
  * `reverseTransition`: The transition applied for the backward direction (in mirroring).
  * `reverseCurve`: The curve to use in the backward direction (in mirroring effect).
  * `reverseDelay`: Delay before starting the backward animation (in mirroring effect).
  * `reverseDuration`: Optional duration for the backward animation (mirroring effect).
  * `disableAnimations`: Accessibility option to disable animations; automatically respects system-wide reduced motion settings via `MediaQuery.maybeDisableAnimationsOf`.
* Triggers callbacks at various animation lifecycle stages:
  * `onStart`: Called only once at the very beginning of the first animation play-through.
  * `onPause`: Called whenever the animation is paused.
  * `onContinue`: Called whenever the animation is resumed after being paused.
  * `onCycle`: Called every time the animation completes a single loop iteration.
  * `onComplete`: Called only once when all specified loops have finished playing.

## Usage

To read more about classes and other references used by `animated_repeatable`, see the [API Reference](https://pub.dev/documentation/animated_repeatable/latest/).

### Import the package
```dart
import 'package:animated_repeatable/animated_repeatable.dart';
```

### Fluent Widget Extensions (Recommended)
You can chain repeatable animations directly on any widget:

```dart
// Repeating spin rotation
const Icon(Icons.sync).repeatSpin(
  duration: const Duration(seconds: 2),
);

// Smooth repeating shimmer
const Text('Loading content...').repeatShimmer(
  colors: [Colors.grey, Colors.white, Colors.grey],
  duration: const Duration(milliseconds: 1200),
);

// Repeating zoom/pulse
const Icon(Icons.favorite, color: Colors.red).repeatZoom(
  from: 0.8,
  to: 1.2,
  mirror: true,
  duration: const Duration(milliseconds: 600),
);

// General extension with full options
myWidget.animateRepeatable(
  repeat: 3,
  mirror: true,
  transition: AnimatedRepeatable.slide(const Offset(0.2, 0)),
  duration: const Duration(milliseconds: 500),
);
```

### Declarative Widget Usage
```dart
AnimatedRepeatable(
  // Repeat the animation loop 3 times (in addition to the initial cycle)
  repeat: 3,

  // Start or pause the animation
  pause: false,

  // When resumed from pause, whether to continue from current position or restart
  continuity: true,

  // Enable the mirror effect (forward then backward)
  mirror: true,

  // Built-in fade transition animation
  transition: AnimatedRepeatable.fade,

  // Use a curve to ease the animation (optional)
  curve: Curves.easeInOut,

  // Delay the animation start by 1 second
  delay: const Duration(seconds: 1),

  // Set the animation duration
  duration: const Duration(milliseconds: 500),

  // Use different transition for backward animation (optional)
  reverseTransition: AnimatedRepeatable.shakeX,

  // Use a curve to ease the backward animation (optional)
  reverseCurve: Curves.bounceOut,

  // Set a delay before the reverse animation starts (optional)
  reverseDelay: const Duration(milliseconds: 200),

  // Set a different duration for the backward animation (optional)
  reverseDuration: const Duration(milliseconds: 500),

  // Callbacks for various animation lifecycle events (optional)
  onStart: () => debugPrint('Animation Started'),
  onPause: () => debugPrint('Animation Paused'),
  onContinue: () => debugPrint('Animation Continued'),
  onCycle: (cycle) => debugPrint('Animation Cycle: $cycle'),
  onComplete: () => debugPrint('Animation Completed'),

  // Allows chaining effects based on completion
  wrapper: (child, state) {
    if (state.isCompleted) {
      return AnimatedRepeatable(
        delay: const Duration(milliseconds: 300),
        duration: const Duration(milliseconds: 700),
        transition: AnimatedRepeatable.shimmer(colors: [
          Colors.black87,
          Colors.blue,
          Colors.black87,
        ]),
        child: child,
      );
    }
    return child;
  },

  // Animate the child widget
  child: const MyWidget(
    text: 'This is the widget that will be animated',
  ),
)
```

### Built-in transitions
The package provides various built-in transitions ready to use:

* `AnimatedRepeatable.fade`: Fades the child widget in and out.
* `AnimatedRepeatable.spin`: Rotates the child widget around its center.
* `AnimatedRepeatable.slide`: Slides the child widget from/to specified offsets.
* `AnimatedRepeatable.zoom`: Zooms the child widget in and out.
* `AnimatedRepeatable.shimmer`: Creates a seamless shimmering sweep across the child widget.
* `AnimatedRepeatable.shakeX`: Shakes the child widget horizontally.
* `AnimatedRepeatable.shakeY`: Shakes the child widget vertically.
* `AnimatedRepeatable.shake`: Custom shake animation with configurable `direction` and `distance`.

### Custom transitions
For complete control, define your own transition functions using `AnimatedRepeatableBuilder`:

```dart
final myCustomTransition = (Widget child, AnimatedRepeatableState state) {
  return FadeTransition(
    opacity: state.animation,
    child: child,
  );
};

AnimatedRepeatable(
  transition: myCustomTransition,
  child: const MyWidget(),
);
```

### Programmatic Play/Pause
You can control the animation playback programmatically from anywhere using `GlobalKey<AnimatedRepeatableState>()` or `AnimatedRepeatable.of(context)`:

```dart
import 'package:flutter/material.dart';
import 'package:animated_repeatable/animated_repeatable.dart';

final repeatableKey = GlobalKey<AnimatedRepeatableState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Programmatic AnimatedRepeatable'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedRepeatable(
                key: repeatableKey,
                repeat: -1, // repeat infinitely
                mirror: true,
                transition: AnimatedRepeatable.fade,
                duration: const Duration(seconds: 2),
                child: const FlutterLogo(size: 100),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      repeatableKey.currentState?.play();
                    },
                    child: const Text('Play'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      repeatableKey.currentState?.pause();
                    },
                    child: const Text('Pause'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Accessibility (Reduced Motion)
`AnimatedRepeatable` automatically respects system-wide reduced motion accessibility settings via `MediaQuery.maybeDisableAnimationsOf(context)`. When animations are disabled, the child widget is rendered directly without unnecessary animation ticker overhead. You can also explicitly control this behavior via the `disableAnimations` parameter.

## Sponsoring

<a href="https://www.buymeacoffee.com/davigmacode" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="45"></a>
<a href="https://ko-fi.com/davigmacode" target="_blank"><img src="https://storage.ko-fi.com/cdn/brandasset/kofi_s_tag_white.png" alt="Ko-Fi" height="45"></a>

If this package or any other package I created is helping you, please consider to sponsor me so that I can take time to read the issues, fix bugs, merge pull requests and add features to these packages.
