part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  @override List<Object?> get props => [];
}
class LoadFavoritesEvent extends FavoritesEvent {}
class ToggleFavoriteEvent extends FavoritesEvent {
  final RecipeModel recipe;
  ToggleFavoriteEvent(this.recipe);
  @override List<Object?> get props => [recipe.id];
}

abstract class FavoritesState extends Equatable {
  @override List<Object?> get props => [];
}
class FavoritesInitial extends FavoritesState {}
class FavoritesLoaded extends FavoritesState {
  final List<RecipeModel> favorites;
  FavoritesLoaded({required this.favorites});
  bool isFavorite(String id) => favorites.any((r) => r.id == id);
  @override List<Object?> get props => [favorites];
}
