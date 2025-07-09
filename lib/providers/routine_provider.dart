import 'package:flutter/material.dart';
import '../models/routine_models.dart';
import '../services/api_service.dart';

class RoutineProvider with ChangeNotifier {
  List<RoutineDto> _routines = [];
  List<ExerciseDto> _exercises = [];
  List<UserRoutineDto> _myRoutines = [];
  RoutineDto? _selectedRoutine;
  UserRoutineDto? _currentUserRoutine;
  bool _isLoading = false;
  String? _errorMessage;

  List<RoutineDto> get routines => _routines;
  List<ExerciseDto> get exercises => _exercises;
  List<UserRoutineDto> get myRoutines => _myRoutines;
  RoutineDto? get selectedRoutine => _selectedRoutine;
  UserRoutineDto? get currentUserRoutine => _currentUserRoutine;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Cargar todas las rutinas
  Future<void> loadRoutines({RoutineLevel? level}) async {
    _setLoading(true);
    _setError(null);

    try {
      final routines = await ApiService.instance.getRoutines(level: level);
      print('Rutinas recibidas: \\${routines.length}');
      print('Contenido rutinas: \\${routines.map((r) => r.title).toList()}');
      _routines = routines;
      _setError(null);
    } catch (e) {
      _setError('Error cargando rutinas: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Cargar una rutina específica
  Future<void> loadRoutine(int id) async {
    _setLoading(true);
    _setError(null);

    try {
      final routine = await ApiService.instance.getRoutine(id);
      if (routine != null) {
        _selectedRoutine = routine;
        _setError(null);
      } else {
        _setError('Rutina no encontrada');
      }
    } catch (e) {
      _setError('Error cargando rutina: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Cargar ejercicios
  Future<void> loadExercises({MuscleGroup? muscleGroup}) async {
    _setLoading(true);
    _setError(null);

    try {
      final exercises =
          await ApiService.instance.getExercises(muscleGroup: muscleGroup);
      _exercises = exercises;
      _setError(null);
    } catch (e) {
      _setError('Error cargando ejercicios: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Cargar mis rutinas
  Future<void> loadMyRoutines() async {
    _setLoading(true);
    _setError(null);

    try {
      final myRoutines = await ApiService.instance.getMyRoutines();
      _myRoutines = myRoutines;
      _setError(null);
    } catch (e) {
      _setError('Error cargando mis rutinas: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Cargar una rutina específica del usuario
  Future<void> loadMyRoutine(int userRoutineId) async {
    _setLoading(true);
    _setError(null);

    try {
      final userRoutine = await ApiService.instance.getMyRoutine(userRoutineId);
      if (userRoutine != null) {
        _currentUserRoutine = userRoutine;
        _setError(null);
      } else {
        _setError('Rutina de usuario no encontrada');
      }
    } catch (e) {
      _setError('Error cargando rutina de usuario: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Iniciar una rutina
  Future<UserRoutineDto?> startRoutine(int routineId, int userId) async {
    _setLoading(true);
    _setError(null);

    try {
      final request = StartRoutineRequest(userId: userId, routineId: routineId);
      final userRoutine = await ApiService.instance.startRoutine(request);

      if (userRoutine != null) {
        _currentUserRoutine = userRoutine;
        _myRoutines.add(userRoutine);
        _setError(null);
        return userRoutine;
      } else {
        _setError('Error iniciando rutina');
        return null;
      }
    } catch (e) {
      _setError('Error iniciando rutina: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Completar una rutina
  Future<bool> completeRoutine(int userRoutineId) async {
    print(
        'Intentando completar rutina con userRoutineId: $userRoutineId'); // DEBUG
    _setLoading(true);
    _setError(null);

    try {
      final response =
          await ApiService.instance.completeRoutineWithResponse(userRoutineId);
      print('Respuesta de completeRoutine: $response'); // DEBUG
      if (response.success) {
        // Actualizar la rutina en la lista
        final index =
            _myRoutines.indexWhere((r) => r.userRoutineId == userRoutineId);
        if (index != -1) {
          _myRoutines[index] = _myRoutines[index].copyWith(
            completedAt: DateTime.now(),
          );
        }

        if (_currentUserRoutine?.userRoutineId == userRoutineId) {
          _currentUserRoutine = _currentUserRoutine!.copyWith(
            completedAt: DateTime.now(),
          );
        }

        _setError(null);
        return true;
      } else {
        _setError(response.message ?? 'Error completando rutina');
        return false;
      }
    } catch (e) {
      print('Excepción en completeRoutine: $e'); // DEBUG
      _setError('Error completando rutina: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Completar un paso de la rutina
  Future<bool> completeStep(CompleteStepRequest request) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await ApiService.instance.completeStep(request);
      if (success) {
        // Actualizar el paso en la rutina actual
        if (_currentUserRoutine != null) {
          final stepIndex = _currentUserRoutine!.steps.indexWhere(
            (s) => s.stepId == request.stepId,
          );

          if (stepIndex != -1) {
            final updatedSteps =
                List<UserRoutineStepDto>.from(_currentUserRoutine!.steps);
            updatedSteps[stepIndex] = updatedSteps[stepIndex].copyWith(
              isDone: true,
              completedAt: DateTime.now(),
              actualSets: request.actualSets,
              actualReps: request.actualReps,
              actualDurationSeconds: request.actualDurationSeconds,
              notes: request.notes,
            );

            _currentUserRoutine =
                _currentUserRoutine!.copyWith(steps: updatedSteps);
          }
        }

        _setError(null);
        return true;
      } else {
        _setError('Error completando paso');
        return false;
      }
    } catch (e) {
      _setError('Error completando paso: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Seleccionar una rutina
  void selectRoutine(RoutineDto routine) {
    _selectedRoutine = routine;
    notifyListeners();
  }

  // Limpiar rutina seleccionada
  void clearSelectedRoutine() {
    _selectedRoutine = null;
    notifyListeners();
  }

  // Limpiar rutina actual del usuario
  void clearCurrentUserRoutine() {
    _currentUserRoutine = null;
    notifyListeners();
  }

  // Limpiar error
  void clearError() {
    _setError(null);
  }

  // Obtener rutinas por nivel
  List<RoutineDto> getRoutinesByLevel(RoutineLevel level) {
    return _routines.where((routine) => routine.level == level).toList();
  }

  // Obtener ejercicios por grupo muscular
  List<ExerciseDto> getExercisesByMuscleGroup(MuscleGroup muscleGroup) {
    return _exercises
        .where((exercise) => exercise.primaryMuscle == muscleGroup)
        .toList();
  }

  // Obtener rutinas activas (no completadas)
  List<UserRoutineDto> getActiveRoutines() {
    return _myRoutines.where((routine) => routine.completedAt == null).toList();
  }

  // Obtener rutinas completadas
  List<UserRoutineDto> getCompletedRoutines() {
    return _myRoutines.where((routine) => routine.completedAt != null).toList();
  }
}

// Extensiones para facilitar la creación de copias
extension UserRoutineDtoExtension on UserRoutineDto {
  UserRoutineDto copyWith({
    int? userRoutineId,
    int? userId,
    int? routineId,
    String? routineTitle,
    String? routineDescription,
    DateTime? startedAt,
    DateTime? completedAt,
    int? xpEarned,
    int? caloriesBurned,
    int? durationMinutes,
    String? notes,
    List<UserRoutineStepDto>? steps,
    List<RoutineExerciseDto>? exercises,
  }) {
    return UserRoutineDto(
      userRoutineId: userRoutineId ?? this.userRoutineId,
      userId: userId ?? this.userId,
      routineId: routineId ?? this.routineId,
      routineTitle: routineTitle ?? this.routineTitle,
      routineDescription: routineDescription ?? this.routineDescription,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      xpEarned: xpEarned ?? this.xpEarned,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      steps: steps ?? this.steps,
      exercises: exercises ?? this.exercises,
    );
  }
}

extension UserRoutineStepDtoExtension on UserRoutineStepDto {
  UserRoutineStepDto copyWith({
    int? stepId,
    int? exerciseId,
    String? exerciseName,
    String? exerciseDescription,
    MuscleGroup? primaryMuscle,
    String? mediaUrl,
    bool? isDone,
    DateTime? completedAt,
    int? actualSets,
    int? actualReps,
    int? actualDurationSeconds,
    String? notes,
  }) {
    return UserRoutineStepDto(
      stepId: stepId ?? this.stepId,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      exerciseDescription: exerciseDescription ?? this.exerciseDescription,
      primaryMuscle: primaryMuscle ?? this.primaryMuscle,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      isDone: isDone ?? this.isDone,
      completedAt: completedAt ?? this.completedAt,
      actualSets: actualSets ?? this.actualSets,
      actualReps: actualReps ?? this.actualReps,
      actualDurationSeconds:
          actualDurationSeconds ?? this.actualDurationSeconds,
      notes: notes ?? this.notes,
    );
  }
}
