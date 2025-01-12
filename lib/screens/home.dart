import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
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
  final ScrollController _scrollController = ScrollController();
  final ApiService apiService = ApiService();
  bool isFilterOn = false;
  List<Genre> genres = [];
  List<Genre> selectedGenres = [];
  bool showSearchBar = false;

  @override
  void initState() {
    super.initState();
    fetchGenres();
    _scrollController.addListener(_onScroll);
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchGenres();
    context.read<MovieProvider>().searchMovies('', '');
  }

  void _showGenreFilter() {
    showDialog(
      context: context,
      builder: (context) => GenreFilterDialog(
        genres: genres,
        selectedGenres: selectedGenres,
        onGenresSelected: (newSelection) {
          setState(() {
            selectedGenres = newSelection;
          });
          context.read<MovieProvider>().searchMovies('', getSelectedGenreIds());
        },
      ),
    );
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

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final movieProvider = context.read<MovieProvider>();
      if (!movieProvider.isLoading && movieProvider.hasMorePages) {
        movieProvider.loadMoreMovies('', getSelectedGenreIds());
      }
    }
  }

  void _clearSearch() {
    setState(() {
      showSearchBar = false;
      selectedGenres.clear();
    });
    context.read<MovieProvider>().searchMovies('', '');
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
                  _clearSearch();
                } else {
                  setState(() {
                    showSearchBar = true;
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
                              context
                                  .read<MovieProvider>()
                                  .searchMovies(query, getSelectedGenreIds());
                            },
                          ),
                        ),
                        IconButton(
                          icon: Badge(
                            isLabelVisible: selectedGenres.isNotEmpty,
                            label: Text(selectedGenres.length.toString()),
                            child: const Icon(Icons.tune),
                          ),
                          onPressed: _showGenreFilter,
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
                        label: Text(genre.name),
                        onDeleted: () {
                          setState(() {
                            selectedGenres.remove(genre);
                          });
                          context
                              .read<MovieProvider>()
                              .searchMovies('', getSelectedGenreIds());
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
                  return const Center(child: CircularProgressIndicator());
                }

                if (movieProvider.error.isNotEmpty) {
                  return Center(child: Text(movieProvider.error));
                }

                if (movieProvider.movies.isEmpty) {
                  return const Center(child: Text('No movies found'));
                }

                return GridView.builder(
                  controller: _scrollController,
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
