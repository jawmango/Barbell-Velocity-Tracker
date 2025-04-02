import 'dart:convert';

import 'dart:io';
import 'package:barbell_velocity/models/results_exercise.dart';
import 'package:barbell_velocity/models/results_path.dart';
import 'package:barbell_velocity/models/results_repetition.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

const String address = "http://127.0.0.1:3000/";
const String address2 = "http://192.168.1.3:3000/";

// fetchdata(String url)async{ //fetch data from url and return the body of the api
//   http.Response response = await http.get(Uri.parse(url));
//   return response.body;
// }

Future<String?> uploadVideo() async { //POST 
  final picker = ImagePicker();
  final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

  if (pickedFile == null){
    return null;
    }

  else{
  final File file = File(pickedFile.path);
  final uri = Uri.parse('${address2}upload'); //http://10.0.2.2:5000/ for android simulator
  
  final request = http.MultipartRequest('POST', uri)
    ..files.add(http.MultipartFile(
      'file',
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: path.basename(file.path),
    ));

  final response = await request.send();

  if (response.statusCode == 200) {
    final responseBody = await response.stream.bytesToString();
    final Map<String, dynamic> responseData = json.decode(responseBody);
    final filename = responseData['filename'];
    print('Video uploaded successfully. Filename: $filename');
    return filename;
  } else {
    print('Failed to upload video');
    return null;
  }
  }
}

Future<File?> getProcessedVideo(String filename, String exerciseName, String load, String barbellSize) async { //GET
  final uri = Uri.parse('${address2}video/$filename?exercise=$exerciseName&load=$load&barbell=$barbellSize');
  
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$filename';
    final file = File(filePath);

    await file.writeAsBytes(response.bodyBytes);
    print('Video saved to $filePath');
    return file; 
  } else {
    print('Failed to retrieve video: ${response.statusCode}');
    return null;
  }
}

Future<File?> getSummary(String filename) async { //GET
  final uri = Uri.parse('${address2}video/$filename/summary');
  
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/summary$filename';
    final file = File(filePath);

    await file.writeAsBytes(response.bodyBytes);
    print('Summary saved to $filePath');
    return file; 
  } else {
    print('Failed to retrieve video: ${response.statusCode}');
    return null;
  }
}

Future<List<ResultsExercise>> fetchResultsExercise() async{
  final uri = Uri.parse('$address2/results');
  final response = await http.get(uri);

  if (response.statusCode == 200){
    Map<String, dynamic> data = json.decode(response.body);
    List<dynamic> exerciseJson = data['exercise'];

    return exerciseJson.map((json)=> ResultsExercise.fromJSON(json)).toList(); 
  }
  else{
    throw Exception('Failed to load results: ${response.statusCode}');
  }
}

Future<List<ResultsRepetition>> fetchResultsRepetition(int exerciseId) async{
  final uri = Uri.parse('$address2/repetition?id=$exerciseId');
  final response = await http.get(uri);

  if (response.statusCode == 200){
    Map<String, dynamic> data = json.decode(response.body);
    List<dynamic> repetitionJson = data['repetition'];

    return repetitionJson.map((json)=> ResultsRepetition.fromJSON(json)).toList(); 
  }
  else{
    throw Exception('Failed to load results: ${response.statusCode}');
  }
}

Future<List<ResultsPath>> fetchResultsPath(int exerciseId) async{
  final uri = Uri.parse('$address2/path?id=$exerciseId');
  final response = await http.get(uri);

  if (response.statusCode == 200){
    Map<String, dynamic> data = json.decode(response.body);
    List<dynamic> pathJson = data['path'];

    return pathJson.map((json)=> ResultsPath.fromJSON(json)).toList(); 
  }
  else{
    throw Exception('Failed to load results: ${response.statusCode}');
  }
}

Future<List<ResultsRepetition>?> deleteResult(int exerciseId, String filename) async{
  final uri = Uri.parse('$address2/remove?id=$exerciseId&filename=$filename');
  final response = await http.delete(uri);

  if (response.statusCode == 200){
    return null;
  }
  else{
    throw Exception('Failed to load results: ${response.statusCode}');
  }
}