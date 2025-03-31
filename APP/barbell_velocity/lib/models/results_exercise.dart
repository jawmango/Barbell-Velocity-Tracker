class ResultsExercise{
  final int id;
  final String exercise;
  final double load;
  final String dateAdded;
  final String filename;
  final String intensity;

  const ResultsExercise({required this.id, required this.exercise, required this.load, required this.dateAdded, required this.filename, required this.intensity});

factory ResultsExercise.fromJSON(Map<String, dynamic> json){
  return switch (json){
    {'id': int id, 'exercise': String exercise, 'load': double load, 'date_added': String dateAdded, 'filename': String filename, 'intensity': String intensity} => ResultsExercise(
      id: id, 
      exercise: exercise, 
      load: load.toDouble(),
      dateAdded: dateAdded,
      filename: filename,
      intensity: intensity,
      ),
      _=>throw const FormatException('Failed to load Exercise Results.'),
  };
}
}