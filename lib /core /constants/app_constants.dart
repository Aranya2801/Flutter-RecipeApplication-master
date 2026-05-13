class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Saveur';
  static const String appVersion = '2.0.0';
  static const String appTagline = 'Recipe Mastery';

  // Hive Boxes
  static const String favoritesBox = 'favorites_box';
  static const String recentlyViewedBox = 'recently_viewed_box';
  static const String preferencesBox = 'preferences_box';
  static const String mealPlanBox = 'meal_plan_box';
  static const String cacheBox = 'cache_box';

  // Asset Paths
  static const String recipesDataPath = 'assets/data/recipes.json';
  static const String splashAnimation = 'assets/animations/splash.json';
  static const String emptyAnimation = 'assets/animations/empty.json';
  static const String cookingAnimation = 'assets/animations/cooking.json';
  static const String successAnimation = 'assets/animations/success.json';
  static const String timerAnimation = 'assets/animations/timer.json';

  // Limits
  static const int maxRecentlyViewed = 20;
  static const int maxSearchHistory = 10;
  static const int recipesPerPage = 15;

  // Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 350);
  static const Duration animationSlow = Duration(milliseconds: 600);
  static const Duration splashDuration = Duration(milliseconds: 2500);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration cacheExpiry = Duration(hours: 24);

  // Difficulty Levels
  static const String beginnerLevel = 'beginner';
  static const String intermediateLevel = 'intermediate';
  static const String advancedLevel = 'advanced';

  // Dietary Tags
  static const List<String> dietaryFilters = [
    'vegetarian', 'vegan', 'gluten-free', 'dairy-free',
    'keto', 'paleo', 'low-carb', 'high-protein',
  ];

  // Nutrition Goals (daily recommended)
  static const int dailyCaloriesDefault = 2000;
  static const int dailyProteinGrams = 50;
  static const int dailyCarbsGrams = 250;
  static const int dailyFatGrams = 65;

  // Spline & API
  static const String spoonacularBaseUrl = 'https://api.spoonacular.com';
  static const String unsplashBaseUrl = 'https://api.unsplash.com';
}
