import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    // Hide the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // New circular background with gradient (lower z-index)
            Positioned(
              left: -202, // X position
              top: -153, // Y position
              child: Container(
                width: 751,
                height: 751,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFC1F6F0).withOpacity(1.0), // 0% opacity
                      Color(0xFFDDF6F3).withOpacity(0.0), // 100% opacity
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Original circular background (higher z-index)
            Positioned(
              left: 71, // X position
              top: -148, // Y position
              child: Container(
                width: 634,
                height: 634,
                decoration: BoxDecoration(
                  color: Color(0xFF169C89).withOpacity(0.2), // Color with 20% opacity
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Column(
              children: [
                Expanded(
                  flex: 1, // Header section
                  child: Center(
                    child: const Text(
                      "",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2, // Image section
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/landing_image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2, // Button section
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "Get started!",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Everything starts from here!",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text(
                              "Log in",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: const BorderSide(color: Colors.teal),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(fontSize: 18, color: Colors.teal),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}