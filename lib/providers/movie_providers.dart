import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'locale_provider.dart';
import '../services/tmdb_service.dart';
import '../models/movie_model.dart';
import '../models/genre_model.dart';
import '../models/movie_detail_model.dart';

final tmdbServiceProvider = Provider<TMDBService>((ref) => TMDBService());

final genresProvider = FutureProvider<List<GenreModel>>((ref) async {
  final service = ref.watch(tmdbServiceProvider);
  final locale = ref.watch(localeProvider);
  return service.getGenres(language: locale.languageCode);
});

final movieDetailProvider = FutureProvider.family<MovieDetailModel, int>((
  ref,
  id,
) async {
  final service = ref.watch(tmdbServiceProvider);
  final locale = ref.watch(localeProvider);
  return service.getMovieDetails(id, language: locale.languageCode);
});

class MoviesState {
  final List<MovieModel> movies;
  final int page;
  final List<int> selectedGenreIds;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;

  MoviesState({
    this.movies = const [],
    this.page = 1,
    this.selectedGenreIds = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
  });

  MoviesState copyWith({
    List<MovieModel>? movies,
    int? page,
    List<int>? selectedGenreIds,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
  }) {
    return MoviesState(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      selectedGenreIds: selectedGenreIds ?? this.selectedGenreIds,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

class MoviesNotifier extends Notifier<MoviesState> {
  late final TMDBService _service;
  late String _languageCode;

  @override
  MoviesState build() {
    _service = ref.watch(tmdbServiceProvider);
    _languageCode = ref.watch(localeProvider).languageCode;
    // Initial fetch
    Future.microtask(
      () => fetchMovies(reset: true),
    ); // Reset on build (locale change)
    return MoviesState();
  }

  Future<void> fetchMovies({bool reset = false}) async {
    if (state.isLoading || state.isLoadingMore) return;

    if (reset) {
      state = state.copyWith(
        movies: [],
        page: 1,
        hasMore: true,
        isLoading: true,
        error: null,
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      List<MovieModel> newMovies;
      if (state.selectedGenreIds.isEmpty) {
        newMovies = await _service.getPopularMovies(
          page: state.page,
          language: _languageCode,
        );
      } else {
        newMovies = await _service.getMoviesByGenre(
          state.selectedGenreIds,
          page: state.page,
          language: _languageCode,
        );
      }

      state = state.copyWith(
        movies: reset ? newMovies : [...state.movies, ...newMovies],
        isLoading: false,
        hasMore: newMovies.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true, error: null);

    try {
      final nextPage = state.page + 1;
      List<MovieModel> newMovies;

      if (state.selectedGenreIds.isEmpty) {
        newMovies = await _service.getPopularMovies(
          page: nextPage,
          language: _languageCode,
        );
      } else {
        newMovies = await _service.getMoviesByGenre(
          state.selectedGenreIds,
          page: nextPage,
          language: _languageCode,
        );
      }

      state = state.copyWith(
        movies: [...state.movies, ...newMovies],
        page: nextPage,
        isLoadingMore: false,
        hasMore: newMovies.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  void setGenres(List<int> genreIds) {
    state = state.copyWith(selectedGenreIds: genreIds);
    fetchMovies(reset: true);
  }
}

final moviesProvider = NotifierProvider<MoviesNotifier, MoviesState>(() {
  return MoviesNotifier();
});
