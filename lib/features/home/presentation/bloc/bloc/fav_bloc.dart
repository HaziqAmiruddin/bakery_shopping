import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/home/domain/entities/fav_item_entities.dart';
import 'package:shopping_app/features/home/domain/useccase/toggle_fav.dart';
import 'package:shopping_app/features/home/presentation/bloc/event/fav_event.dart';
import 'package:shopping_app/features/home/presentation/bloc/state/fav_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final WatchFavoritesUseCase watchFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  FavoriteBloc({
    required this.watchFavoritesUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(FavoriteLoading()) {
    on<WatchFavoritesStarted>(_onWatchStarted);
    on<FavoriteToggled>(_onToggled);
  }

  Future<void> _onWatchStarted(
    WatchFavoritesStarted event,
    Emitter<FavoriteState> emit,
  ) async {
    await emit.forEach<List<FavoriteItem>>(
      watchFavoritesUseCase(),
      onData: (items) => FavoriteLoaded(items),
      onError: (error, stackTrace) => FavoriteError(error.toString()),
    );
  }

  Future<void> _onToggled(
    FavoriteToggled event,
    Emitter<FavoriteState> emit,
  ) async {
    await toggleFavoriteUseCase(event.product);
    // No emit here — Firestore write triggers the stream above automatically.
  }
}
