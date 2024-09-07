import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:water_animation/start_menu.dart';

class WaterAnimationScreen extends StatefulWidget {
  const WaterAnimationScreen({super.key});

  @override
  State<WaterAnimationScreen> createState() => _WaterAnimationScreenState();
}

class _WaterAnimationScreenState extends State<WaterAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController controller1;
  late Animation<List<Offset>> waves1;

  late AnimationController controller2;
  late Animation<List<Offset>> waves2;

  int counter = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Initialize the first wave animation controller
    controller1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: false);

    // Initialize the second wave animation controller with a different duration
    controller2 =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: false);

    // Define the first wave animation
    waves1 = controller1.drive(TweenWave(100, 20));

    // Define the second wave animation with different parameters
    waves2 = controller2.drive(TweenWave(100, 25));

    // Start the counter automatically
    startAutoIncrement();
  }

  @override
  void dispose() {
    // Dispose of the timers and animation controllers
    timer?.cancel();
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  // Automatically increment the counter every second
  void startAutoIncrement() {
    timer = Timer.periodic(const Duration(milliseconds: 300), (Timer t) {
      setState(() {
        counter = counter + 10;
      });
      // Reset counter and show SnackBar when goal is reached
      if (counter == 100) {
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     backgroundColor: Colors.white,
        //     content: Text(
        //       'Goal Achieved',
        //       style: TextStyle(color: Colors.black),
        //     )));

        // Navigate to StartMenu after the SnackBar is shown
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const StartMenu()));
        });
        // setState(() {
        //   counter = 0;
        // });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(253, 0, 192, 1.0),
      body: SafeArea(
        child: Stack(
          children: [
            // First wave animation
            Positioned.fill(
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: counter.toDouble()),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, child) {
                  return FractionallySizedBox(
                    heightFactor: (value / 100).clamp(0, 1),
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: WaveClipperDesign(waves1),
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Second wave animation
            Positioned.fill(
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: counter.toDouble()),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, child) {
                  return FractionallySizedBox(
                    heightFactor: (value / 100).clamp(0, 1),
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: WaveClipperDesign(waves2),
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Counter text
            const Center(
              child: Text(
                'Lemonade',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cursive',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveClipperDesign extends CustomClipper<Path> {
  WaveClipperDesign(this.waves) : super(reclip: waves);
  Animation<List<Offset>> waves;

  @override
  Path getClip(Size size) {
    var w = size.width;
    var h = size.height;

    final points = waves.value.map((e) => Offset(e.dx * w, e.dy)).toList();
    return Path()
      ..addPolygon(points, false)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class TweenWave extends Animatable<List<Offset>> {
  TweenWave(this.count, this.height);

  final int count;
  final double height;
  static const waveCount = 3;

  @override
  List<Offset> transform(double t) {
    return List<Offset>.generate(count, (index) {
      final ratio = index / (count - 1);
      final waveHeight = 1 - (0.5 - ratio).abs() * 2;
      return Offset(
          ratio,
          waveHeight * height * sin(waveCount * (ratio + t) * pi * 2) +
              height * waveHeight);
    }, growable: false);
  }
}
