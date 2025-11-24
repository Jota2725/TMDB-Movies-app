import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie_model.dart';
import '../models/movie_detail_model.dart';
import '../models/genre_model.dart';

class TMDBService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<MovieModel>> getPopularMovies({
    int page = 1,
    String language = 'es',
  }) async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    if (apiKey == null) {
      throw Exception('API Key not found in .env');
    }

    final url = Uri.parse(
      '$_baseUrl/movie/popular?api_key=$apiKey&page=$page&language=$language',
    );

    // Comentario: Realizamos la petición HTTP GET
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      // Comentario: Mapeamos la lista de resultados a objetos MovieModel
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<GenreModel>> getGenres({String language = 'es'}) async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    if (apiKey == null) throw Exception('API Key not found');

    final url = Uri.parse(
      '$_baseUrl/genre/movie/list?api_key=$apiKey&language=$language',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['genres'] as List)
          .map((json) => GenreModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<List<MovieModel>> getMoviesByGenre(
    List<int> genreIds, {
    int page = 1,
    String language = 'es',
  }) async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    if (apiKey == null) throw Exception('API Key not found');

    final genresStr = genreIds.join(',');
    final url = Uri.parse(
      '$_baseUrl/discover/movie?api_key=$apiKey&with_genres=$genresStr&page=$page&language=$language',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((json) => MovieModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load movies by genre');
    }
  }

  Future<MovieDetailModel> getMovieDetails(
    int id, {
    String language = 'es',
  }) async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    if (apiKey == null) {
      throw Exception('API Key not found in .env');
    }

    final url = Uri.parse(
      '$_baseUrl/movie/$id?api_key=$apiKey&language=$language',
    );

    // Comentario: Petición para detalles de la película
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return MovieDetailModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}
