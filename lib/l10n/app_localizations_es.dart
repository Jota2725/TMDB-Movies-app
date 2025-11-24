// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get popularMoviesTitle => 'Películas Populares TMDB';

  @override
  String get searchMovies => 'Buscar Películas';

  @override
  String get filterByGenre => 'Filtrar por Género';

  @override
  String get clearAll => 'Limpiar Todo';

  @override
  String get applyFilters => 'Aplicar Filtros';

  @override
  String get noMoviesFound => 'No se encontraron películas';

  @override
  String get movieDetailsTitle => 'Detalles de la Película';

  @override
  String get overview => 'Resumen';

  @override
  String error(Object error) {
    return 'Error: $error';
  }
}
