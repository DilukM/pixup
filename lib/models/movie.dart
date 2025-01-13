class Movie {
  final int id;
  final String title;
  final String? posterPath;
  final String overview;
  final String releaseDate;
  final List genreIds;
  final double rating;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    required this.genreIds,
    required this.overview,
    required this.releaseDate,
    required this.rating,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'poster_path': posterPath,
        'overview': overview,
        'release_date': releaseDate,
        'vote_average': rating,
        'genre_ids': genreIds,
      };

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      releaseDate: json['release_date'],
      rating: (json['vote_average'] as num).toDouble(),
      genreIds: json['genre_ids'],
    );
  }
}
