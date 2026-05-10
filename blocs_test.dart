import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_recipe_app/data/models/recipe_model.dart';
import 'package:flutter_recipe_app/data/repositories/recipe_repository_impl.dart';
import 'package:flutter_recipe_app/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_recipe_app/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:flutter_recipe_app/presentation/blocs/search/search_bloc.dart';

class MockRecipeRepository extends Mock implements RecipeRepositoryImpl {}

// ─────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────
RecipeModel _fakeRecipe({String id = 'r001'}) => RecipeModel(
  id: id,
  title: 'Truffle Risotto',
  category: 'Italian',
  cuisine: 'Italian',
  tags: ['vegetarian', 'gourmet'],
  difficulty: 'intermediate',
  prepTimeMin: 15,
  cookTimeMin: 35,
  servings: 4,
  caloriesPerServing: 520,
  rating: 4.8,
  ratingCount: 1247,
  isFeatured: true,
  isTrending: true,
  description: 'A luxurious risotto.',
  imageUrl: 'https://example.com/image.jpg',
  author: 'Chef Marco',
  nutritionData: {
    'calories': 520, 'protein_g': 18, 'carbs_g': 68,
    'fat_g': 20, 'fiber_g': 4, 'sugar_g': 3,
    'sodium_mg': 720, 'cholesterol_mg': 45,
  },
  ingredientsData: [
    {'id': 'i1', 'name': 'Arborio rice', 'amount': 400, 'unit': 'g'},
  ],
  stepsData: [
    {'step_number': 1, 'title': 'Prepare', 'description': 'Warm stock.', 'timer_seconds': null},
  ],
  createdAt: '2024-01-15T10:00:00Z',
);

