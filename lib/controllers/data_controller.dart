import 'package:flutter/material.dart';
import '../models/data_model.dart';

class DataController with ChangeNotifier {
  final List<DataModel> _data = [
    DataModel(
      title: 'Resumen Diario',
      description: 'Progreso de hoy',
      userName: 'Juan Pérez',
      todayCalories: 1800,
      dailyCalorieGoal: 2200,
      todaySteps: 7500,
      dailyStepGoal: 10000,
    ),
  ];
  String? _errorMessage;
  bool _isLoading = false;

  List<DataModel> get data => _data;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  DataController() {
    // Simula carga inicial
    _isLoading = true;
    notifyListeners();
    _isLoading = false;
  }

  Future<void> fetchData() async {
    // Por ahora, los datos ya están cargados en _data
  }
}
