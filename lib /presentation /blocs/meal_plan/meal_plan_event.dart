part of 'meal_plan_bloc.dart';

abstract class MealPlanEvent extends Equatable {
  @override List<Object?> get props => [];
}
class LoadMealPlanEvent extends MealPlanEvent {}
class ClearWeekEvent extends MealPlanEvent {}
class AssignMealEvent extends MealPlanEvent {
  final String day, mealType;
  final RecipeModel recipe;
  AssignMealEvent({required this.day, required this.mealType, required this.recipe});
  @override List<Object?> get props => [day, mealType, recipe.id];
}
class RemoveMealEvent extends MealPlanEvent {
  final String day, mealType;
  RemoveMealEvent({required this.day, required this.mealType});
  @override List<Object?> get props => [day, mealType];
}

abstract class MealPlanState extends Equatable {
  @override List<Object?> get props => [];
}
class MealPlanInitial extends MealPlanState {}
class MealPlanLoaded extends MealPlanState {
  final Map<String, Map<String, RecipeModel?>> week;
  MealPlanLoaded({required this.week});

  int get totalCalories => week.values.expand((day) => day.values)
      .where((r) => r != null).map((r) => r!.caloriesPerServing).fold(0, (a, b) => a + b);

  int get totalMealsPlanned => week.values.expand((day) => day.values)
      .where((r) => r != null).length;

  @override List<Object?> get props => [week];
}
