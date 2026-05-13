import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/di/injection_container.dart';
import 'data/models/recipe_model.dart';
import 'data/models/user_preferences_model.dart';
import 'presentation/blocs/theme/theme_bloc.dart';
import 'presentation/blocs/recipe/recipe_bloc.dart';
import 'presentation/blocs/favorites/favorites_bloc.dart';
import 'presentation/blocs/meal_plan/meal_plan_bloc.dart';
import 'presentation/blocs/search/search_bloc.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait and landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeModelAdapter());
  Hive.registerAdapter(UserPreferencesModelAdapter());
  await Hive.openBox<RecipeModel>(AppConstants.favoritesBox);
  await Hive.openBox<RecipeModel>(AppConstants.recentlyViewedBox);
  await Hive.openBox(AppConstants.preferencesBox);
  await Hive.openBox(AppConstants.mealPlanBox);

  // Setup dependency injection
  await setupInjection();

  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.I<ThemeBloc>()),
        BlocProvider(create: (_) => GetIt.I<RecipeBloc>()..add(LoadRecipesEvent())),
        BlocProvider(create: (_) => GetIt.I<FavoritesBloc>()..add(LoadFavoritesEvent())),
        BlocProvider(create: (_) => GetIt.I<MealPlanBloc>()..add(LoadMealPlanEvent())),
        BlocProvider(create: (_) => GetIt.I<SearchBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'Saveur — Recipe Mastery',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            routerConfig: AppRouter.router,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(
                    MediaQuery.of(context).textScaleFactor.clamp(0.85, 1.2),
                  ),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
