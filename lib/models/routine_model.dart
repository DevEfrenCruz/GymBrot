class RoutineModel {
  final String name;
  final String description;
  final int? duration;
  final List<SubExercise> subExercises;
  bool isCompleted;
  final int order; // Orden del ejercicio

  RoutineModel({
    required this.name,
    required this.description,
    this.duration,
    required this.subExercises,
    this.isCompleted = false,
    required this.order,
  });

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    return RoutineModel(
      name: json['name'] as String,
      description: json['description'] as String,
      duration: json['duration'] as int?,
      subExercises: (json['subExercises'] as List<dynamic>).map((e) => SubExercise.fromJson(e as Map<String, dynamic>)).toList(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      order: json['order'] as int,
    );
  }
}

class SubExercise {
  final String name;
  final String explanation; // Explicación detallada
  final String imagePath;
  bool isCompleted;

  SubExercise({
    required this.name,
    this.isCompleted = false,
    required this.explanation,
    required this.imagePath,
  });

 factory SubExercise.fromJson(Map<String, dynamic> json) {
    return SubExercise(
      name: json['name'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      explanation: json['explanation'] as String? ?? 'Sin explicación disponible',
      imagePath: json['imagePath'] as String? ?? 'assets/images/placeholder.png',
    );
  }
}