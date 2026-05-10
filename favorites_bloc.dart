import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/recipe_model.dart';
import '../../../data/repositories/recipe_repository_impl.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final RecipeRepositoryImpl repository;

  FavoritesBloc({required this.repository}) : super(FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoad);
    on<ToggleFavoriteEvent>(_onToggle);
  }

  void _onLoad(LoadFavoritesEvent event, Emitter<FavoritesState> emit) {
    final favorites = repository.getFavorites();
    emit(FavoritesLoaded(favorites: favorites));
  }

  Future<void> _onToggle(ToggleFavoriteEvent event, Emitter<FavoritesState> emit) async {
    if (repository.isFavorite(event.recipe.id)) {
      await repository.removeFavorite(event.recipe.id);
    } else {
      await repository.addFavorite(event.recipe);
    }
    final favorites = repository.getFavorites();
    emit(FavoritesLoaded(favorites: favorites));
  }
}
