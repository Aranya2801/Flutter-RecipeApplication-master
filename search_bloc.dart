import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/recipe_model.dart';
import '../../../data/repositories/recipe_repository_impl.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final RecipeRepositoryImpl repository;

  SearchBloc({required this.repository}) : super(SearchInitial()) {
    on<SearchQueryEvent>(_onSearch);
    on<ClearSearchEvent>(_onClear);
    on<ApplyFiltersEvent>(_onFilter);
  }

  Future<void> _onSearch(SearchQueryEvent event, Emitter<SearchState> emit) async {
    if (event.query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final results = await repository.searchRecipes(event.query);
      emit(SearchSuccess(
        query: event.query, results: results,
        totalCount: results.length,
      ));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }

  Future<void> _onFilter(ApplyFiltersEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final results = await repository.searchRecipes(
        event.query,
        difficulty: event.difficulty,
        category: event.category,
        tags: event.tags,
        maxCalories: event.maxCalories,
        maxTime: event.maxTime,
      );
      emit(SearchSuccess(
        query: event.query, results: results,
        totalCount: results.length, appliedFilters: event.filterCount,
      ));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }

  void _onClear(ClearSearchEvent event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}
