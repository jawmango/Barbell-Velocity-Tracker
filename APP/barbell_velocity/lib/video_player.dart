import 'package:barbell_velocity/function.dart';
import 'package:barbell_velocity/models/results_exercise.dart';
import 'package:barbell_velocity/repetition_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatelessWidget {
  final File processedVideoFile;
  final File summaryFile;
  final String filename;
  const VideoPlayerScreen({required this.processedVideoFile, required this.summaryFile, required this.filename, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Processed Video', style: TextStyle(color: Colors.teal),),
        backgroundColor: const Color.fromARGB(230, 0, 0, 0),
        actions: [
          FutureBuilder<ResultsExercise?>(
            future: findResultsExerciseByFilename(filename),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('No matching result found');
              } else {
                ResultsExercise result = snapshot.data!;
                return TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RepetitionPage(
                          exerciseId: result.id,
                          filename: filename,
                          intensity: result.intensity,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Results',
                    style: TextStyle(fontSize: 17, color: Colors.teal),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(230, 0, 0, 0),
        child: Center(
          child: VideoPlayerWidget(processedVideoFile: processedVideoFile),
        ),
      ),
    );
  }
}
Future<ResultsExercise?> findResultsExerciseByFilename(String filename) async {
    List<ResultsExercise> results = await fetchResultsExercise();
    return results.firstWhere(
      (result) => result.filename == filename,
    );
  }


class VideoPlayerWidget extends StatefulWidget {
  final File processedVideoFile;

  const VideoPlayerWidget({required this.processedVideoFile, super.key});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<List<ResultsExercise>> futureResultsExercise;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.processedVideoFile)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      }).catchError((error) {
        print('Error initializing video: $error');
      });
      futureResultsExercise = fetchResultsExercise();
  }
   

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Column(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
