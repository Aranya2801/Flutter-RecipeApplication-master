part of 'recipe_bloc.dart';

// Events
abstract class RecipeEvent extends Equatable {
  @override List<Object?> get props => [];
}
class LoadRecipesEvent extends RecipeEvent {}
class LoadRecipeDetailEvent extends RecipeEvent {
  final String id;
  LoadRecipeDetailEvent(this.id);
  @override List<Object?> get props => [id];
}
class LoadCategoryRecipesEvent extends RecipeEvent {
  final String category;
  LoadCategoryRecipesEvent(this.category);
  @override List<Object?> get props => [category];
}
class ScaleServingsEvent extends RecipeEvent {
  final int servings;
  ScaleServingsEvent(this.servings);
  @override List<Object?> get props => [servings];
}

// States
abstract class RecipeState extends Equatable {
  @override List<Object?> get props => [];
}
class RecipeInitial extends RecipeState {}
class RecipeLoading extends RecipeState {}
class RecipeDetailLoading extends RecipeState {}
class RecipeCategoryLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<RecipeModel> featuredRecipes;
  final List<RecipeModel> trendingRecipes;
  final List<CategoryModel> categories;
  final List<RecipeModel> recentlyViewed;
  RecipeLoaded({
    required this.featuredRecipes, required this.trendingRecipes,
    required this.categories, required this.recentlyViewed,
  });
  @override List<Object?> get props => [featuredRecipes, trendingRecipes, categories, recentlyViewed];
}

class RecipeDetailLoaded extends RecipeState {
  final RecipeModel recipe;
  final bool isFavorite;
  final List<RecipeModel> similarRecipes;
  RecipeDetailLoaded({required this.recipe, required this.isFavorite, required this.similarRecipes});
  RecipeDetailLoaded copyWith({RecipeModel? recipe, bool? isFavorite, List<RecipeModel>? similarRecipes}) {
    return RecipeDetailLoaded(
      recipe: recipe ?? this.recipe,
      isFavorite: isFavorite ?? this.isFavorite,
      similarRecipes: similarRecipes ?? this.similarRecipes,
    );
  }
  @override List<Object?> get props => [recipe, isFavorite, similarRecipes];
}

class RecipeCategoryLoaded extends RecipeState {
  final String category;
  final List<RecipeModel> recipes;
  RecipeCategoryLoaded({required this.category, required this.recipes});
  @override List<Object?> get props => [category, recipes];
}

class RecipeError extends RecipeState {
  final String message;
  const RecipeError({required this.message});
  @override List<Object?> get props => [message];
}
