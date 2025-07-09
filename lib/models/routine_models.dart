enum RoutineLevel { principiante, intermedio, avanzado }

enum MuscleGroup {
  pecho,
  espalda,
  hombros,
  brazos,
  piernas,
  abdominales,
  cardio,
  flexibilidad,
  fullBody
}

class RoutineDto {
  final int? routineId;
  final String? title;
  final RoutineLevel? level;
  final int? durationMin;
  final String? description;
  final List<RoutineExerciseDto> exercises;

  RoutineDto({
    this.routineId,
    this.title,
    this.level,
    this.durationMin,
    this.description,
    required this.exercises,
  });

  factory RoutineDto.fromJson(Map<String, dynamic> json) {
    return RoutineDto(
      routineId: json['routineId'] as int?,
      title: json['title'] as String?,
      level: json['level'] != null
          ? RoutineLevel.values[json['level'] as int]
          : null,
      durationMin: json['durationMin'] as int?,
      description: json['description'] as String?,
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map(
                  (e) => RoutineExerciseDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routineId': routineId,
      'title': title,
      'level': level?.index,
      'durationMin': durationMin,
      'description': description,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}

class RoutineExerciseDto {
  final int? exerciseId;
  final String? exerciseName;
  final String? exerciseDescription;
  final MuscleGroup? primaryMuscle;
  final String? mediaUrl;
  final int? orderNo;
  final int? sets;
  final int? reps;
  final int? durationSeconds;
  final int? restSeconds;
  final String? notes;

  RoutineExerciseDto({
    this.exerciseId,
    this.exerciseName,
    this.exerciseDescription,
    this.primaryMuscle,
    this.mediaUrl,
    this.orderNo,
    this.sets,
    this.reps,
    this.durationSeconds,
    this.restSeconds,
    this.notes,
  });

  factory RoutineExerciseDto.fromJson(Map<String, dynamic> json) {
    return RoutineExerciseDto(
      exerciseId: json['ExerciseId'] as int?,
      exerciseName: json['ExerciseName'] as String?,
      exerciseDescription: json['ExerciseDescription'] as String?,
      primaryMuscle: json['PrimaryMuscle'] != null
          ? MuscleGroup.values[json['PrimaryMuscle'] as int]
          : null,
      mediaUrl: json['MediaUrl'] as String?,
      orderNo: json['OrderNo'] as int?,
      sets: json['Sets'] as int?,
      reps: json['Reps'] as int?,
      durationSeconds: json['DurationSeconds'] as int?,
      restSeconds: json['RestSeconds'] as int?,
      notes: json['Notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'exerciseDescription': exerciseDescription,
      'primaryMuscle': primaryMuscle?.index,
      'mediaUrl': mediaUrl,
      'orderNo': orderNo,
      'sets': sets,
      'reps': reps,
      'durationSeconds': durationSeconds,
      'restSeconds': restSeconds,
      'notes': notes,
    };
  }
}

class ExerciseDto {
  final int? exerciseId;
  final String? name;
  final String? description;
  final MuscleGroup? primaryMuscle;
  final String? mediaUrl;

  ExerciseDto({
    this.exerciseId,
    this.name,
    this.description,
    this.primaryMuscle,
    this.mediaUrl,
  });

  factory ExerciseDto.fromJson(Map<String, dynamic> json) {
    return ExerciseDto(
      exerciseId: json['ExerciseId'] as int?,
      name: json['ExerciseName'] as String?,
      description: json['ExerciseDescription'] as String?,
      primaryMuscle: json['PrimaryMuscle'] != null
          ? MuscleGroup.values[json['PrimaryMuscle'] as int]
          : null,
      mediaUrl: json['MediaUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'name': name,
      'description': description,
      'primaryMuscle': primaryMuscle?.index,
      'mediaUrl': mediaUrl,
    };
  }
}

class UserRoutineDto {
  final int? userRoutineId;
  final int? userId;
  final int? routineId;
  final String? routineTitle;
  final String? routineDescription;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int? xpEarned;
  final int? caloriesBurned;
  final int? durationMinutes;
  final String? notes;
  final List<UserRoutineStepDto> steps;
  final List<RoutineExerciseDto> exercises;

  UserRoutineDto({
    this.userRoutineId,
    this.userId,
    this.routineId,
    this.routineTitle,
    this.routineDescription,
    this.startedAt,
    this.completedAt,
    this.xpEarned,
    this.caloriesBurned,
    this.durationMinutes,
    this.notes,
    required this.steps,
    required this.exercises,
  });

  factory UserRoutineDto.fromJson(Map<String, dynamic> json) {
    return UserRoutineDto(
      userRoutineId: json['userRoutineId'] as int?,
      userId: json['userId'] as int?,
      routineId: json['routineId'] as int?,
      routineTitle: json['routineTitle'] as String?,
      routineDescription: json['routineDescription'] as String?,
      startedAt:
          json['startedAt'] != null ? DateTime.parse(json['startedAt']) : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      xpEarned: json['xpEarned'] as int?,
      caloriesBurned: json['caloriesBurned'] as int?,
      durationMinutes: json['durationMinutes'] as int?,
      notes: json['notes'] as String?,
      steps: (json['steps'] as List<dynamic>?)
              ?.map(
                  (e) => UserRoutineStepDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map(
                  (e) => RoutineExerciseDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class UserRoutineStepDto {
  final int? stepId;
  final int? exerciseId;
  final String? exerciseName;
  final String? exerciseDescription;
  final MuscleGroup? primaryMuscle;
  final String? mediaUrl;
  final bool isDone;
  final DateTime? completedAt;
  final int? actualSets;
  final int? actualReps;
  final int? actualDurationSeconds;
  final String? notes;

  UserRoutineStepDto({
    this.stepId,
    this.exerciseId,
    this.exerciseName,
    this.exerciseDescription,
    this.primaryMuscle,
    this.mediaUrl,
    required this.isDone,
    this.completedAt,
    this.actualSets,
    this.actualReps,
    this.actualDurationSeconds,
    this.notes,
  });

  factory UserRoutineStepDto.fromJson(Map<String, dynamic> json) {
    return UserRoutineStepDto(
      stepId: json['StepId'] ?? json['stepId'] as int?,
      exerciseId: json['ExerciseId'] ?? json['exerciseId'] as int?,
      exerciseName: json['ExerciseName'] ?? json['exerciseName'] as String?,
      exerciseDescription:
          json['ExerciseDescription'] ?? json['exerciseDescription'] as String?,
      primaryMuscle: (json['PrimaryMuscle'] ?? json['primaryMuscle']) != null
          ? MuscleGroup
              .values[(json['PrimaryMuscle'] ?? json['primaryMuscle']) as int]
          : null,
      mediaUrl: json['MediaUrl'] ?? json['mediaUrl'] as String?,
      isDone: json['IsDone'] ?? json['isDone'] as bool? ?? false,
      completedAt: (json['CompletedAt'] ?? json['completedAt']) != null
          ? DateTime.tryParse(json['CompletedAt'] ?? json['completedAt'])
          : null,
      actualSets: json['ActualSets'] ?? json['actualSets'] as int?,
      actualReps: json['ActualReps'] ?? json['actualReps'] as int?,
      actualDurationSeconds: json['ActualDurationSeconds'] ??
          json['actualDurationSeconds'] as int?,
      notes: json['Notes'] ?? json['notes'] as String?,
    );
  }
}

class StartRoutineRequest {
  final int userId;
  final int routineId;

  StartRoutineRequest({
    required this.userId,
    required this.routineId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'routineId': routineId,
    };
  }
}

class CompleteStepRequest {
  final int stepId;
  final int actualSets;
  final int actualReps;
  final int actualDurationSeconds;
  final String? notes;

  CompleteStepRequest({
    required this.stepId,
    required this.actualSets,
    required this.actualReps,
    required this.actualDurationSeconds,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'stepId': stepId,
      'actualSets': actualSets,
      'actualReps': actualReps,
      'actualDurationSeconds': actualDurationSeconds,
      'notes': notes,
    };
  }
}
