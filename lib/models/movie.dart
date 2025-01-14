// Movie class to represent a movie
class Movie {
  final int id;
  final String title;
  final String? posterPath;
  final String overview;
  final String releaseDate;
  final List genreIds;
  final double rating;

  // Constructor to initialize the Movie object
  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    required this.genreIds,
    required this.overview,
    required this.releaseDate,
    required this.rating,
  });

// Method to convert Movie object to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'poster_path': posterPath,
        'overview': overview,
        'release_date': releaseDate,
        'vote_average': rating,
        'genre_ids': genreIds,
      };

  // Factory method to create a Movie object from JSON data
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
