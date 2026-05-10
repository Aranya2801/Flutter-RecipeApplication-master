import 'package:get_it/get_it.dart';
import '../../data/datasources/local/local_recipe_datasource.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../presentation/blocs/recipe/recipe_bloc.dart';
import '../../presentation/blocs/favorites/favorites_bloc.dart';
import '../../presentation/blocs/meal_plan/meal_plan_bloc.dart';
import '../../presentation/blocs/search/search_bloc.dart';
import '../../presentation/blocs/theme/theme_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> setupInjection() async {
  // Data Sources
  final localDs = LocalRecipeDataSource();
  await localDs.initialize();
  sl.registerSingleton<LocalRecipeDataSource>(localDs);

  // Repositories
  sl.registerSingleton<RecipeRepositoryImpl>(
    RecipeRepositoryImpl(localDataSource: sl()),
  );

  // BLoCs
  sl.registerFactory<ThemeBloc>(() => ThemeBloc());
  sl.registerFactory<RecipeBloc>(() => RecipeBloc(repository: sl()));
  sl.registerFactory<FavoritesBloc>(() => FavoritesBloc(repository: sl()));
  sl.registerFactory<MealPlanBloc>(() => MealPlanBloc(repository: sl()));
  sl.registerFactory<SearchBloc>(() => SearchBloc(repository: sl()));
}
