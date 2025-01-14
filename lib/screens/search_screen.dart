import 'package:flutter/material.dart';
import 'package:pixup/models/genre.dart';
import 'package:pixup/services/api_service.dart';
import 'package:pixup/widgets/genre_filter.dart';
import 'package:provider/provider.dart';
import 'package:pixup/widgets/movie_card.dart';
import 'package:pixup/widgets/search_bar.dart';
import '../providers/movie_provider.dart';
import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ScrollController _scrollController =
      ScrollController(); // Controller for handling scroll events
  final ApiService apiService =
      ApiService(); // Instance of ApiService to handle API requests
  bool isFilterOn = false; // Flag to indicate if the filter is on
  List<Genre> genres = []; // List of all available genres
  List<Genre> selectedGenres = []; // List of currently selected genres
  bool showSearchBar = false; // Flag to indicate if the search bar is visible

  @override
  void initState() {
    super.initState();
    fetchGenres(); // Fetch genres when the screen is initialized
    _scrollController.addListener(_onScroll); // Add scroll listener
    _initializeData(); // Initialize data
  }

  Future<void> _initializeData() async {
    await fetchGenres(); // Fetch genres
    if (mounted) {
      context.read<MovieProvider>().searchMovies(
          '', ''); // Search movies with no query and no genre filter
    }
  }

  void _showGenreFilter() {
    showDialog(
      context: context,
      builder: (context) => GenreFilterDialog(
        genres: genres,
        selectedGenres: selectedGenres,
        onGenresSelected: (newSelection) {
          setState(() {
            selectedGenres = newSelection; // Update selected genres
          });
          context.read<MovieProvider>().searchMovies(
              '', getSelectedGenreIds()); // Search movies with selected genres
        },
      ),
    );
  }

  Future<void> fetchGenres() async {
    try {
      final fetchedGenres =
          await apiService.getGenres(); // Fetch genres from API
      setState(() {
        genres = fetchedGenres; // Update genres list
      });
    } catch (e) {
      print(e);
    }
  }

  String getSelectedGenreIds() {
    return selectedGenres
        .map((genre) => genre.id.toString())
        .join(','); // Get selected genre IDs as a comma-separated string
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final movieProvider = context.read<MovieProvider>();
      if (!movieProvider.isLoading && movieProvider.hasMorePages) {
        movieProvider.loadMoreMovies('',
            getSelectedGenreIds()); // Load more movies when scrolled to the bottom
      }
    }
  }

  void _clearSearch() {
    setState(() {
      showSearchBar = false; // Hide search bar
      selectedGenres.clear(); // Clear selected genres
    });
    context.read<MovieProvider>().searchMovies(
        '', ''); // Search movies with no query and no genre filter
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Remove scroll listener
    _scrollController.dispose(); // Dispose scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          width: 100,
        ),
        actions: [
          IconButton(
            icon: Icon(showSearchBar ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (showSearchBar) {
                  _clearSearch(); // Clear search when close icon is pressed
                } else {
                  setState(() {
                    showSearchBar =
                        true; // Show search bar when search icon is pressed
                  });
                }
              });
            },
          ),
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/Avatar.png'),
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: showSearchBar ? 60.0 : 0.0,
            curve: Curves.easeInOut,
            child: showSearchBar
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomSearchBar(
                            onSearch: (query) {
                              context.read<MovieProvider>().searchMovies(query,
                                  getSelectedGenreIds()); // Search movies with query and selected genres
                            },
                          ),
                        ),
                        IconButton(
                          icon: Badge(
                            isLabelVisible: selectedGenres.isNotEmpty,
                            label: Text(selectedGenres.length
                                .toString()), // Show number of selected genres
                            child: const Icon(Icons.tune),
                          ),
                          onPressed:
                              _showGenreFilter, // Show genre filter dialog
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          if (selectedGenres.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: selectedGenres.map((genre) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text(genre.name), // Display genre name
                        onDeleted: () {
                          setState(() {
                            selectedGenres.remove(
                                genre); // Remove genre from selected list
                          });
                          context.read<MovieProvider>().searchMovies('',
                              getSelectedGenreIds()); // Search movies with updated selected genres
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          Expanded(
            child: Consumer<MovieProvider>(
              builder: (context, movieProvider, child) {
                if (movieProvider.isLoading) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Show loading indicator
                }

                if (movieProvider.error.isNotEmpty) {
                  return Center(
                      child: Text(movieProvider.error)); // Show error message
                }

                if (movieProvider.movies.isEmpty) {
                  return const Center(
                      child: Text(
                          'No movies found')); // Show message if no movies found
                }

                return GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600
                        ? 4
                        : 2, // Adjust number of columns based on screen width
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
                            builder: (context) => DetailsScreen(
                                movie: movie), // Navigate to details screen
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
