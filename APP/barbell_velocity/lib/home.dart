import 'package:barbell_velocity/exercise.dart';
import 'package:barbell_velocity/guide_page.dart';
import 'package:barbell_velocity/result_page.dart';
import 'package:barbell_velocity/videos_page.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
          Center(
            child: HomePageContent()
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {

  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeHeader(name: "Jerome", profileImage: "assets/profile.png"),

          const SizedBox(height: 0),

          ActionButtons(
            onLoadsPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ResultPage()),
              );
            },
            onResultsPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GuidePage()),
              );
            },
            onVideosPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VideosPage()),
              );
            },
          ),

          const SizedBox(height: 50),

          Center(
            child: ElevatedButton(
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExercisePage()),
              );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 155, vertical: 10),
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text("START", style: TextStyle(color: Colors.black),),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  final String name;
  final String profileImage;

  const HomeHeader({super.key, required this.name, required this.profileImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hello,",
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 37,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF444444),
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(profileImage),
          ),
        ],
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  final VoidCallback onLoadsPressed;
  final VoidCallback onResultsPressed;
  final VoidCallback onVideosPressed;

  const ActionButtons({
    super.key,
    required this.onLoadsPressed,
    required this.onResultsPressed,
    required this.onVideosPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3), 
      child: Row(
        children: [
          Flexible(
            child: Column(
              children: [
                buildButton(onLoadsPressed, Icons.bar_chart, "Results"),
                const SizedBox(height: 10),
                buildButton(onResultsPressed, Icons.menu_book, "Guide"),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 245,
              child: buildButton(onVideosPressed, Icons.video_camera_front, "Video",),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(VoidCallback onPressed, IconData icon, String label) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white.withOpacity(0.12),
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 3),
          Text(label, style: const TextStyle(color: Colors.black, fontSize: 25)),
        ],
      ),
    );
  }

}

