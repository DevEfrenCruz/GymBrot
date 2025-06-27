import 'package:flutter/material.dart';
import '../models/routine_model.dart';

class RoutineController with ChangeNotifier {
  String _selectedLevel = 'Principiante'; // Nivel fijo por ahora
 final Map<String, List<RoutineModel>> _routines = {
  'Principiante': [
    RoutineModel(
      name: 'Ejercicio de Pierna',
      description: 'Rutina básica para piernas',
      duration: 30,
      subExercises: [
        SubExercise(
          name: 'Sentadillas - 3x10',
          explanation: 'Mantén la espalda recta, baja hasta que las rodillas formen un ángulo de 90°. Sube lentamente.',
          imagePath: 'assets/images/squats.png',
        ),
        SubExercise(
          name: 'Zancadas - 3x8',
          explanation: 'Da un paso adelante, baja la rodilla trasera casi al suelo, y regresa a la posición inicial.',
          imagePath: 'assets/images/lunges.png',
        ),
      ],
      order: 1,
    ),
    RoutineModel(
      name: 'Ejercicio de Brazo',
      description: 'Rutina básica para brazos',
      duration: 25,
      subExercises: [
        SubExercise(
          name: 'Bicep Curl - 3x12',
          explanation: 'Sostén las mancuernas, flexiona los codos y sube el peso hacia los hombros.',
          imagePath: 'assets/images/bicep_curl.png',
        ),
        SubExercise(
          name: 'Tricep Dips - 3x10',
          explanation: 'Apoya las manos en un banco, baja el cuerpo flexionando los codos, y sube.',
          imagePath: 'assets/images/tricep_dips.png',
        ),
      ],
      order: 2,
    ),
    RoutineModel(
      name: 'Ejercicio de Espalda',
      description: 'Rutina básica para espalda',
      duration: 35,
      subExercises: [
        SubExercise(
          name: 'Dominadas - 3x8',
          explanation: 'Cuelga de una barra, sube hasta que la barbilla pase la barra, y baja controladamente.',
          imagePath: 'assets/images/pull_ups.png',
        ),
        SubExercise(
          name: 'Remo con barra - 3x10',
          explanation: 'Inclínate, jala la barra hacia el abdomen, y baja con control.',
          imagePath: 'assets/images/bar_row.png',
        ),
      ],
      order: 3,
    ),
    RoutineModel(
      name: 'Ejercicio de Core',
      description: 'Rutina básica para core',
      duration: 20,
      subExercises: [
        SubExercise(
          name: 'Plancha - 3x30s',
          explanation: 'Mantén el cuerpo en línea recta, apoyado en antebrazos y puntas de pies.',
          imagePath: 'assets/images/plank.png',
        ),
        SubExercise(
          name: 'Russian Twists - 3x20',
          explanation: 'Siéntate, inclínate ligeramente y gira el torso de lado a lado con un peso.',
          imagePath: 'assets/images/russian_twists.png',
        ),
      ],
      order: 4,
    ),
  ],
  'Intermedio': [
    // Rutinas para Intermedio (a desbloquear)
    RoutineModel(
      name: 'Ejercicio de Pierna Intermedio',
      description: 'Rutina intermedia para piernas',
      duration: 40,
      subExercises: [
        SubExercise(
          name: 'Sentadillas con peso - 4x12',
          explanation: 'Añade peso en los hombros, baja a 90° y sube con control.',
          imagePath: 'assets/images/weighted_squats.png',
        ),
        SubExercise(
          name: 'Prensa de piernas - 4x10',
          explanation: 'Usa la máquina, empuja el peso con los pies y regresa lentamente.',
          imagePath: 'assets/images/leg_press.png',
        ),
      ],
      order: 1,
    ),
  ],
  'Avanzado': [
    // Rutinas para Avanzado (a desbloquear)
    RoutineModel(
      name: 'Ejercicio de Pierna Avanzado',
      description: 'Rutina avanzada para piernas',
      duration: 50,
      subExercises: [
        SubExercise(
          name: 'Sentadillas pesadas - 5x15',
          explanation: 'Usa un peso significativo, baja controladamente y sube con fuerza.',
          imagePath: 'assets/images/heavy_squats.png',
        ),
        SubExercise(
          name: 'Peso muerto - 5x12',
          explanation: 'Levanta la barra desde el suelo, manteniendo la espalda recta.',
          imagePath: 'assets/images/deadlift.png',
        ),
      ],
      order: 1,
    ),
  ],
};
  String? _errorMessage;
  bool _isLoading = false;

  String get selectedLevel => _selectedLevel;
  List<RoutineModel> get routines {
    final allRoutines = _routines[_selectedLevel] ?? [];
    final sortedRoutines = allRoutines.where((r) => r.order <= 4).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    final unlockedRoutines = <RoutineModel>[];
    for (var routine in sortedRoutines) {
      unlockedRoutines.add(routine);
      if (!routine.isCompleted) break;
      if (routine.subExercises.where((se) => se.isCompleted).length <
          routine.subExercises.length / 2) break;
    }
    return unlockedRoutines;
  }
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  RoutineController() {
    _isLoading = true;
    notifyListeners();
    _isLoading = false;
  }

  // Método futuro para avanzar de nivel (placeholder)
  void checkLevelUp() {
    // Lógica para desbloquear el siguiente nivel basada en requisitos
    // Por ahora, placeholder
  }

  void toggleCompletion(RoutineModel routine, SubExercise subExercise) {
    final index = _routines[_selectedLevel]!.indexOf(routine);
    if (index != -1) {
      final subIndex = _routines[_selectedLevel]![index].subExercises.indexOf(subExercise);
      if (subIndex != -1) {
        _routines[_selectedLevel]![index].subExercises[subIndex].isCompleted =
            !_routines[_selectedLevel]![index].subExercises[subIndex].isCompleted;
        _routines[_selectedLevel]![index].isCompleted =
            _routines[_selectedLevel]![index].subExercises.every((se) => se.isCompleted);
        notifyListeners();
      }
    }
  }
}