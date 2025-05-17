import 'package:client_app/screens/Authentication/login.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SetUPScreenA());
  }
}

class SetUPScreenA extends StatelessWidget {
  const SetUPScreenA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9EBFC), // Light blue background
      body: Column(
        children: [
          // Top Section (Logo & Skip Button)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            height: 180,
            decoration: const BoxDecoration(
              color: Color(0xFF44C5F4), // Blue color
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54, // Predefined color with 54% opacity
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "TORTUGA",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'InknutAntiqua',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Better Food, Better Mood",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inder',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: TextButton(
                    onPressed: () {
                      // Skip button functionality
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                    child: const Text(
                      "Skip>",
                      style: TextStyle(fontSize: 16, fontFamily: 'Inder'),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),

          // Positioned widget to place the image at the bottom center
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/setup_illustration/food.png',
                width: 350,
                height: 450,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Text Description
          const Text(
            "Diverse selection of Food",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontFamily: 'Inder'),
          ),

          const Spacer(),

          // Next Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Next button action
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SetUPScreenB()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF44C5F4), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inder',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SetUPScreenB extends StatelessWidget {
  const SetUPScreenB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9EBFC), // Light blue background
      body: Column(
        children: [
          // Top Section (Logo & Skip Button)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            height: 180,
            decoration: const BoxDecoration(
              color: Color(0xFF44C5F4), // Blue color
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54, // Predefined color with 54% opacity
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "TORTUGA",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'InknutAntiqua',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Better Food, Better Mood",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inder',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: TextButton(
                    onPressed: () {
                      // Skip button functionality
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                    child: const Text(
                      "Skip>",
                      style: TextStyle(fontSize: 16, fontFamily: 'Inder'),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),

          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/setup_illustration/Table.png',
                width: 350,
                height: 420,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Text Description
          const Text(
            "Reserve your Favourite Table",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontFamily: 'Inder'),
          ),

          const Spacer(),

          // Navigation Buttons (Back & Next)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                ElevatedButton(
                  onPressed: () {
                    // Back button action
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF44C5F4), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inder',
                      color: Colors.white,
                    ),
                  ),
                ),

                // Next Button
                ElevatedButton(
                  onPressed: () {
                    // Next button action
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SetUPScreenC()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF44C5F4), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inder',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SetUPScreenC extends StatelessWidget {
  const SetUPScreenC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9EBFC), // Light blue background
      body: Column(
        children: [
          // Top Section (Logo & Skip Button)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            height: 180,
            decoration: const BoxDecoration(
              color: Color(0xFF44C5F4), // Blue header background
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54, // Predefined color with 54% opacity
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "TORTUGA",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'InknutAntiqua',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Better Food, Better Mood",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inder',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: TextButton(
                    onPressed: () {
                      // Skip button functionality
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                    child: const Text(
                      "Skip>",
                      style: TextStyle(fontSize: 16, fontFamily: 'Inder'),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/setup_illustration/delivery.png',
                width: 350,
                height: 450,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Text Description
          const Text(
            "Delivery & Take-away available",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontFamily: 'Inder'),
          ),

          const Spacer(),

          // Back & Next Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Back button action
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF44C5F4), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inder',
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Next button action
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF44C5F4), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inder',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
