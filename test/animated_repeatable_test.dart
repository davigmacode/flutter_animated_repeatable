import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animated_repeatable/animated_repeatable.dart';

void main() {
  group('GradientSlide Tests', () {
    test('transforms correctly for all axis directions', () {
      const bounds = Rect.fromLTWH(0, 0, 100, 60);

      // Right
      const slideRight = GradientSlide(
        direction: AxisDirection.right,
        progress: 0.5,
      );
      final matRight = slideRight.transform(bounds);
      expect(matRight?.getTranslation().x, 50.0);
      expect(matRight?.getTranslation().y, 0.0);

      // Left
      const slideLeft = GradientSlide(
        direction: AxisDirection.left,
        progress: 0.5,
      );
      final matLeft = slideLeft.transform(bounds);
      expect(matLeft?.getTranslation().x, -50.0);
      expect(matLeft?.getTranslation().y, 0.0);

      // Down
      const slideDown = GradientSlide(
        direction: AxisDirection.down,
        progress: 0.5,
      );
      final matDown = slideDown.transform(bounds);
      expect(matDown?.getTranslation().x, 0.0);
      expect(matDown?.getTranslation().y, 30.0);

      // Up
      const slideUp = GradientSlide(
        direction: AxisDirection.up,
        progress: 0.5,
      );
      final matUp = slideUp.transform(bounds);
      expect(matUp?.getTranslation().x, 0.0);
      expect(matUp?.getTranslation().y, -30.0);
    });
  });

  group('AnimatedRepeatable Widget Tests', () {
    testWidgets('renders child widget correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            child: Text('Hello World'),
          ),
        ),
      );

      expect(find.text('Hello World'), findsOneWidget);
      expect(find.byType(FadeTransition), findsOneWidget);
    });

    testWidgets(
        'supports built-in transitions: spin, slide, zoom, shimmer, shakeX, shakeY',
        (WidgetTester tester) async {
      // Spin
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            transition: AnimatedRepeatable.spin,
            child: Text('Spin'),
          ),
        ),
      );
      expect(find.byType(RotationTransition), findsOneWidget);

      // Slide
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            transition: AnimatedRepeatable.slide(const Offset(1, 0)),
            child: const Text('Slide'),
          ),
        ),
      );
      expect(find.byType(SlideTransition), findsOneWidget);

      // Zoom
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            transition: AnimatedRepeatable.zoom(0.5, 1.5),
            child: const Text('Zoom'),
          ),
        ),
      );
      expect(find.byType(ScaleTransition), findsOneWidget);

      // Shimmer
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            transition: AnimatedRepeatable.shimmer(
              colors: [Colors.black, Colors.white, Colors.black],
            ),
            child: const Text('Shimmer'),
          ),
        ),
      );
      expect(find.byType(ShaderMask), findsOneWidget);

      // ShakeX
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            transition: AnimatedRepeatable.shakeX,
            child: Text('ShakeX'),
          ),
        ),
      );
      expect(find.byType(Transform), findsWidgets);

      // ShakeY
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            transition: AnimatedRepeatable.shakeY,
            child: Text('ShakeY'),
          ),
        ),
      );
      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('AnimatedRepeatable.of finds state from child context',
        (WidgetTester tester) async {
      AnimatedRepeatableState? foundState;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            child: Builder(
              builder: (context) {
                foundState = AnimatedRepeatable.of(context);
                return const Text('Child');
              },
            ),
          ),
        ),
      );

      expect(foundState, isNotNull);
    });

    testWidgets('state getters work correctly', (WidgetTester tester) async {
      final key = GlobalKey<AnimatedRepeatableState>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            key: key,
            repeat: -1,
            mirror: false,
            child: const Text('Target'),
          ),
        ),
      );

      final state = key.currentState!;
      expect(state.isIndefinitely, isTrue);
      expect(state.isDefinitely, isFalse);
      expect(state.isNotMirror, isTrue);
      expect(state.isMirror, isFalse);
      expect(state.isAnimating, isTrue);
      expect(state.isIdle, isFalse);
    });

    testWidgets('reverse: true starts from 1 and animates to 0',
        (WidgetTester tester) async {
      final key = GlobalKey<AnimatedRepeatableState>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            key: key,
            repeat: 0,
            reverse: true,
            duration: const Duration(milliseconds: 200),
            child: const Text('Reverse'),
          ),
        ),
      );

      expect(key.currentState?.animation.value, 1.0);
      await tester.pump(const Duration(milliseconds: 100));
      expect(key.currentState!.animation.value, lessThan(1.0));
      await tester.pump(const Duration(milliseconds: 110));
      expect(key.currentState!.animation.value, 0.0);
    });

    testWidgets('repeat: 0 completes after 1 full cycle and triggers callbacks',
        (WidgetTester tester) async {
      bool started = false;
      int cycles = 0;
      bool completed = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            repeat: 0,
            duration: const Duration(milliseconds: 300),
            onStart: () => started = true,
            onCycle: (c) => cycles = c,
            onComplete: () => completed = true,
            child: const Text('Target'),
          ),
        ),
      );

      expect(started, isTrue);
      expect(cycles, 0);
      expect(completed, isFalse);

      // Advance through duration plus frame completion
      await tester.pump(const Duration(milliseconds: 150));
      expect(completed, isFalse);

      await tester.pump(const Duration(milliseconds: 160));
      // End of 1st cycle
      expect(cycles, 1);
      expect(completed, isTrue);

      // Pump more time to ensure it does not repeat
      await tester.pump(const Duration(milliseconds: 500));
      expect(cycles, 1);
    });

    testWidgets('repeat: 1 runs 2 cycles then completes',
        (WidgetTester tester) async {
      int cycles = 0;
      bool completed = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            repeat: 1,
            duration: const Duration(milliseconds: 200),
            onCycle: (c) => cycles = c,
            onComplete: () => completed = true,
            child: const Text('Target'),
          ),
        ),
      );

      // Cycle 1
      await tester.pump(const Duration(milliseconds: 210));
      expect(cycles, 1);
      expect(completed, isFalse);

      // Cycle 2
      await tester.pump(const Duration(milliseconds: 210));
      expect(cycles, 2);
      expect(completed, isTrue);
    });

    testWidgets('mirror: true plays forward and backward across multiple cycles',
        (WidgetTester tester) async {
      int cycles = 0;
      bool completed = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            repeat: 1,
            mirror: true,
            duration: const Duration(milliseconds: 100),
            reverseDuration: const Duration(milliseconds: 50),
            reverseTransition: AnimatedRepeatable.spin,
            onCycle: (c) => cycles = c,
            onComplete: () => completed = true,
            child: const Text('Mirror Target'),
          ),
        ),
      );

      // Cycle 1 forward
      await tester.pump(const Duration(milliseconds: 105));
      expect(find.byType(RotationTransition), findsOneWidget); // reverse transition active

      // Cycle 1 backward
      await tester.pump(const Duration(milliseconds: 55));
      expect(cycles, 1);
      expect(completed, isFalse);
      expect(find.byType(FadeTransition), findsOneWidget); // back to forward transition

      // Cycle 2 forward
      await tester.pump(const Duration(milliseconds: 105));
      // Cycle 2 backward
      await tester.pump(const Duration(milliseconds: 55));
      expect(cycles, 2);
      expect(completed, isTrue);
    });

    testWidgets('delay and reverseDelay timers execute properly',
        (WidgetTester tester) async {
      final key = GlobalKey<AnimatedRepeatableState>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            key: key,
            delay: const Duration(milliseconds: 100),
            duration: const Duration(milliseconds: 100),
            mirror: true,
            reverseDelay: const Duration(milliseconds: 50),
            reverseDuration: const Duration(milliseconds: 100),
            child: const Text('Delayed Target'),
          ),
        ),
      );

      // During start delay
      await tester.pump(const Duration(milliseconds: 50));
      expect(key.currentState?.isAnimating, isFalse);

      // Delay expires, forward animation starts
      await tester.pump(const Duration(milliseconds: 60));
      expect(key.currentState?.isAnimating, isTrue);

      // Forward animation finishes (100ms)
      await tester.pump(const Duration(milliseconds: 105));
      // During reverse delay
      await tester.pump(const Duration(milliseconds: 30));
      expect(key.currentState?.isAnimating, isFalse);

      // Reverse delay expires, backward starts
      await tester.pump(const Duration(milliseconds: 30));
      expect(key.currentState?.isAnimating, isTrue);
    });

    testWidgets('pause property and programmatic play/pause',
        (WidgetTester tester) async {
      final key = GlobalKey<AnimatedRepeatableState>();
      bool paused = false;
      bool continued = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            key: key,
            duration: const Duration(milliseconds: 500),
            onPause: () => paused = true,
            onContinue: () => continued = true,
            child: const Text('Pausable'),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));
      expect(key.currentState?.isAnimating, isTrue);

      // Pause programmatically
      key.currentState?.pause();
      await tester.pump();
      expect(paused, isTrue);
      expect(key.currentState?.isAnimating, isFalse);

      // Play programmatically
      key.currentState?.play();
      await tester.pump();
      expect(continued, isTrue);
      expect(key.currentState?.isAnimating, isTrue);
    });

    testWidgets('play with reset: true resets cycle and progress',
        (WidgetTester tester) async {
      final key = GlobalKey<AnimatedRepeatableState>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            key: key,
            repeat: 0,
            duration: const Duration(milliseconds: 100),
            child: const Text('Reset Target'),
          ),
        ),
      );

      // Advance to complete
      await tester.pump(const Duration(milliseconds: 110));
      expect(key.currentState?.isCompleted, isTrue);
      expect(key.currentState?.cycle, 1);

      // Play with reset
      key.currentState?.play(reset: true);
      await tester.pump();
      expect(key.currentState?.isCompleted, isFalse);
      expect(key.currentState?.cycle, 0);
      expect(key.currentState?.isAnimating, isTrue);
    });

    testWidgets('pausing during delay prevents animation from triggering',
        (WidgetTester tester) async {
      final key = GlobalKey<AnimatedRepeatableState>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            key: key,
            delay: const Duration(milliseconds: 400),
            duration: const Duration(milliseconds: 200),
            child: const Text('Delayed'),
          ),
        ),
      );

      // In the middle of initial delay
      await tester.pump(const Duration(milliseconds: 100));
      expect(key.currentState?.isAnimating, isFalse);

      // Pause while timer is running
      key.currentState?.pause();
      await tester.pump();

      // Advance past delay duration
      await tester.pump(const Duration(milliseconds: 500));
      expect(key.currentState?.isAnimating, isFalse);
      expect(key.currentState?.controller.value, 0.0);
    });

    testWidgets('continuity: false restarts animation from 0 on resume',
        (WidgetTester tester) async {
      final key = GlobalKey<AnimatedRepeatableState>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            key: key,
            continuity: false,
            duration: const Duration(milliseconds: 200),
            child: const Text('Non-continuous'),
          ),
        ),
      );

      // Advance halfway
      await tester.pump(const Duration(milliseconds: 100));
      expect(key.currentState?.controller.value, closeTo(0.5, 0.05));

      // Pause
      key.currentState?.pause();
      await tester.pump();

      // Resume
      key.currentState?.play();
      await tester.pump();
      // Should restart from 0
      expect(key.currentState?.controller.value, 0.0);
    });

    testWidgets('didUpdateWidget handles property updates gracefully',
        (WidgetTester tester) async {
      final key = GlobalKey<AnimatedRepeatableState>();
      Duration duration = const Duration(milliseconds: 200);
      Duration reverseDuration = const Duration(milliseconds: 100);
      Curve curve = Curves.linear;
      bool paused = false;
      int repeat = 1;
      bool mirror = false;

      Widget buildWidget() {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            key: key,
            duration: duration,
            reverseDuration: reverseDuration,
            curve: curve,
            pause: paused,
            repeat: repeat,
            mirror: mirror,
            child: const Text('Update Target'),
          ),
        );
      }

      await tester.pumpWidget(buildWidget());
      expect(key.currentState?.controller.duration, const Duration(milliseconds: 200));

      // 1. Update duration and reverseDuration
      duration = const Duration(milliseconds: 400);
      reverseDuration = const Duration(milliseconds: 250);
      await tester.pumpWidget(buildWidget());
      expect(key.currentState?.controller.duration, const Duration(milliseconds: 400));
      expect(key.currentState?.controller.reverseDuration, const Duration(milliseconds: 250));

      // 2. Update curve
      curve = Curves.easeIn;
      await tester.pumpWidget(buildWidget());

      // 3. Update pause prop (false -> true)
      paused = true;
      await tester.pumpWidget(buildWidget());
      expect(key.currentState?.isAnimating, isFalse);

      // 4. Update pause prop (true -> false)
      paused = false;
      await tester.pumpWidget(buildWidget());
      expect(key.currentState?.isAnimating, isTrue);

      // 5. Update repeat and mirror (triggers reset)
      repeat = 5;
      mirror = true;
      await tester.pumpWidget(buildWidget());
      expect(key.currentState?.cycle, 0);
      expect(key.currentState?.isMirror, isTrue);
    });

    testWidgets('parent rebuild does not falsely call onContinue or restart animation',
        (WidgetTester tester) async {
      int continueCount = 0;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                children: [
                  AnimatedRepeatable(
                    duration: const Duration(milliseconds: 500),
                    continuity: false,
                    onContinue: () => continueCount++,
                    child: const Text('Anim'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Rebuild Parent'),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Advance animation partially
      await tester.pump(const Duration(milliseconds: 250));
      expect(continueCount, 0);

      // Trigger parent rebuild
      await tester.tap(find.text('Rebuild Parent'));
      await tester.pump();

      // Verify onContinue was NOT triggered and animation continues
      expect(continueCount, 0);
    });

    testWidgets('wrapper transforms child based on state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            repeat: 0,
            duration: const Duration(milliseconds: 100),
            wrapper: (child, state) {
              if (state.isCompleted) {
                return const Text('Completed Wrapper');
              }
              return child;
            },
            child: const Text('Original Child'),
          ),
        ),
      );

      expect(find.text('Original Child'), findsOneWidget);
      expect(find.text('Completed Wrapper'), findsNothing);

      // Complete cycle
      await tester.pump(const Duration(milliseconds: 110));
      await tester.pump();

      expect(find.text('Completed Wrapper'), findsOneWidget);
    });

    testWidgets('pausing during reverse mirror and calling play resumes backward animation',
        (WidgetTester tester) async {
      final key = GlobalKey<AnimatedRepeatableState>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedRepeatable(
            key: key,
            mirror: true,
            duration: const Duration(milliseconds: 100),
            reverseDuration: const Duration(milliseconds: 100),
            child: const Text('Mirror Resume'),
          ),
        ),
      );

      // Finish forward (100ms)
      await tester.pump(const Duration(milliseconds: 105));
      // Now running in reverse
      await tester.pump(const Duration(milliseconds: 50));
      expect(key.currentState?.controller.status, AnimationStatus.reverse);

      // Pause during reverse
      key.currentState?.pause();
      await tester.pump();
      expect(key.currentState?.isAnimating, isFalse);

      // Resume during reverse
      key.currentState?.play();
      await tester.pump();
      expect(key.currentState?.isAnimating, isTrue);
      expect(key.currentState?.controller.status, AnimationStatus.reverse);
    });
  });
}
