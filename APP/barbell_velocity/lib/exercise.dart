import 'package:barbell_velocity/exerciseInput.dart';
import 'package:flutter/material.dart';



class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose an Exercise', style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),),
        iconTheme: const IconThemeData(color: Colors.teal,),
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
      body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg_9.jpg"),
                alignment: Alignment.bottomCenter,
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              children: [
                SizedBox(height: 20,),
                exerciseButton(context, "Flat Bench Press", "assets/flat.jpg"),
                exerciseButton(context, "Incline Bench Press", "assets/incline.jpg"),
                exerciseButton(context, "Back Squat", "assets/squat.png"),
              ],
            ),
          ),
          
          
      
    );
  }

  Widget exerciseButton(BuildContext context, String text, String imagePath) {
    return GestureDetector(
      onTap: () {
        
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
          height: 155,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white.withOpacity(0.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  width: 150,
                  child: Text(
                    text.replaceAll(" ", "\n"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
         
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