// ─────────────────────────────────────────────────────────────
// RecipeModel Tests
// ─────────────────────────────────────────────────────────────
void main() {
  group('RecipeModel', () {
    test('totalTimeMin returns sum of prep and cook time', () {
      final recipe = _fakeRecipe();
      expect(recipe.totalTimeMin, equals(50));
    });

    test('copyWith scales ingredient amounts', () {
      final recipe = _fakeRecipe();
      final scaled = recipe.copyWith(servings: 8); // double
      final ingredient = scaled.ingredients.first;
      expect(ingredient.amount, equals(800));
    });

    test('formattedAmount returns integer string for whole numbers', () {
      final ing = Ingredient(id: 'i1', name: 'Rice', amount: 400.0, unit: 'g');
      expect(ing.formattedAmount, equals('400'));
    });

    test('formattedAmount returns decimal for fractions', () {
      final ing = Ingredient(id: 'i1', name: 'Salt', amount: 0.5, unit: 'tsp');
      expect(ing.formattedAmount, equals('0.5'));
    });

    test('NutritionInfo parses correctly from map', () {
      final nutrition = NutritionInfo.fromMap({
        'calories': 520, 'protein_g': 18.0, 'carbs_g': 68.0,
        'fat_g': 20.0, 'fiber_g': 4.0, 'sugar_g': 3.0,
        'sodium_mg': 720, 'cholesterol_mg': 45,
      });
      expect(nutrition.calories, equals(520));
      expect(nutrition.proteinG, equals(18.0));
    });

    test('RecipeStep hasTimer returns false when timerSeconds is null', () {
      final step = RecipeStep(
        stepNumber: 1, title: 'Prep', description: 'Do stuff.', timerSeconds: null,
      );
      expect(step.hasTimer, isFalse);
    });

    test('RecipeStep formattedTimer formats minutes correctly', () {
      final step = RecipeStep(
        stepNumber: 1, title: 'Cook', description: 'Cook it.', timerSeconds: 300,
      );
      expect(step.formattedTimer, equals('5m'));
    });

    test('RecipeStep formattedTimer formats minutes and seconds', () {
      final step = RecipeStep(
        stepNumber: 1, title: 'Cook', description: 'Cook it.', timerSeconds: 95,
      );
      expect(step.formattedTimer, equals('1m 35s'));
    });
  });

  // ─────────────────────────────────────────────────────────────
  // RecipeBloc Tests
  // ─────────────────────────────────────────────────────────────
  group('RecipeBloc', () {
    late MockRecipeRepository repository;
    late RecipeBloc bloc;

    final categories = [
      CategoryModel(id: 'c1', name: 'Italian', icon: '🍝', color: '#E8401C', recipeCount: 48, imageUrl: ''),
    ];

    setUpAll(() => registerFallbackValue(_fakeRecipe()));

    setUp(() {
      repository = MockRecipeRepository();
      bloc = RecipeBloc(repository: repository);
    });

    tearDown(() => bloc.close());

    blocTest<RecipeBloc, RecipeState>(
      'emits [RecipeLoading, RecipeLoaded] on LoadRecipesEvent success',
      build: () {
        when(() => repository.getFeaturedRecipes()).thenAnswer((_) async => [_fakeRecipe()]);
        when(() => repository.getTrendingRecipes()).thenAnswer((_) async => [_fakeRecipe(id: 'r002')]);
        when(() => repository.getCategories()).thenAnswer((_) async => categories);
        when(() => repository.getRecentlyViewed()).thenReturn([]);
        return bloc;
      },
      act: (b) => b.add(LoadRecipesEvent()),
      expect: () => [
        isA<RecipeLoading>(),
        isA<RecipeLoaded>(),
      ],
    );

    blocTest<RecipeBloc, RecipeState>(
      'emits [RecipeLoading, RecipeError] on repository failure',
      build: () {
        when(() => repository.getFeaturedRecipes()).thenThrow(Exception('Network error'));
        when(() => repository.getTrendingRecipes()).thenAnswer((_) async => []);
        when(() => repository.getCategories()).thenAnswer((_) async => []);
        when(() => repository.getRecentlyViewed()).thenReturn([]);
        return bloc;
      },
      act: (b) => b.add(LoadRecipesEvent()),
      expect: () => [isA<RecipeLoading>(), isA<RecipeError>()],
    );

    blocTest<RecipeBloc, RecipeState>(
      'emits [RecipeDetailLoading, RecipeDetailLoaded] on LoadRecipeDetailEvent',
      build: () {
        final recipe = _fakeRecipe();
        when(() => repository.getRecipeById('r001')).thenAnswer((_) async => recipe);
        when(() => repository.isFavorite('r001')).thenReturn(false);
        when(() => repository.getRecipesByCategory('Italian')).thenAnswer((_) async => [recipe]);
        when(() => repository.addRecentlyViewed(any())).thenAnswer((_) async {});
        return bloc;
      },
      act: (b) => b.add(LoadRecipeDetailEvent('r001')),
      expect: () => [isA<RecipeDetailLoading>(), isA<RecipeDetailLoaded>()],
    );

    blocTest<RecipeBloc, RecipeState>(
      'ScaleServingsEvent updates recipe servings in RecipeDetailLoaded state',
      build: () {
        final recipe = _fakeRecipe();
        when(() => repository.getRecipeById('r001')).thenAnswer((_) async => recipe);
        when(() => repository.isFavorite('r001')).thenReturn(false);
        when(() => repository.getRecipesByCategory('Italian')).thenAnswer((_) async => [recipe]);
        when(() => repository.addRecentlyViewed(any())).thenAnswer((_) async {});
        return bloc;
      },
      act: (b) async {
        b.add(LoadRecipeDetailEvent('r001'));
        await Future.delayed(const Duration(milliseconds: 100));
        b.add(ScaleServingsEvent(8));
      },
      expect: () => [
        isA<RecipeDetailLoading>(),
        isA<RecipeDetailLoaded>(),
        isA<RecipeDetailLoaded>(),
      ],
      verify: (b) {
        final state = b.state as RecipeDetailLoaded;
        expect(state.recipe.servings, equals(8));
      },
    );
  });

  // ─────────────────────────────────────────────────────────────
  // FavoritesBloc Tests
  // ─────────────────────────────────────────────────────────────
  group('FavoritesBloc', () {
    late MockRecipeRepository repository;
    late FavoritesBloc bloc;

    setUpAll(() => registerFallbackValue(_fakeRecipe()));

    setUp(() {
      repository = MockRecipeRepository();
      bloc = FavoritesBloc(repository: repository);
    });

    tearDown(() => bloc.close());

    blocTest<FavoritesBloc, FavoritesState>(
      'emits [FavoritesLoaded] on LoadFavoritesEvent',
      build: () {
        when(() => repository.getFavorites()).thenReturn([_fakeRecipe()]);
        return bloc;
      },
      act: (b) => b.add(LoadFavoritesEvent()),
      expect: () => [isA<FavoritesLoaded>()],
      verify: (b) {
        final state = b.state as FavoritesLoaded;
        expect(state.favorites.length, equals(1));
      },
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'ToggleFavoriteEvent adds recipe when not favorite',
      build: () {
        final recipe = _fakeRecipe();
        when(() => repository.isFavorite('r001')).thenReturn(false);
        when(() => repository.addFavorite(any())).thenAnswer((_) async {});
        when(() => repository.getFavorites()).thenReturn([recipe]);
        return bloc;
      },
      act: (b) => b.add(ToggleFavoriteEvent(_fakeRecipe())),
      expect: () => [isA<FavoritesLoaded>()],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'ToggleFavoriteEvent removes recipe when already favorite',
      build: () {
        when(() => repository.isFavorite('r001')).thenReturn(true);
        when(() => repository.removeFavorite('r001')).thenAnswer((_) async {});
        when(() => repository.getFavorites()).thenReturn([]);
        return bloc;
      },
      act: (b) => b.add(ToggleFavoriteEvent(_fakeRecipe())),
      expect: () => [isA<FavoritesLoaded>()],
      verify: (b) {
        final state = b.state as FavoritesLoaded;
        expect(state.favorites, isEmpty);
      },
    );
  });

  // ─────────────────────────────────────────────────────────────
  // SearchBloc Tests
  // ─────────────────────────────────────────────────────────────
  group('SearchBloc', () {
    late MockRecipeRepository repository;
    late SearchBloc bloc;

    setUp(() {
      repository = MockRecipeRepository();
      bloc = SearchBloc(repository: repository);
    });

    tearDown(() => bloc.close());

    blocTest<SearchBloc, SearchState>(
      'emits SearchInitial on ClearSearchEvent',
      build: () => bloc,
      act: (b) => b.add(ClearSearchEvent()),
      expect: () => [isA<SearchInitial>()],
    );

    blocTest<SearchBloc, SearchState>(
      'emits SearchInitial when query is empty',
      build: () => bloc,
      act: (b) => b.add(SearchQueryEvent('')),
      expect: () => [isA<SearchInitial>()],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchSuccess] on valid query',
      build: () {
        when(() => repository.searchRecipes('risotto')).thenAnswer((_) async => [_fakeRecipe()]);
        return bloc;
      },
      act: (b) => b.add(SearchQueryEvent('risotto')),
      expect: () => [isA<SearchLoading>(), isA<SearchSuccess>()],
      verify: (b) {
        final state = b.state as SearchSuccess;
        expect(state.query, equals('risotto'));
        expect(state.results.length, equals(1));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchSuccess] with empty results for no match',
      build: () {
        when(() => repository.searchRecipes('xyzabc123')).thenAnswer((_) async => []);
        return bloc;
      },
      act: (b) => b.add(SearchQueryEvent('xyzabc123')),
      expect: () => [isA<SearchLoading>(), isA<SearchSuccess>()],
      verify: (b) {
        final state = b.state as SearchSuccess;
        expect(state.results, isEmpty);
      },
    );
  });
}
