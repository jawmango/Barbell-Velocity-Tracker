import 'package:barbell_velocity/exercise.dart';
import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Guide',
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(
          color: Colors.teal,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg_9.jpg"),
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.asset(
                "assets/guide_image.png",
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionHeader("Step-by-Step Process"),
                  sectionTitle("1. Press the Start Button"),
                  sectionText(
                      "Open the app and tap Start button to begin the workout tracking session."),
                  sectionTitle("2. Choose an Exercise"),
                  sectionText(
                      "Select the type of lift (e.g., Squat, Flat Bench Press, and Incline Bench Press)."),
                  sectionTitle("3. Input Load and Barbell Size"),
                  sectionText(
                      "Enter the weight in kg or lbs and select the barbell size"),
                  sectionTitle("4. Upload Video or Use Camera"),
                  sectionText(
                      "Upload video or record your lift using the device camera."),
                  sectionTitle("5. View Results"),
                  sectionText(
                      "Analyze your results and follow the feedback to avoid injury"),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.teal,
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),
                  sectionHeader("Recording Guide"),
                  sectionText("Remove Other Barbells and Plates"),
                  sectionText("Use good lighting"),
                  sectionText("Ensure Camera Stabilization"),
                  sectionText("1080p & 30FPS Video Settings"),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.teal,
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),
                  sectionHeader("Fitness Goals"),
                  sectionTitle("Strength Training"),
                  sectionText(
                      "Focus on heavier weights with controlled movement."),
                  sectionTitle("Endurance"),
                  sectionText("Prioritize higher reps with moderate speed."),
                  sectionTitle("Injury Prevention"),
                  sectionText("Ensure correct posture and balanced movement."),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.teal,
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),
                  sectionHeader("Velocity"),
                  sectionTitle("Mean Velocity"),
                  sectionText(
                      "The average speed of the barbell throughout the full range of motion in a lift."),
                  sectionTitle("Peak Velocity"),
                  sectionText(
                      "The highest speed reached by the barbell during a lift."),
                  sectionTitle("Velocity Loss"),
                  sectionText(
                      "The percentage decrease in velocity between reps."),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.teal,
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 145, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExercisePage()),
                        );
                      },
                      child: const Text(
                        "Start",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionHeader(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget sectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, top: 5),
      child:
          Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}
