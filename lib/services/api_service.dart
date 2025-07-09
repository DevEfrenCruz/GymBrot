import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_models.dart';
import '../models/user_model.dart';
import '../models/routine_models.dart';
import '../models/progress_models.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5004/api';
  static const String tokenKey = 'auth_token';

  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._();

  ApiService._();

  // Headers helpers
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
      };

  Future<Map<String, String>> get _authHeaders async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Token management
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // Auth endpoints
  Future<bool> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/register'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error en registro: $e');
      return false;
    }
  }

  Future<String?> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/login'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String?;
        if (token != null) {
          await _saveToken(token);
          return token;
        }
      }
      return null;
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }

  Future<UserDto?> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Auth/profile'),
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserDto.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error obteniendo perfil: $e');
      return null;
    }
  }

  Future<bool> updateProfile(UserDto user) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/Auth/profile'),
        headers: await _authHeaders,
        body: jsonEncode(user.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error actualizando perfil: $e');
      return false;
    }
  }

  Future<bool> changePassword(ChangePasswordRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/change-password'),
        headers: await _authHeaders,
        body: jsonEncode(request.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error cambiando contraseña: $e');
      return false;
    }
  }

  Future<bool> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/forgot-password'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error en forgot password: $e');
      return false;
    }
  }

  Future<bool> completeProfile(CompleteProfileRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/complete-profile'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error en complete-profile: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _removeToken();
  }

  // Progress endpoints
  Future<List<XpTransactionDto>> getXpHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Progress/xp/history'),
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((e) => XpTransactionDto.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error obteniendo historial XP: $e');
      return [];
    }
  }

  Future<int> getCurrentXp() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Progress/xp/current'),
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['currentXp'] as int;
      }
      return 0;
    } catch (e) {
      print('Error obteniendo XP actual: $e');
      return 0;
    }
  }

  Future<List<UserAchievementDto>> getAchievements() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Progress/achievements'),
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((e) => UserAchievementDto.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error obteniendo logros: $e');
      return [];
    }
  }

  Future<List<AchievementDto>> getAvailableAchievements() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Progress/achievements/available'),
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((e) => AchievementDto.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error obteniendo logros disponibles: $e');
      return [];
    }
  }

  Future<bool> unlockAchievement(int achievementId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Progress/achievements/$achievementId/unlock'),
        headers: await _authHeaders,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error desbloqueando logro: $e');
      return false;
    }
  }

  Future<List<ChallengeDto>> getChallenges() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Progress/challenges'),
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((e) => ChallengeDto.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error obteniendo desafíos: $e');
      return [];
    }
  }

  Future<List<UserChallengeDto>> getMyChallenges() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Progress/challenges/my'),
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((e) => UserChallengeDto.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error obteniendo mis desafíos: $e');
      return [];
    }
  }

  Future<bool> joinChallenge(int challengeId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Progress/challenges/$challengeId/join'),
        headers: await _authHeaders,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error uniéndose al desafío: $e');
      return false;
    }
  }

  Future<bool> updateChallengeProgress(int challengeId, int progress) async {
    try {
      final request = UpdateChallengeProgressRequest(progress: progress);
      final response = await http.put(
        Uri.parse('$baseUrl/Progress/challenges/$challengeId/progress'),
        headers: await _authHeaders,
        body: jsonEncode(request.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error actualizando progreso del desafío: $e');
      return false;
    }
  }

  Future<List<RewardDto>> getRewards() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Progress/rewards'),
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((e) => RewardDto.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error obteniendo recompensas: $e');
      return [];
    }
  }

  Future<List<UserRewardDto>> getMyRewards() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Progress/rewards/my'),
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((e) => UserRewardDto.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error obteniendo mis recompensas: $e');
      return [];
    }
  }

  Future<bool> redeemReward(int rewardId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Progress/rewards/$rewardId/redeem'),
        headers: await _authHeaders,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error canjeando recompensa: $e');
      return false;
    }
  }

  Future<DailyStatDto?> getDailyStats(DateTime date) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final response = await http.get(
        Uri.parse('$baseUrl/Progress/stats/daily/$dateStr'),
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DailyStatDto.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error obteniendo estadísticas diarias: $e');
      return null;
    }
  }

  Future<bool> updateDailyStats(DailyStatDto stats) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/Progress/stats/daily'),
        headers: await _authHeaders,
        body: jsonEncode(stats.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error actualizando estadísticas diarias: $e');
      return false;
    }
  }

  Future<List<DailyStatDto>> getStatsRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final startStr = startDate.toIso8601String().split('T')[0];
      final endStr = endDate.toIso8601String().split('T')[0];

      final response = await http.get(
        Uri.parse(
            '$baseUrl/Progress/stats/range?startDate=$startStr&endDate=$endStr'),
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((e) => DailyStatDto.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error obteniendo estadísticas por rango: $e');
      return [];
    }
  }

  // Routines endpoints
  Future<List<RoutineDto>> getRoutines({RoutineLevel? level}) async {
    try {
      final queryParams = <String, String>{};
      if (level != null) {
        queryParams['level'] = level.index.toString();
      }

      final uri =
          Uri.parse('$baseUrl/Routines').replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((e) => RoutineDto.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error obteniendo rutinas: $e');
      return [];
    }
  }

  Future<RoutineDto?> getRoutine(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Routines/$id'),
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return RoutineDto.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error obteniendo rutina: $e');
      return null;
    }
  }

  Future<UserRoutineDto?> startRoutine(StartRoutineRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Routines/start'),
        headers: await _authHeaders,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserRoutineDto.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error iniciando rutina: $e');
      return null;
    }
  }

  Future<_ApiResponse> completeRoutineWithResponse(int userRoutineId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Routines/complete/$userRoutineId'),
        headers: await _authHeaders,
      );
      if (response.statusCode == 200) {
        return _ApiResponse(success: true);
      } else {
        String? message;
        try {
          final data = jsonDecode(response.body);
          message = data['message'] as String?;
        } catch (_) {}
        return _ApiResponse(success: false, message: message);
      }
    } catch (e) {
      print('Error completando rutina: $e');
      return _ApiResponse(
          success: false, message: 'Error completando rutina: $e');
    }
  }

  Future<bool> completeStep(CompleteStepRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Routines/steps/${request.stepId}/complete'),
        headers: await _authHeaders,
        body: jsonEncode(request.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error completando paso: $e');
      return false;
    }
  }

  Future<List<UserRoutineDto>> getMyRoutines() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Routines/my-routines'),
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((e) => UserRoutineDto.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error obteniendo mis rutinas: $e');
      return [];
    }
  }

  Future<UserRoutineDto?> getMyRoutine(int userRoutineId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Routines/my-routines/$userRoutineId'),
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserRoutineDto.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error obteniendo mi rutina: $e');
      return null;
    }
  }

  Future<List<ExerciseDto>> getExercises({MuscleGroup? muscleGroup}) async {
    try {
      final queryParams = <String, String>{};
      if (muscleGroup != null) {
        queryParams['muscleGroup'] = muscleGroup.index.toString();
      }

      final uri = Uri.parse('$baseUrl/Routines/exercises')
          .replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((e) => ExerciseDto.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error obteniendo ejercicios: $e');
      return [];
    }
  }

  Future<ExerciseDto?> getExercise(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Routines/exercises/$id'),
        headers: await _authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ExerciseDto.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error obteniendo ejercicio: $e');
      return null;
    }
  }
}

class _ApiResponse {
  final bool success;
  final String? message;
  _ApiResponse({required this.success, this.message});
}
