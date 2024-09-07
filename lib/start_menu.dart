import 'package:flutter/material.dart';

class StartMenu extends StatefulWidget {
  const StartMenu({super.key});

  @override
  _StartMenuState createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController to animate the LinearProgressIndicator
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward(); // Start the animation

    // Once the animation is done, update the state to show the language buttons
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Text "Lemonade"
              const Text(
                'Lemonade',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cursive', // Custom font for logo style if needed
                ),
              ),
              const SizedBox(height: 50), // Space between logo and loading

              // Show a linear progress bar while isLoading is true
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _controller.value, // Update progress value
                        color: Colors.pinkAccent,
                        backgroundColor: Colors.grey[300],
                        minHeight: 8,
                      );
                    },
                  ),
                )
              else
                Column(
                  children: [
                    const Text(
                      'SELECT LANGUAGE',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20), // Space between text and buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        children: [
                          // Deutsch Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle Deutsch button press
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // Background color
                                foregroundColor: Colors.black, // Text color
                                side: const BorderSide(color: Colors.grey), // Border
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'DEUTSCH',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10), // Space between buttons
                          // English Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle English button press
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // Background color
                                foregroundColor: Colors.black, // Text color
                                side: const BorderSide(color: Colors.grey), // Border
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'ENGLISH',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
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

