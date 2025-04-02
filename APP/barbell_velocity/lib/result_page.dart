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
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    futureResultsExercise = fetchResultsExercise();
  }

  Future<void> deleteAndUpdate(int id, String filename) async {
    await deleteResult(id, filename);
    setState(() {
      futureResultsExercise = fetchResultsExercise();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Results',
          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
        ),
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
        actions: [
          isEditing
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                    });
                  },
                  icon: Icon(Icons.close))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                    });
                  },
                  icon: Icon(Icons.edit))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg_9.jpg"),
            alignment: Alignment.bottomCenter,
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<ResultsExercise>>(
          future: futureResultsExercise,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ResultsExercise> results = snapshot.data!;
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return ListTile(
                    leading: isEditing
                        ? IconButton(
                            icon: Icon(Icons.delete,
                                color: Colors.redAccent, size: 30),
                            onPressed: () => {
                              showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirm Deletion'),
                                      content: Text(
                                          'Do you want to delete this record?'),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel')),
                                        TextButton(
                                          onPressed: () {
                                            deleteAndUpdate(
                                                result.id, result.filename);
                                            Navigator.pop(context);
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  })
                            },
                          )
                        : null,
                    title: Text(
                      result.exercise,
                      style: TextStyle(
                          color: const Color.fromARGB(255, 107, 239, 208)),
                    ),
                    subtitle: Text(
                      'Load: ${result.load} | Date: ${result.dateAdded}',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: isEditing
                        ? null
                        : IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RepetitionPage(
                                          exerciseId: result.id,
                                          filename: result.filename,
                                          intensity: result.intensity,
                                        )),
                              );
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.teal,
                            )),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Snapshot error: ${snapshot.error}');
            }

            return Center(child: const CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
