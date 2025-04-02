import 'dart:io';

import 'package:barbell_velocity/function.dart';
import 'package:barbell_velocity/models/results_exercise.dart';
import 'package:barbell_velocity/video_player.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  late Future<List<ResultsExercise>> futureResultsExercise;
  File? processedVideoFile;
  bool isUploading = false;
  String? filename;
  void _uploadVideo(
      String uploadedfilename, String exerciseName, String load) async {
    setState(() {
      isUploading = true;
    });

    try {
      filename = uploadedfilename;
      final file =
          await getProcessedVideo(filename!, exerciseName, load, "Olympic");
      setState(() {
        processedVideoFile = file;
      });
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      setState(() {
        isUploading = false;
      });
      if (processedVideoFile != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              processedVideoFile: processedVideoFile!,
              filename: filename!,
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    futureResultsExercise = fetchResultsExercise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.teal, size: 40),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: FutureBuilder<List<ResultsExercise>>(
                    future: futureResultsExercise,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ResultsExercise> results = snapshot.data!;
                        return isUploading
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  LoadingAnimationWidget.fourRotatingDots(
                                      color: Colors.teal, size: 70),
                                  SizedBox(
                                    height: 10,
                                    width: 300,
                                  ),
                                  Text(
                                    'Loading..',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                itemCount: results.length,
                                itemBuilder: (context, index) {
                                  final result = results[index];
                                  return ListTile(
                                    title: Text(
                                      result.exercise,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 107, 239, 208)),
                                    ),
                                    subtitle: Text(
                                      'Load: ${result.load} | Date: ${result.dateAdded}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          _uploadVideo(
                                              result.filename,
                                              result.exercise,
                                              result.load.round().toString());
                                        },
                                        icon: Icon(
                                          Icons.play_circle,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
