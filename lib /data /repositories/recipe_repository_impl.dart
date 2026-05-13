import '../../data/datasources/local/local_recipe_datasource.dart';
import '../../data/models/recipe_model.dart';

class RecipeRepositoryImpl {
  final LocalRecipeDataSource localDataSource;
  RecipeRepositoryImpl({required this.localDataSource});

  Future<List<RecipeModel>> getAllRecipes() => localDataSource.getAllRecipes();
  Future<List<CategoryModel>> getCategories() => localDataSource.getCategories();
  Future<List<RecipeModel>> getFeaturedRecipes() => localDataSource.getFeaturedRecipes();
  Future<List<RecipeModel>> getTrendingRecipes() => localDataSource.getTrendingRecipes();
  Future<List<RecipeModel>> getRecipesByCategory(String cat) => localDataSource.getRecipesByCategory(cat);
  Future<RecipeModel?> getRecipeById(String id) => localDataSource.getRecipeById(id);

  Future<List<RecipeModel>> searchRecipes(String query, {
    String? difficulty, String? category, List<String>? tags,
    int? maxCalories, int? maxTime,
  }) => localDataSource.searchRecipes(
    query, difficulty: difficulty, category: category,
    tags: tags, maxCalories: maxCalories, maxTime: maxTime,
  );

  List<RecipeModel> getFavorites() => localDataSource.getFavorites();
  Future<void> addFavorite(RecipeModel r) => localDataSource.addFavorite(r);
  Future<void> removeFavorite(String id) => localDataSource.removeFavorite(id);
  bool isFavorite(String id) => localDataSource.isFavorite(id);

  List<RecipeModel> getRecentlyViewed() => localDataSource.getRecentlyViewed();
  Future<void> addRecentlyViewed(RecipeModel r) => localDataSource.addRecentlyViewed(r);

  Map<String, dynamic> getMealPlan() => localDataSource.getMealPlan();
  Future<void> saveMealPlan(Map<String, dynamic> plan) => localDataSource.saveMealPlan(plan);
}
