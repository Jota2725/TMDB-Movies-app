class MovieDetailModel {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final List<String> genres;
  final int runtime;

  MovieDetailModel({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
    required this.genres,
    required this.runtime,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      voteAverage: (json['vote_average'] as num).toDouble(),
      genres: (json['genres'] as List)
          .map((genre) => genre['name'] as String)
          .toList(),
      runtime: json['runtime'] ?? 0,
    );
  }
}
