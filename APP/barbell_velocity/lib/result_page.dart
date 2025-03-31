import 'package:barbell_velocity/function.dart';
import 'package:barbell_velocity/models/results_exercise.dart';
import 'package:barbell_velocity/repetition_page.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});
  

  @override
  State<ResultPage> createState() => _ResultPageState();
}


class _ResultPageState extends State<ResultPage> {
  late Future<List<ResultsExercise>> futureResultsExercise;
  
  @override
  void initState(){
    super.initState();
    futureResultsExercise = fetchResultsExercise();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg_9.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Flexible(
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.teal, size: 40),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                ),
                Expanded(
                  flex:10,
                  child: FutureBuilder<List<ResultsExercise>>(
                    future: futureResultsExercise,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        List<ResultsExercise> results = snapshot.data!;
                        return ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index){
                            final result = results[index];
                            return ListTile(
                              title: Text(result.exercise, style: TextStyle(color: const Color.fromARGB(255, 107, 239, 208)),),
                              subtitle: Text('Load: ${result.load} | Date: ${result.dateAdded}', style: TextStyle(color: Colors.white),),
                              trailing: IconButton(onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RepetitionPage(exerciseId: result.id, filename: result.filename, intensity: result.intensity,)),
                                );
                              }, icon: Icon(Icons.arrow_forward_ios, color: Colors.teal,)),
                            );
                          },
                        );
                      }
                      else if(snapshot.hasError){
                        return Text('Snapshot error: ${snapshot.error}');
                      }
                  
                  
                      return Center(child: const CircularProgressIndicator());
                    },
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