import 'package:flutter/material.dart';
import '../models/data_model.dart';

class DataController with ChangeNotifier {
  List<DataModel> _workouts = [];
  late DataModel _userData;
  bool _isLoading = false;
  String? _errorMessage;

  List<DataModel> get workouts => _workouts;
  DataModel get userData => _userData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  DataController() {
    _userData = DataModel(); // Inicialización segura
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _workouts = [
        DataModel(
          title: 'Ejercicio de Pierna', 
          description: 'Sentadillas - 3 series de 10 repeticiones'
        ),
        DataModel(
          title: 'Ejercicio de Brazo', 
          description: 'Bicep Curl - 3 series de 12 repeticiones'
        ),
        DataModel(
          title: 'Ejercicio de Espalda', 
          description: 'Dominadas - 3 series de 8 repeticiones'
        ),
      ];
      
      _userData = DataModel(
        userName: 'Jose Delgado',
        todayCalories: 1850,
        dailyCalorieGoal: 2200,
        todaySteps: 8750,
        dailyStepGoal: 10000,
        recommendations: [
          'Notificaciones y Desafíos',
          'Entrenamiento: Cardio Intenso',
          'Descanso: 3 días recomendados'
        ],
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error al cargar datos simulados: ${e.toString()}";
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulación de llamada API - Reemplazar con implementación real
      await Future.delayed(const Duration(seconds: 2));
      
      // Ejemplo de cómo sería con API real:
      // final response = await http.get(Uri.parse('https://tu-api.com/data'));
      // if (response.statusCode == 200) {
      //   final jsonData = json.decode(response.body);
      //   _workouts = (jsonData['workouts'] as List)
      //       .map((item) => DataModel.fromJson(item))
      //       .toList();
      //   _userData = DataModel.fromJson(jsonData['userData']);
      // } else {
      //   throw Exception('Error al cargar datos');
      // }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error de conexión: ${e.toString()}";
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}