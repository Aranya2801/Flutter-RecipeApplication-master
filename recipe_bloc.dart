import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/recipe_model.dart';
import '../../../data/repositories/recipe_repository_impl.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepositoryImpl repository;

  RecipeBloc({required this.repository}) : super(RecipeInitial()) {
    on<LoadRecipesEvent>(_onLoad);
    on<LoadRecipeDetailEvent>(_onLoadDetail);
    on<LoadCategoryRecipesEvent>(_onLoadCategory);
    on<ScaleServingsEvent>(_onScaleServings);
  }

  Future<void> _onLoad(LoadRecipesEvent event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    try {
      final featured = await repository.getFeaturedRecipes();
      final trending = await repository.getTrendingRecipes();
      final categories = await repository.getCategories();
      final recent = repository.getRecentlyViewed();
      emit(RecipeLoaded(
        featuredRecipes: featured,
        trendingRecipes: trending,
        categories: categories,
        recentlyViewed: recent,
      ));
    } catch (e) {
      emit(RecipeError(message: e.toString()));
    }
  }

  Future<void> _onLoadDetail(LoadRecipeDetailEvent event, Emitter<RecipeState> emit) async {
    final currentState = state;
    emit(RecipeDetailLoading());
    try {
      final recipe = await repository.getRecipeById(event.id);
      if (recipe == null) {
        emit(const RecipeError(message: 'Recipe not found'));
        return;
      }
      await repository.addRecentlyViewed(recipe);
      final isFav = repository.isFavorite(event.id);
      final similar = await repository.getRecipesByCategory(recipe.category);
      emit(RecipeDetailLoaded(
        recipe: recipe,
        isFavorite: isFav,
        similarRecipes: similar.where((r) => r.id != recipe.id).take(5).toList(),
      ));
      // Refresh home if needed
      if (currentState is RecipeLoaded) {
        add(LoadRecipesEvent());
      }
    } catch (e) {
      emit(RecipeError(message: e.toString()));
    }
  }

  Future<void> _onLoadCategory(LoadCategoryRecipesEvent event, Emitter<RecipeState> emit) async {
    emit(RecipeCategoryLoading());
    try {
      final recipes = await repository.getRecipesByCategory(event.category);
      emit(RecipeCategoryLoaded(category: event.category, recipes: recipes));
    } catch (e) {
      emit(RecipeError(message: e.toString()));
    }
  }

  void _onScaleServings(ScaleServingsEvent event, Emitter<RecipeState> emit) {
    if (state is RecipeDetailLoaded) {
      final current = state as RecipeDetailLoaded;
      final scaled = current.recipe.copyWith(servings: event.servings);
      emit(current.copyWith(recipe: scaled));
    }
  }
}
