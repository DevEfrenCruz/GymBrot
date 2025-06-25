class DataModel {
  final String title;
  final String description;
  final String? userName;
  final int? todayCalories;
  final int? dailyCalorieGoal;
  final int? todaySteps;
  final int? dailyStepGoal;

  DataModel({
    required this.title,
    required this.description,
    this.userName,
    this.todayCalories,
    this.dailyCalorieGoal,
    this.todaySteps,
    this.dailyStepGoal,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      title: json['title'] as String,
      description: json['description'] as String,
      userName: json['userName'] as String?,
      todayCalories: json['todayCalories'] as int?,
      dailyCalorieGoal: json['dailyCalorieGoal'] as int?,
      todaySteps: json['todaySteps'] as int?,
      dailyStepGoal: json['dailyStepGoal'] as int?,
    );
  }
}