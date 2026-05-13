import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/recipe_model.dart';
import '../../../core/constants/app_constants.dart';

class LocalRecipeDataSource {
  late Map<String, dynamic> _rawData;
  List<RecipeModel>? _cachedRecipes;
  List<CategoryModel>? _cachedCategories;

  Future<void> initialize() async {
    final jsonString = await rootBundle.loadString(AppConstants.recipesDataPath);
    _rawData = json.decode(jsonString) as Map<String, dynamic>;
  }

  Future<List<RecipeModel>> getAllRecipes() async {
    if (_cachedRecipes != null) return _cachedRecipes!;
    await _ensureInitialized();
    final list = (_rawData['recipes'] as List)
        .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
        .toList();
    _cachedRecipes = list;
    return list;
  }

  Future<List<CategoryModel>> getCategories() async {
    if (_cachedCategories != null) return _cachedCategories!;
    await _ensureInitialized();
    final list = (_rawData['categories'] as List)
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
    _cachedCategories = list;
    return list;
  }

  Future<List<RecipeModel>> getFeaturedRecipes() async {
    final all = await getAllRecipes();
    return all.where((r) => r.isFeatured).toList();
  }

  Future<List<RecipeModel>> getTrendingRecipes() async {
    final all = await getAllRecipes();
    return all.where((r) => r.isTrending).toList();
  }

  Future<List<RecipeModel>> getRecipesByCategory(String category) async {
    final all = await getAllRecipes();
    return all.where((r) => r.category == category).toList();
  }

  Future<List<RecipeModel>> searchRecipes(String query, {
    String? difficulty, String? category, List<String>? tags,
    int? maxCalories, int? maxTime,
  }) async {
    final all = await getAllRecipes();
    final queryLower = query.toLowerCase();
    return all.where((r) {
      final matchesQuery = query.isEmpty ||
          r.title.toLowerCase().contains(queryLower) ||
          r.description.toLowerCase().contains(queryLower) ||
          r.cuisine.toLowerCase().contains(queryLower) ||
          r.tags.any((t) => t.toLowerCase().contains(queryLower)) ||
          r.ingredients.any((i) => i.name.toLowerCase().contains(queryLower));

      final matchesDiff = difficulty == null || r.difficulty == difficulty;
      final matchesCat = category == null || r.category == category;
      final matchesTags = tags == null || tags.isEmpty ||
          tags.any((t) => r.tags.contains(t));
      final matchesCal = maxCalories == null || r.caloriesPerServing <= maxCalories;
      final matchesTime = maxTime == null || r.totalTimeMin <= maxTime;

      return matchesQuery && matchesDiff && matchesCat &&
             matchesTags && matchesCal && matchesTime;
    }).toList();
  }

  Future<RecipeModel?> getRecipeById(String id) async {
    final all = await getAllRecipes();
    try {
      return all.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  // Favorites (Hive)
  List<RecipeModel> getFavorites() {
    final box = Hive.box<RecipeModel>(AppConstants.favoritesBox);
    return box.values.toList();
  }

  Future<void> addFavorite(RecipeModel recipe) async {
    final box = Hive.box<RecipeModel>(AppConstants.favoritesBox);
    await box.put(recipe.id, recipe);
  }

  Future<void> removeFavorite(String id) async {
    final box = Hive.box<RecipeModel>(AppConstants.favoritesBox);
    await box.delete(id);
  }

  bool isFavorite(String id) {
    final box = Hive.box<RecipeModel>(AppConstants.favoritesBox);
    return box.containsKey(id);
  }

  // Recently Viewed (Hive)
  List<RecipeModel> getRecentlyViewed() {
    final box = Hive.box<RecipeModel>(AppConstants.recentlyViewedBox);
    return box.values.toList().reversed.take(AppConstants.maxRecentlyViewed).toList();
  }

  Future<void> addRecentlyViewed(RecipeModel recipe) async {
    final box = Hive.box<RecipeModel>(AppConstants.recentlyViewedBox);
    await box.delete(recipe.id); // Remove if already exists to reinsert at top
    await box.put(recipe.id, recipe);
    // Keep only last N
    if (box.length > AppConstants.maxRecentlyViewed) {
      await box.deleteAt(0);
    }
  }

  // Meal Plan (Hive)
  Map<String, dynamic> getMealPlan() {
    final box = Hive.box(AppConstants.mealPlanBox);
    return Map<String, dynamic>.from(box.toMap());
  }

  Future<void> saveMealPlan(Map<String, dynamic> plan) async {
    final box = Hive.box(AppConstants.mealPlanBox);
    await box.clear();
    await box.putAll(plan);
  }

  Future<void> _ensureInitialized() async {
    if (_rawData.isEmpty) await initialize();
  }

  Map<String, dynamic> _rawData = {};
}
