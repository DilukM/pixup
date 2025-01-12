import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:pixup/models/genre.dart';
import 'package:pixup/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:pixup/widgets/movieCard.dart';
import 'package:pixup/widgets/search_bar.dart';
import '../providers/movie_provider.dart';
import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService apiService = ApiService();
  bool isFilterOn = false;
  List<Genre> genres = [];
  List<Genre> selectedGenres = [];

  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  Future<void> fetchGenres() async {
    try {
      final fetchedGenres = await apiService.getGenres();
      setState(() {
        genres = fetchedGenres;
      });
    } catch (e) {
      print(e);
    }
  }

  String getSelectedGenreIds() {
    return selectedGenres.map((genre) => genre.id.toString()).join(',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PixUp'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: CustomSearchBar(
                    onSearch: (query) {
                      context
                          .read<MovieProvider>()
                          .searchMovies(query, getSelectedGenreIds());
                    },
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () {
                  setState(() {
                    isFilterOn = !isFilterOn;
                  });
                },
              ),
            ],
          ),
          isFilterOn
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: MultiSelectDialogField(
                    items: genres
                        .map((genre) =>
                            MultiSelectItem<Genre>(genre, genre.name))
                        .toList(),
                    title: Text("Genres"),
                    separateSelectedItems: true,
                    selectedColor: Colors.blue,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    buttonIcon: Icon(
                      Icons.movie,
                      color: Colors.blue,
                    ),
                    buttonText: Text(
                      "Select Genres",
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 16,
                      ),
                    ),
                    onConfirm: (results) {
                      setState(() {
                        selectedGenres = results;
                      });
                      context
                          .read<MovieProvider>()
                          .searchMovies('', getSelectedGenreIds());
                    },
                  ),
                )
              : Container(),
          Expanded(
            child: Consumer<MovieProvider>(
              builder: (context, movieProvider, child) {
                if (movieProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (movieProvider.error.isNotEmpty) {
                  return Center(child: Text(movieProvider.error));
                }

                if (movieProvider.movies.isEmpty) {
                  return const Center(child: Text('No movies found'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 4 : 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: movieProvider.movies.length,
                  itemBuilder: (context, index) {
                    final movie = movieProvider.movies[index];
                    return MovieCard(
                      movie: movie,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(movie: movie),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
