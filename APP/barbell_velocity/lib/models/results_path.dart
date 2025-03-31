class ResultsPath{
  final int id;
  final int exerciseId;
  final int repetition;
  final double xPos;
  final double yPos;
  final double frame;

  const ResultsPath({required this.id, required this.exerciseId, required this.repetition, required this.xPos, required this.yPos, required this.frame});

factory ResultsPath.fromJSON(Map<String, dynamic> json){
  return switch (json){
    {'id': int id, 'exercise_id': int exerciseId, 'repetition': int repetition, 'x_pos': double xPos, 'y_pos': double yPos, 'frame': double frame} => ResultsPath(
      id: id, 
      exerciseId: exerciseId, 
      repetition: repetition,
      xPos: xPos.toDouble(),
      yPos: yPos.toDouble(),
      frame: frame.toDouble(),
      ),
      _=>throw const FormatException('Failed to load Results.'),
  };
}
}