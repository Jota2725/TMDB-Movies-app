// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get popularMoviesTitle => 'TMDB Popular Movies';

  @override
  String get searchMovies => 'Search Movies';

  @override
  String get filterByGenre => 'Filter by Genre';

  @override
  String get clearAll => 'Clear All';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get noMoviesFound => 'No movies found';

  @override
  String get movieDetailsTitle => 'Movie Details';

  @override
  String get overview => 'Overview';

  @override
  String error(Object error) {
    return 'Error: $error';
  }
}
