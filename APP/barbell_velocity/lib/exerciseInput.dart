import 'package:barbell_velocity/function.dart';
import 'package:barbell_velocity/video_player.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:io';

class ExerciseInputPage extends StatefulWidget {
  final String exerciseName;
  final String imagePath;
  final String backgroundImage;

  const ExerciseInputPage({
    super.key,
    required this.exerciseName,
    required this.imagePath,
    this.backgroundImage = "assets/bg_7.JPG",
  });

  @override
  _ExerciseInputPageState createState() => _ExerciseInputPageState();
}

class _ExerciseInputPageState extends State<ExerciseInputPage> {
  final TextEditingController _loadController =
      TextEditingController(text: "0");
  final FocusNode myFocusNode = FocusNode();
  String _unit = "kg";
  String _barbellSize = "Olympic";
  File? processedVideoFile;
  File? summaryFile;
  bool isUploading = false;
  String? filename;

  void _uploadVideo() async {
    setState(() {
      isUploading = true;
    });

    try {
      final uploadedfilename = await uploadVideo();
      if (uploadedfilename != null) filename = uploadedfilename;
      final file = await getProcessedVideo(
          filename!, widget.exerciseName, _loadController.text, _barbellSize);
      final imagefile = await getSummary(filename!);
      setState(() {
        processedVideoFile = file;
        summaryFile = imagefile;
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Future.delayed(const Duration(milliseconds: 50), () {
          FocusScope.of(context).unfocus();
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            widget.exerciseName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg_7.JPG"),
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
              ),
            ),
          ),
          automaticallyImplyLeading: isUploading ? false : true,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.backgroundImage),
              alignment: Alignment.bottomCenter,
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  widget.imagePath,
                  width: 350,
                  height: 350,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 15),
              inputField(
                label: "Load",
                controller: _loadController,
                suffix: unitToggleButton(),
              ),
              const SizedBox(height: 15),
              inputField(
                label: "Barbell Size",
                child: DropdownButton<String>(
                  value: _barbellSize,
                  dropdownColor: Colors.teal,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  items: [
                    "Standard",
                    "Olympic",
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _barbellSize = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              uploadVideoSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputField(
      {required String label,
      TextEditingController? controller,
      Widget? suffix,
      Widget? child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          child ??
              SizedBox(
                width: 100,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  enableSuggestions: false,
                  autofillHints: const <String>[],
                  focusNode: myFocusNode,
                  enableIMEPersonalizedLearning: false,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
          if (suffix != null) suffix,
        ],
      ),
    );
  }

  Widget unitToggleButton() {
    return DropdownButton<String>(
      value: _unit,
      dropdownColor: Colors.teal,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      underline: Container(),
      items: ["kg", "lbs"].map((String unit) {
        return DropdownMenuItem<String>(
          value: unit,
          child: Text(unit, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (String? newUnit) {
        setState(() {
          _unit = newUnit!;
        });
      },
    );
  }

  Widget uploadVideoSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isUploading
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
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: _uploadVideo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(330, 55),
                ),
                child: const Text('Upload Video'),
              ),
        if (processedVideoFile != null && !isUploading)
          Padding(
            padding: const EdgeInsets.all(33.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                      processedVideoFile: processedVideoFile!,
                      filename: filename!,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Change background color
                foregroundColor: Colors.white, // Text color
                fixedSize: const Size(330, 55),
              ),
              child: const Text('Play Processed Video'),
            ),
          ),
        // if (summaryFile != null && !isUploading)
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: ElevatedButton(
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) =>
        //                 GraphPage(summaryFile: summaryFile!),
        //           ),
        //         );
        //       },
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: Colors.teal, // Change background color
        //         foregroundColor: Colors.white, // Text color
        //         fixedSize: const Size(330, 55),
        //       ),
        //       child: const Text('View Summary'),
        //     ),
        //   ),
      ],
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _loadController.dispose();
    super.dispose();
  }
}
