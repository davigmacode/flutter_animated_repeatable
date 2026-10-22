## 1.2.0

* **Performance**: Replaced per-tick `setState` with `AnimationStatusListener` and isolated animations via `AnimatedBuilder`, eliminating unnecessary frame-by-frame widget subtree rebuilds.
* **Bug Fix**: Fixed timer race condition by using cancelable `Timer` instances for delays instead of uncancelable `Future.delayed`.
* **Bug Fix**: Fixed unintended animation resets and spurious `onContinue` callbacks during parent widget rebuilds.
* **Memory Management**: Properly disposed internal `CurvedAnimation` instances to prevent memory leaks on modern Flutter versions.
* **Consistency**: Aligned built-in transitions by removing redundant `ValueKey` wrappers from `_fade`, `_spin`, and `_zoom`.
* **Accessibility**: Added `disableAnimations` parameter with automatic system-wide reduced motion detection via `MediaQuery.maybeDisableAnimationsOf`.
* **Ergonomics**: Added `AnimatedRepeatableWidgetExtension` on `Widget` with `animateRepeatable`, `repeatFade`, `repeatSpin`, `repeatZoom`, `repeatShake`, and `repeatShimmer`.
* **Testing**: Added comprehensive unit and widget test suite covering all transitions, lifecycle events, and edge cases (100% line coverage).
* **CI**: Added GitHub Actions CI workflow for test, analyze, and format verification.

## 1.1.3

* Update documentation.

## 1.1.2

* Fixed is animating and idle state.

## 1.1.1

* Fixed cycle not increase when onCycle not defined.

## 1.1.0

* Improved builder parameter.

## 1.0.0

* Refactor from `loop_transition` package.
* Added reverse transition and curve.
* Expose play and pause function.
* Added function to get closest AnimatedRepeatableState.
