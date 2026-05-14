import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/recipe_model.dart';
import '../../../data/repositories/recipe_repository_impl.dart';

part 'meal_plan_event.dart';
part 'meal_plan_state.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  final RecipeRepositoryImpl repository;

  static const List<String> weekDays = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
  static const List<String> mealTypes = ['breakfast','lunch','dinner','snack'];

  MealPlanBloc({required this.repository}) : super(MealPlanInitial()) {
    on<LoadMealPlanEvent>(_onLoad);
    on<AssignMealEvent>(_onAssign);
    on<RemoveMealEvent>(_onRemove);
    on<ClearWeekEvent>(_onClear);
  }

  void _onLoad(LoadMealPlanEvent event, Emitter<MealPlanState> emit) {
    final saved = repository.getMealPlan();
    // Build week map
    final Map<String, Map<String, RecipeModel?>> week = {};
    for (final day in weekDays) {
      week[day] = {};
      for (final meal in mealTypes) {
        week[day]![meal] = null;
      }
    }
    emit(MealPlanLoaded(week: week));
  }

  Future<void> _onAssign(AssignMealEvent event, Emitter<MealPlanState> emit) async {
    if (state is MealPlanLoaded) {
      final current = state as MealPlanLoaded;
      final newWeek = Map<String, Map<String, RecipeModel?>>.from(
        current.week.map((k, v) => MapEntry(k, Map<String, RecipeModel?>.from(v))),
      );
      newWeek[event.day]?[event.mealType] = event.recipe;
      emit(MealPlanLoaded(week: newWeek));
    }
  }

  void _onRemove(RemoveMealEvent event, Emitter<MealPlanState> emit) {
    if (state is MealPlanLoaded) {
      final current = state as MealPlanLoaded;
      final newWeek = Map<String, Map<String, RecipeModel?>>.from(
        current.week.map((k, v) => MapEntry(k, Map<String, RecipeModel?>.from(v))),
      );
      newWeek[event.day]?[event.mealType] = null;
      emit(MealPlanLoaded(week: newWeek));
    }
  }

  void _onClear(ClearWeekEvent event, Emitter<MealPlanState> emit) {
    final Map<String, Map<String, RecipeModel?>> week = {};
    for (final day in weekDays) {
      week[day] = { for (final m in mealTypes) m: null };
    }
    emit(MealPlanLoaded(week: week));
  }
}
