class ResultsRepetition{
  final int id;
  final int exerciseId;
  final int repetition;
  final double velocityC;
  final double velocityE;
  final double meanVelocity;
  final double velocityLoss;

  const ResultsRepetition({required this.id, required this.exerciseId, required this.repetition, required this.velocityC, required this.velocityE, required this.meanVelocity, required this.velocityLoss});

factory ResultsRepetition.fromJSON(Map<String, dynamic> json){
  return switch (json){
    {'id': int id, 'exercise_id': int exerciseId, 'repetition': int repetition, 'velocity_c': double velocityC, 'velocity_e': double velocityE, 'mean_velocity': double meanVelocity, 'velocity_loss': double velocityLoss} => ResultsRepetition(
      id: id, 
      exerciseId: exerciseId, 
      repetition: repetition,
      velocityC: velocityC.toDouble(),
      velocityE: velocityE.toDouble(),
      meanVelocity: meanVelocity.toDouble(),
      velocityLoss: velocityLoss.toDouble(),
      ),
      _=>throw const FormatException('Failed to load Results.'),
  };
}
}