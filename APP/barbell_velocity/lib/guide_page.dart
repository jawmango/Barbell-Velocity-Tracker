import 'package:barbell_velocity/exercise.dart';
import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background to black
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Guide Image (now inside Scrollable Content)
                SizedBox(
                  height: 250, // Adjust height as needed
                  width: double.infinity,
                  child: Image.asset(
                    "assets/guide_image.png",
                    fit: BoxFit.cover,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0), // Padding only for text content
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recording Guide Section
                      sectionHeader("Recording Guide"),
                      sectionText("Remove Other Barbells and Plates"),
                      sectionText("Use All Lights as Possible"),
                      sectionText("Use Tripod for Stabilization"),
                      sectionText("1080p & 60FPS Works Best"),

                      const SizedBox(height: 16),

                      // Fitness Goals Section
                      sectionHeader("Fitness Goals"),
                      sectionTitle("Strength Training"),
                      sectionText("Focus on heavier weights with controlled movement."),
                      sectionTitle("Endurance"),
                      sectionText("Prioritize higher reps with moderate speed."),
                      sectionTitle("Injury Prevention"),
                      sectionText("Ensure correct posture and balanced movement."),

                      const SizedBox(height: 16),

                      // Velocity Section
                      sectionHeader("Velocity"),
                      sectionTitle("Mean Velocity"),
                      sectionText("The average speed of the barbell throughout the full range of motion in a lift."),
                      sectionTitle("Peak Velocity"),
                      sectionText("The highest speed reached by the barbell during a lift."),
                      sectionTitle("Velocity Loss"),
                      sectionText("The percentage decrease in velocity between reps."),

                      const SizedBox(height: 16),

                      // Step-by-Step Process
                      sectionHeader("Step-by-Step Process"),
                      sectionTitle("Press the Start Button"),
                      sectionText("Open the app and tap Start button to begin the workout tracking session."),
                      sectionTitle("Choose an Exercise"),
                      sectionText("Select the type of lift (e.g., Squat, Flat Bench Press, and Incline Bench Press)."),
                      sectionTitle("Input Load and Barbell Size"),
                      sectionText("Enter the weight in kg or lbs and select the barbell size"),
                      sectionTitle("Upload Video or Use Camera"),
                      sectionText("Upload video or record your lift using the device camera."),
                      sectionTitle("View Results"),
                      sectionText("Analyze your results and follow the feedback to avoid injury"),

                      const SizedBox(height: 20),

                      // Start Button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.teal, // Dark button color
                            padding: const EdgeInsets.symmetric(horizontal: 156, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ExercisePage()),
                            );
                          },
                          child: const Text(
                            "Start",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Back Button at the top-left corner (kept in place)
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 40),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Header Widget
  Widget sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  // Section Title Widget
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  // Section Text Widget
  Widget sectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 5),
      child: Text(text, style: const TextStyle(fontSize: 18, color: Colors.white)),
    );
  }
}
