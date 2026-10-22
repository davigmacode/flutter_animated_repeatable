import 'package:flutter/material.dart';
import 'package:animated_repeatable/animated_repeatable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimatedRepeatable Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'AnimatedRepeatable',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    letterSpacing: -2,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 50),
            Wrap(
              spacing: 20,
              children: [
                const AnimatedRepeatable(
                  curve: Curves.bounceInOut,
                  duration: Duration(milliseconds: 1500),
                  reverse: true,
                  child: FlutterLogo(size: 64),
                ),
                AnimatedRepeatable(
                  mirror: true,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 1500),
                  reverseDuration: const Duration(milliseconds: 500),
                  transition: AnimatedRepeatable.zoom(.5, 1.2),
                  child: const Icon(
                    Icons.favorite,
                    size: 64,
                    color: Colors.red,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.red,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Wrap(
              spacing: 20,
              children: [
                AnimatedRepeatable(
                  duration: Duration(milliseconds: 1500),
                  transition: AnimatedRepeatable.spin,
                  child: Icon(
                    Icons.settings,
                    size: 64,
                  ),
                ),
                PausableTransition(),
                AnimatedRepeatable(
                  duration: Duration(milliseconds: 1500),
                  reverse: true,
                  transition: AnimatedRepeatable.spin,
                  child: Icon(
                    Icons.settings,
                    size: 64,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              children: [
                const AnimatedRepeatable(
                  curve: Curves.bounceOut,
                  delay: Duration(milliseconds: 1000),
                  duration: Duration(milliseconds: 700),
                  transition: AnimatedRepeatable.shakeX,
                  child: Text('Shake Horizontally'),
                ),
                AnimatedRepeatable(
                  curve: Curves.bounceOut,
                  delay: const Duration(milliseconds: 1000),
                  duration: const Duration(milliseconds: 700),
                  transition: AnimatedRepeatable.shake(
                    direction: Axis.vertical,
                    distance: 7,
                  ),
                  child: const Text('Shake Vertically'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 20,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: AnimatedRepeatable(
                    curve: Curves.linear,
                    delay: const Duration(milliseconds: 1000),
                    duration: const Duration(milliseconds: 900),
                    transition: AnimatedRepeatable.shimmer(
                      colors: [
                        Colors.white,
                        Colors.amber,
                        Colors.green,
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                    child: DefaultTextStyle.merge(
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        shadows: [
                          const Shadow(
                            blurRadius: 1.0,
                            color: Colors.white,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: IconTheme.merge(
                        data: const IconThemeData(size: 34),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          children: [
                            Transform.translate(
                              offset: const Offset(0, 1.5),
                              child: const ThreeArrows(),
                            ),
                            const Text('Slide to unlock'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const InteractiveThreeArrows(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PausableTransition extends StatefulWidget {
  const PausableTransition({super.key});

  @override
  State<PausableTransition> createState() => _PausableTransitionState();
}

class _PausableTransitionState extends State<PausableTransition> {
  final key = GlobalKey<AnimatedRepeatableState>();

  bool paused = false;

  void onHover([bool? value]) {
    setState(() {
      paused = value ?? !paused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedRepeatable(
      key: key,
      pause: paused,
      repeat: 2,
      mirror: true,
      onStart: () => debugPrint('Animation Started'),
      onPause: () => debugPrint('Animation Paused'),
      onContinue: () => debugPrint('Animation Continued'),
      onCycle: (cycle) => debugPrint('Animation Cycle: $cycle'),
      onComplete: () => debugPrint('Animation Completed'),
      duration: const Duration(milliseconds: 1000),
      transition: AnimatedRepeatable.spin,
      reverseDuration: const Duration(milliseconds: 300),
      reverseTransition: AnimatedRepeatable.shakeX,
      wrapper: (child, state) {
        if (state.isCompleted) {
          return AnimatedRepeatable(
            pause: paused,
            mirror: true,
            continuity: false,
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 700),
            reverseDuration: const Duration(milliseconds: 500),
            transition: AnimatedRepeatable.shimmer(colors: [
              Colors.black87,
              Colors.blue,
              Colors.black87,
              Colors.black87,
            ]),
            child: InkResponse(
              onTap: () {
                key.currentState?.play(reset: true);
              },
              child: const Icon(
                Icons.check,
                size: 64,
              ),
            ),
          );
        }
        return child;
      },
      child: MouseRegion(
        onEnter: (_) => onHover(true),
        onExit: (_) => onHover(false),
        child: const Icon(
          Icons.refresh,
          size: 64,
        ),
      ),
    );
  }
}

class InteractiveThreeArrows extends StatelessWidget {
  const InteractiveThreeArrows({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedRepeatable(
      mirror: true,
      curve: Curves.easeInCubic,
      delay: const Duration(milliseconds: 300),
      duration: const Duration(milliseconds: 900),
      reverseDelay: Duration.zero,
      transition: AnimatedRepeatable.slide(const Offset(0, -.3)),
      child: AnimatedRepeatable(
        curve: Curves.linear,
        delay: const Duration(milliseconds: 1000),
        duration: const Duration(milliseconds: 900),
        transition: AnimatedRepeatable.shimmer(
          colors: [
            Colors.blue,
            Colors.white,
            Colors.blue,
            Colors.blue,
          ],
          end: Alignment.topCenter,
          begin: Alignment.bottomCenter,
          direction: AxisDirection.up,
        ),
        child: const ThreeArrows(
          direction: AxisDirection.up,
          size: 32,
        ),
      ),
    );
  }
}

class ThreeArrows extends StatelessWidget {
  const ThreeArrows({
    super.key,
    this.direction = AxisDirection.right,
    this.size,
  });

  final AxisDirection direction;

  final double? size;

  int get turns {
    switch (direction) {
      case AxisDirection.down:
        return 1;
      case AxisDirection.left:
        return 2;
      case AxisDirection.up:
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme.merge(
      data: IconThemeData(
        size: size,
        shadows: const [
          Shadow(
            blurRadius: 1.0,
            color: Colors.white,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: RotatedBox(
        quarterTurns: turns,
        child: const Wrap(
          children: [
            Align(
              widthFactor: .3,
              child: Icon(Icons.keyboard_arrow_right),
            ),
            Align(
              widthFactor: .3,
              child: Icon(Icons.keyboard_arrow_right),
            ),
            Align(
              widthFactor: .3,
              child: Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}
