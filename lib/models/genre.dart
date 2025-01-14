
// Genre class to represent a movie genre
class Genre {
  final int id;
  final String name;

// Constructor to initialize the Genre object
  Genre({required this.id, required this.name});

  // Factory method to create a Genre object from JSON data
  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}
