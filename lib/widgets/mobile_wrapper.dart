import 'package:flutter/material.dart';

class MobileWrapper extends StatelessWidget {
  final Widget child;
  const MobileWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If the screen is wider than 600px (Desktop/Web), show the custom 13R frame
        if (constraints.maxWidth > 600) {
          return Scaffold(
            backgroundColor: const Color(0xFF0F172A), // Dark slate background
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // High-Fidelity Custom OnePlus 13R Frame
                  Container(
                    width: 412, // OnePlus 13R logical width
                    height: 906, // OnePlus 13R logical height
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(42), // Slightly less curved than iPhone
                      border: Border.all(
                        color: const Color(0xFF475569), // Gunmetal grey frame
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(150),
                          blurRadius: 50,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // The Actual App Screen
                        Positioned.fill(
                          child: Container(
                            color: Colors.white,
                            // Simulate OnePlus 13R Status Bar & Navigation Bar Space
                            child: Padding(
                              padding: const EdgeInsets.only(top: 36, bottom: 20),
                              child: child,
                            ),
                          ),
                        ),
                        
                        // OnePlus 13R Center Punch-Hole Camera
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(top: 12),
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white12, width: 2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withAlpha(50),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        // Slim uniform bezels simulation (black overlay)
                        IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 4),
                              borderRadius: BorderRadius.circular(38),
                            ),
                          ),
                        ),
                        
                        // Android Navigation Gesture Indicator (bottom bar)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            width: 120,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(80),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Professional Label
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(20),
                      border: Border.all(color: Colors.red.withAlpha(50)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.android, color: Colors.blueAccent, size: 16),
                        const SizedBox(width: 8),
                        const Text(
                          "PRECISION PREVIEW: ONEPLUS 13R",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "6.78\" ProXDR Display • 2780 x 1264 • 19.8:9",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        
        // Native mobile experience (APK view)
        return child;
      },
    );
  }
}
