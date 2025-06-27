import 'package:flutter/material.dart';
import '../models/data_model.dart';

class DataController with ChangeNotifier {
  final List<DataModel> _data = [
    DataModel(
      title: 'Resumen Diario',
      description: 'Progreso de hoy',
      userName: 'SON GOKU',
      todayCalories: 1800,
      dailyCalorieGoal: 2200,
      todaySteps: 7500,
      dailyStepGoal: 10000,
    ),
  ];
  String? _errorMessage;
  bool _isLoading = false;

  List<DataModel> get data => _data; // Getter explícito
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  DataController() {
    _isLoading = true;
    notifyListeners();
    _isLoading = false; // Desactiva loading después de simular
  }

  Future<void> fetchData() async {
    // Este método se usará cuando conectes el backend
    // Por ahora, los datos ya están cargados en _data
  }
}