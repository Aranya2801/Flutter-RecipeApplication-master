import 'package:hive/hive.dart';

part 'user_preferences_model.g.dart';

@HiveType(typeId: 1)
class UserPreferencesModel extends HiveObject {
  @HiveField(0) String userName;
  @HiveField(1) String? userAvatar;
  @HiveField(2) List<String> dietaryPreferences;
  @HiveField(3) List<String> allergens;
  @HiveField(4) int dailyCalorieGoal;
  @HiveField(5) String skillLevel;
  @HiveField(6) bool notificationsEnabled;
  @HiveField(7) String preferredCuisine;
  @HiveField(8) int weeklyMealPlanDays;
  @HiveField(9) bool hasCompletedOnboarding;
  @HiveField(10) List<String> searchHistory;
  @HiveField(11) String measurementSystem; // 'metric' or 'imperial'

  UserPreferencesModel({
    this.userName = 'Chef',
    this.userAvatar,
    this.dietaryPreferences = const [],
    this.allergens = const [],
    this.dailyCalorieGoal = 2000,
    this.skillLevel = 'intermediate',
    this.notificationsEnabled = true,
    this.preferredCuisine = '',
    this.weeklyMealPlanDays = 7,
    this.hasCompletedOnboarding = false,
    this.searchHistory = const [],
    this.measurementSystem = 'metric',
  });
}
