import 'package:flutter/material.dart';
import '../models/progress_models.dart';
import '../services/api_service.dart';

class ProgressProvider with ChangeNotifier {
  List<XpTransactionDto> _xpHistory = [];
  int _currentXp = 0;
  List<UserAchievementDto> _achievements = [];
  List<AchievementDto> _availableAchievements = [];
  List<ChallengeDto> _challenges = [];
  List<UserChallengeDto> _myChallenges = [];
  List<RewardDto> _rewards = [];
  List<UserRewardDto> _myRewards = [];
  DailyStatDto? _todayStats;
  List<DailyStatDto> _weeklyStats = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<XpTransactionDto> get xpHistory => _xpHistory;
  int get currentXp => _currentXp;
  List<UserAchievementDto> get achievements => _achievements;
  List<AchievementDto> get availableAchievements => _availableAchievements;
  List<ChallengeDto> get challenges => _challenges;
  List<UserChallengeDto> get myChallenges => _myChallenges;
  List<RewardDto> get rewards => _rewards;
  List<UserRewardDto> get myRewards => _myRewards;
  DailyStatDto? get todayStats => _todayStats;
  List<DailyStatDto> get weeklyStats => _weeklyStats;
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

  // XP Management
  Future<void> loadXpHistory() async {
    _setLoading(true);
    _setError(null);

    try {
      final history = await ApiService.instance.getXpHistory();
      _xpHistory = history;
      _setError(null);
    } catch (e) {
      _setError('Error cargando historial XP: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadCurrentXp() async {
    _setLoading(true);
    _setError(null);

    try {
      final xp = await ApiService.instance.getCurrentXp();
      _currentXp = xp;
      _setError(null);
    } catch (e) {
      _setError('Error cargando XP actual: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Achievements Management
  Future<void> loadAchievements() async {
    _setLoading(true);
    _setError(null);

    try {
      final achievements = await ApiService.instance.getAchievements();
      _achievements = achievements;
      _setError(null);
    } catch (e) {
      _setError('Error cargando logros: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadAvailableAchievements() async {
    _setLoading(true);
    _setError(null);

    try {
      final achievements = await ApiService.instance.getAvailableAchievements();
      _availableAchievements = achievements;
      _setError(null);
    } catch (e) {
      _setError('Error cargando logros disponibles: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> unlockAchievement(int achievementId) async {
    _setLoading(true);
    _setError(null);

    try {
      final success =
          await ApiService.instance.unlockAchievement(achievementId);
      if (success) {
        // Recargar logros después de desbloquear
        await loadAchievements();
        await loadCurrentXp();
        _setError(null);
        return true;
      } else {
        _setError('Error desbloqueando logro');
        return false;
      }
    } catch (e) {
      _setError('Error desbloqueando logro: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Challenges Management
  Future<void> loadChallenges() async {
    _setLoading(true);
    _setError(null);

    try {
      final challenges = await ApiService.instance.getChallenges();
      _challenges = challenges;
      _setError(null);
    } catch (e) {
      _setError('Error cargando desafíos: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMyChallenges() async {
    _setLoading(true);
    _setError(null);

    try {
      final myChallenges = await ApiService.instance.getMyChallenges();
      _myChallenges = myChallenges;
      _setError(null);
    } catch (e) {
      _setError('Error cargando mis desafíos: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> joinChallenge(int challengeId) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await ApiService.instance.joinChallenge(challengeId);
      if (success) {
        // Recargar mis desafíos después de unirse
        await loadMyChallenges();
        _setError(null);
        return true;
      } else {
        _setError('Error uniéndose al desafío');
        return false;
      }
    } catch (e) {
      _setError('Error uniéndose al desafío: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateChallengeProgress(int challengeId, int progress) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await ApiService.instance
          .updateChallengeProgress(challengeId, progress);
      if (success) {
        // Actualizar el progreso en la lista local
        final index =
            _myChallenges.indexWhere((c) => c.challengeId == challengeId);
        if (index != -1) {
          _myChallenges[index] =
              _myChallenges[index].copyWith(progress: progress);
        }
        _setError(null);
        return true;
      } else {
        _setError('Error actualizando progreso del desafío');
        return false;
      }
    } catch (e) {
      _setError('Error actualizando progreso del desafío: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Rewards Management
  Future<void> loadRewards() async {
    _setLoading(true);
    _setError(null);

    try {
      final rewards = await ApiService.instance.getRewards();
      _rewards = rewards;
      _setError(null);
    } catch (e) {
      _setError('Error cargando recompensas: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMyRewards() async {
    _setLoading(true);
    _setError(null);

    try {
      final myRewards = await ApiService.instance.getMyRewards();
      _myRewards = myRewards;
      _setError(null);
    } catch (e) {
      _setError('Error cargando mis recompensas: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> redeemReward(int rewardId) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await ApiService.instance.redeemReward(rewardId);
      if (success) {
        // Recargar recompensas y XP después de canjear
        await loadMyRewards();
        await loadCurrentXp();
        _setError(null);
        return true;
      } else {
        _setError('Error canjeando recompensa');
        return false;
      }
    } catch (e) {
      _setError('Error canjeando recompensa: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Stats Management
  Future<void> loadTodayStats() async {
    _setLoading(true);
    _setError(null);

    try {
      final stats = await ApiService.instance.getDailyStats(DateTime.now());
      _todayStats = stats;
      _setError(null);
    } catch (e) {
      _setError('Error cargando estadísticas de hoy: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadWeeklyStats() async {
    _setLoading(true);
    _setError(null);

    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));

      final stats =
          await ApiService.instance.getStatsRange(startOfWeek, endOfWeek);
      _weeklyStats = stats;
      _setError(null);
    } catch (e) {
      _setError('Error cargando estadísticas semanales: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateDailyStats(DailyStatDto stats) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await ApiService.instance.updateDailyStats(stats);
      if (success) {
        _todayStats = stats;
        _setError(null);
        return true;
      } else {
        _setError('Error actualizando estadísticas');
        return false;
      }
    } catch (e) {
      _setError('Error actualizando estadísticas: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Utility methods
  void clearError() {
    _setError(null);
  }

  // Getters for filtered data
  List<UserChallengeDto> getActiveChallenges() {
    return _myChallenges.where((c) => c.completedAt == null).toList();
  }

  List<UserChallengeDto> getCompletedChallenges() {
    return _myChallenges.where((c) => c.completedAt != null).toList();
  }

  List<UserRewardDto> getRedeemedRewards() {
    return _myRewards.where((r) => r.status == 'redeemed').toList();
  }

  List<UserRewardDto> getPendingRewards() {
    return _myRewards.where((r) => r.status == 'pending').toList();
  }

  // Calculate progress percentage for challenges
  double getChallengeProgress(UserChallengeDto challenge) {
    if (challenge.challenge == null) return 0.0;
    return (challenge.progress / challenge.challenge!.goalValue)
        .clamp(0.0, 1.0);
  }

  // Get total calories burned this week
  int getWeeklyCaloriesBurned() {
    return _weeklyStats.fold(0, (sum, stat) => sum + stat.caloriesOut);
  }

  // Get total calories consumed this week
  int getWeeklyCaloriesConsumed() {
    return _weeklyStats.fold(0, (sum, stat) => sum + stat.caloriesIn);
  }

  // Get total steps this week
  int getWeeklySteps() {
    return _weeklyStats.fold(0, (sum, stat) => sum + stat.steps);
  }

  // Get total XP earned this week
  int getWeeklyXpEarned() {
    return _weeklyStats.fold(0, (sum, stat) => sum + (stat.xpEarned ?? 0));
  }
}

// Extension para facilitar la creación de copias
extension UserChallengeDtoExtension on UserChallengeDto {
  UserChallengeDto copyWith({
    int? userId,
    int? challengeId,
    int? progress,
    DateTime? completedAt,
    ChallengeDto? challenge,
  }) {
    return UserChallengeDto(
      userId: userId ?? this.userId,
      challengeId: challengeId ?? this.challengeId,
      progress: progress ?? this.progress,
      completedAt: completedAt ?? this.completedAt,
      challenge: challenge ?? this.challenge,
    );
  }
}
