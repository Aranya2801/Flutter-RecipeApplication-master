part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  @override List<Object?> get props => [];
}
class SearchQueryEvent extends SearchEvent {
  final String query;
  SearchQueryEvent(this.query);
  @override List<Object?> get props => [query];
}
class ClearSearchEvent extends SearchEvent {}
class ApplyFiltersEvent extends SearchEvent {
  final String query;
  final String? difficulty;
  final String? category;
  final List<String>? tags;
  final int? maxCalories;
  final int? maxTime;
  final int filterCount;
  ApplyFiltersEvent({required this.query, this.difficulty, this.category,
    this.tags, this.maxCalories, this.maxTime, this.filterCount = 0});
  @override List<Object?> get props => [query, difficulty, category, tags, maxCalories, maxTime];
}

abstract class SearchState extends Equatable {
  @override List<Object?> get props => [];
}
class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchSuccess extends SearchState {
  final String query;
  final List<RecipeModel> results;
  final int totalCount;
  final int appliedFilters;
  SearchSuccess({required this.query, required this.results,
    required this.totalCount, this.appliedFilters = 0});
  @override List<Object?> get props => [query, results, totalCount];
}
class SearchError extends SearchState {
  final String message;
  SearchError({required this.message});
  @override List<Object?> get props => [message];
}
