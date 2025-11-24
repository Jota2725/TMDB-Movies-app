import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb/l10n/app_localizations.dart';
import '../providers/movie_providers.dart';
import 'movie_detail_screen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final moviesState = ref.read(moviesProvider);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !moviesState.isLoadingMore &&
        moviesState.hasMore &&
        _searchQuery.isEmpty) {
      ref.read(moviesProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final genresAsync = ref.watch(genresProvider);
            final moviesState = ref.watch(moviesProvider);
            // Create a local copy of selected genre IDs for the dialog's state
            final List<int> selectedGenreIds = moviesState.selectedGenreIds
                .toList();

            return StatefulBuilder(
              builder: (context, setModalState) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            // 'Filter by Genre',
                            '', // Will be set in build or we need to access context here.
                            // Actually, we are in a builder, so context is available.
                            // But wait, the strings are static in the original code? No, they are in a widget.
                            // Let's use the localized string.
                          ),
                          Text(
                            AppLocalizations.of(context)!.filterByGenre,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(moviesProvider.notifier).setGenres([]);
                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context)!.clearAll),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: genresAsync.when(
                          data: (genres) => SingleChildScrollView(
                            child: Wrap(
                              spacing: 8,
                              children: genres.map((genre) {
                                final isSelected = selectedGenreIds.contains(
                                  genre.id,
                                );
                                return FilterChip(
                                  label: Text(genre.name),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setModalState(() {
                                      if (selected) {
                                        selectedGenreIds.add(genre.id);
                                      } else {
                                        selectedGenreIds.remove(genre.id);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (err, stack) => Text('Error: $err'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(moviesProvider.notifier)
                                .setGenres(selectedGenreIds);
                            Navigator.pop(context);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.applyFilters,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final moviesState = ref.watch(moviesProvider);
    final movies = moviesState.movies;

    // Local filtering for search query
    final displayMovies = _searchQuery.isEmpty
        ? movies
        : movies
              .where((m) => m.title.toLowerCase().contains(_searchQuery))
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.popularMoviesTitle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterDialog,
        child: const Icon(Icons.filter_list),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.searchMovies,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: moviesState.isLoading && movies.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : moviesState.error != null && movies.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(
                        context,
                      )!.error(moviesState.error.toString()),
                    ),
                  )
                : displayMovies.isEmpty
                ? Center(
                    child: Text(AppLocalizations.of(context)!.noMoviesFound),
                  )
                : GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount:
                        displayMovies.length +
                        (moviesState.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == displayMovies.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final movie = displayMovies[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailScreen(movieId: movie.id),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: movie.posterPath != null
                                    ? Image.network(
                                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Center(
                                                child: Icon(Icons.error),
                                              );
                                            },
                                      )
                                    : const Center(child: Icon(Icons.movie)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  movie.title,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
