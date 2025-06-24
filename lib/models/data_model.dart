class DataModel {
  final String title;
  final String description;
  final String? userName;
  final int? todayCalories;
  final int? dailyCalorieGoal;
  final int? todaySteps;
  final int? dailyStepGoal;
  final List<String>? recommendations;

  DataModel({
    this.title = '',
    this.description = '',
    this.userName,
    this.todayCalories,
    this.dailyCalorieGoal,
    this.todaySteps,
    this.dailyStepGoal,
    this.recommendations,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      userName: json['userName'] as String?,
      todayCalories: json['todayCalories'] as int?,
      dailyCalorieGoal: json['dailyCalorieGoal'] as int?,
      todaySteps: json['todaySteps'] as int?,
      dailyStepGoal: json['dailyStepGoal'] as int?,
      recommendations: json['recommendations'] != null 
          ? List<String>.from(json['recommendations'] as List)
          : null,
    );
  }
}