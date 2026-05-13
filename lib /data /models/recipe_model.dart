import 'package:hive/hive.dart';

part 'recipe_model.g.dart';

@HiveType(typeId: 0)
class RecipeModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String title;
  @HiveField(2) final String category;
  @HiveField(3) final String cuisine;
  @HiveField(4) final List<String> tags;
  @HiveField(5) final String difficulty;
  @HiveField(6) final int prepTimeMin;
  @HiveField(7) final int cookTimeMin;
  @HiveField(8) final int servings;
  @HiveField(9) final int caloriesPerServing;
  @HiveField(10) final double rating;
  @HiveField(11) final int ratingCount;
  @HiveField(12) final bool isFeatured;
  @HiveField(13) final bool isTrending;
  @HiveField(14) final String description;
  @HiveField(15) final String imageUrl;
  @HiveField(16) final String author;
  @HiveField(17) final Map<String, dynamic> nutritionData;
  @HiveField(18) final List<Map<String, dynamic>> ingredientsData;
  @HiveField(19) final List<Map<String, dynamic>> stepsData;
  @HiveField(20) final String? videoUrl;
  @HiveField(21) final String? authorAvatar;
  @HiveField(22) final String? winePairing;
  @HiveField(23) final String? storage;
  @HiveField(24) final String createdAt;

  RecipeModel({
    required this.id,
    required this.title,
    required this.category,
    required this.cuisine,
    required this.tags,
    required this.difficulty,
    required this.prepTimeMin,
    required this.cookTimeMin,
    required this.servings,
    required this.caloriesPerServing,
    required this.rating,
    required this.ratingCount,
    required this.isFeatured,
    required this.isTrending,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.nutritionData,
    required this.ingredientsData,
    required this.stepsData,
    this.videoUrl,
    this.authorAvatar,
    this.winePairing,
    this.storage,
    required this.createdAt,
  });

  int get totalTimeMin => prepTimeMin + cookTimeMin;

  NutritionInfo get nutrition => NutritionInfo.fromMap(nutritionData);
  List<Ingredient> get ingredients => ingredientsData.map(Ingredient.fromMap).toList();
  List<RecipeStep> get steps => stepsData.map(RecipeStep.fromMap).toList();

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      cuisine: json['cuisine'] as String,
      tags: List<String>.from(json['tags'] as List),
      difficulty: json['difficulty'] as String,
      prepTimeMin: json['prep_time_min'] as int,
      cookTimeMin: json['cook_time_min'] as int,
      servings: json['servings'] as int,
      caloriesPerServing: json['calories_per_serving'] as int,
      rating: (json['rating'] as num).toDouble(),
      ratingCount: json['rating_count'] as int,
      isFeatured: json['is_featured'] as bool? ?? false,
      isTrending: json['is_trending'] as bool? ?? false,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      author: json['author'] as String,
      nutritionData: Map<String, dynamic>.from(json['nutrition'] as Map),
      ingredientsData: List<Map<String, dynamic>>.from(
        (json['ingredients'] as List).map((e) => Map<String, dynamic>.from(e as Map)),
      ),
      stepsData: List<Map<String, dynamic>>.from(
        (json['steps'] as List).map((e) => Map<String, dynamic>.from(e as Map)),
      ),
      videoUrl: json['video_url'] as String?,
      authorAvatar: json['author_avatar'] as String?,
      winePairing: json['wine_pairing'] as String?,
      storage: json['storage'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  RecipeModel copyWith({int? servings}) {
    final multiplier = (servings ?? this.servings) / this.servings;
    final scaledIngredients = ingredientsData.map((ing) {
      final amount = (ing['amount'] as num).toDouble() * multiplier;
      return {...ing, 'amount': amount};
    }).toList();

    return RecipeModel(
      id: id, title: title, category: category, cuisine: cuisine,
      tags: tags, difficulty: difficulty, prepTimeMin: prepTimeMin,
      cookTimeMin: cookTimeMin, servings: servings ?? this.servings,
      caloriesPerServing: caloriesPerServing, rating: rating,
      ratingCount: ratingCount, isFeatured: isFeatured, isTrending: isTrending,
      description: description, imageUrl: imageUrl, author: author,
      nutritionData: nutritionData, ingredientsData: scaledIngredients,
      stepsData: stepsData, videoUrl: videoUrl, authorAvatar: authorAvatar,
      winePairing: winePairing, storage: storage, createdAt: createdAt,
    );
  }
}

class NutritionInfo {
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;
  final double sugarG;
  final int sodiumMg;
  final int cholesterolMg;

  const NutritionInfo({
    required this.calories, required this.proteinG, required this.carbsG,
    required this.fatG, required this.fiberG, required this.sugarG,
    required this.sodiumMg, required this.cholesterolMg,
  });

  factory NutritionInfo.fromMap(Map<String, dynamic> map) {
    return NutritionInfo(
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      proteinG: (map['protein_g'] as num?)?.toDouble() ?? 0,
      carbsG: (map['carbs_g'] as num?)?.toDouble() ?? 0,
      fatG: (map['fat_g'] as num?)?.toDouble() ?? 0,
      fiberG: (map['fiber_g'] as num?)?.toDouble() ?? 0,
      sugarG: (map['sugar_g'] as num?)?.toDouble() ?? 0,
      sodiumMg: (map['sodium_mg'] as num?)?.toInt() ?? 0,
      cholesterolMg: (map['cholesterol_mg'] as num?)?.toInt() ?? 0,
    );
  }
}

class Ingredient {
  final String id;
  final String name;
  final double amount;
  final String unit;
  final String? notes;
  bool isChecked;

  Ingredient({
    required this.id, required this.name, required this.amount,
    required this.unit, this.notes, this.isChecked = false,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'] as String? ?? '',
      name: map['name'] as String,
      amount: (map['amount'] as num).toDouble(),
      unit: map['unit'] as String,
      notes: map['notes'] as String?,
    );
  }

  String get formattedAmount {
    if (amount == amount.toInt()) return amount.toInt().toString();
    return amount.toStringAsFixed(1);
  }

  String get displayText => '$formattedAmount $unit $name';
}

class RecipeStep {
  final int stepNumber;
  final String title;
  final String description;
  final int? timerSeconds;
  final String? tip;
  bool isCompleted;

  RecipeStep({
    required this.stepNumber, required this.title,
    required this.description, this.timerSeconds,
    this.tip, this.isCompleted = false,
  });

  factory RecipeStep.fromMap(Map<String, dynamic> map) {
    return RecipeStep(
      stepNumber: map['step_number'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      timerSeconds: map['timer_seconds'] as int?,
      tip: map['tip'] as String?,
    );
  }

  bool get hasTimer => timerSeconds != null && timerSeconds! > 0;

  String get formattedTimer {
    if (timerSeconds == null) return '';
    final minutes = timerSeconds! ~/ 60;
    final seconds = timerSeconds! % 60;
    if (minutes == 0) return '${seconds}s';
    if (seconds == 0) return '${minutes}m';
    return '${minutes}m ${seconds}s';
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String color;
  final int recipeCount;
  final String imageUrl;

  const CategoryModel({
    required this.id, required this.name, required this.icon,
    required this.color, required this.recipeCount, required this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      recipeCount: json['recipe_count'] as int,
      imageUrl: json['image_url'] as String,
    );
  }
}
