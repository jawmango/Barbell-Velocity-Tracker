import 'package:barbell_velocity/exerciseInput.dart';
import 'package:flutter/material.dart';



class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg_7.JPG"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black, size: 40),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 70), // Spacing from the top
              const Text(
                "Choose an Exercise",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Text color
                ),
              ),
              const SizedBox(height: 30), // Spacing before buttons
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  children: [
                    exerciseButton(context, "Flat Bench Press", "assets/flat.jpg"),
                    exerciseButton(context, "Incline Bench Press", "assets/incline.jpg"),
                    // exerciseButton(context, "Deadlift", "assets/deadlift.png"),
                    exerciseButton(context, "Back Squat", "assets/squat.png"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget exerciseButton(BuildContext context, String text, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Navigate to ExerciseInputPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseInputPage(
              exerciseName: text,
              imagePath: imagePath,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          height: 155, // Adjusted height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white.withOpacity(0.2), // Transparent box
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text on the left with multiline format
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  width: 150,
                  child: Text(
                    text.replaceAll(" ", "\n"), // Breaks text into two lines
                    textAlign: TextAlign.center, // Centered text
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // Image on the right inside a white rounded box
              Container(
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  imagePath,
                  width: 115,
                  height: 115,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
