import 'dart:math';

import 'package:flutter/material.dart';

class WaterAnimationScreen extends StatefulWidget {
  const WaterAnimationScreen({super.key});

  @override
  State<WaterAnimationScreen> createState() => _WaterAnimationScreenState();
}

class _WaterAnimationScreenState extends State<WaterAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<List<Offset>> waves;
  int counter = 0;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat(reverse: false);
    waves = controller.drive(TweenWave(100, 20));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  incrementCounter() {
    setState(() {
      counter = counter + 10;

    });
    if (counter == 110) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'Goal Achieved',
            style: TextStyle(color: Colors.black),
          )));
      setState(() {
        counter = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(46, 45, 89, 1),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: incrementCounter,
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.water_drop,
            color: Colors.blue,
          ),
          label: const Text(
            'Add Water',
            style: TextStyle(color: Colors.black),
          )),
      body: SafeArea(
          child: Stack(
        children: [
          Positioned.fill(
              child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: counter.toDouble()),
            duration: const Duration(seconds: 1),
            builder: ((context, value, child) {
              return FractionallySizedBox(
                heightFactor: (value / 100).clamp(0, 100).toDouble(),
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: WaveClipperDesign(waves),
                  child: CustomPaint(
                    painter: WavePainterDesign(),
                  ),
                ),
              );
            }),
          )),
          Center(
            child: Text(
              '$counter%',
              style: const TextStyle(
                fontSize: 120,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      )),
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

class WavePainterDesign extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Offset.zero & size, Paint()..color = Colors.blue.withOpacity(0.6));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
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
