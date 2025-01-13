import 'package:flutter/material.dart';
import 'package:pixup/models/movie.dart';
import 'package:pixup/services/api_service.dart';
import 'package:pixup/widgets/popular_movie_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import 'details_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _popularScrollController = ScrollController();
  final ScrollController _topRatedScrollController = ScrollController();
  final ScrollController _nowPlayingScrollController = ScrollController();
  final ScrollController _upcomingScrollController = ScrollController();
  final CarouselSliderController _slideController = CarouselSliderController();
  int _current = 0;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _popularScrollController.addListener(_onScroll);
    _topRatedScrollController.addListener(_onScroll);
    _nowPlayingScrollController.addListener(_onScroll);
    _upcomingScrollController.addListener(_onScroll);
    _initializeData();
  }

  Future<void> _initializeData() async {
    context.read<MovieProvider>().loadPopularMovies();
  }

  void _onScroll() {
    if (_popularScrollController.position.pixels >=
        _popularScrollController.position.maxScrollExtent - 200) {
      final movieProvider = context.read<MovieProvider>();
      if (!movieProvider.isLoading && movieProvider.hasMorePages) {
        movieProvider.loadPopularMovies();
      }
    }

    if (_topRatedScrollController.position.pixels >=
        _topRatedScrollController.position.maxScrollExtent - 200) {
      final movieProvider = context.read<MovieProvider>();
      if (!movieProvider.isLoading && movieProvider.hasMorePages) {
        movieProvider.loadPopularMovies();
      }
    }

    if (_nowPlayingScrollController.position.pixels >=
        _nowPlayingScrollController.position.maxScrollExtent - 200) {
      final movieProvider = context.read<MovieProvider>();
      if (!movieProvider.isLoading && movieProvider.hasMorePages) {
        movieProvider.loadPopularMovies();
      }
    }

    if (_upcomingScrollController.position.pixels >=
        _upcomingScrollController.position.maxScrollExtent - 200) {
      final movieProvider = context.read<MovieProvider>();
      if (!movieProvider.isLoading && movieProvider.hasMorePages) {
        movieProvider.loadPopularMovies();
      }
    }
  }

  @override
  void dispose() {
    _popularScrollController.removeListener(_onScroll);
    _topRatedScrollController.removeListener(_onScroll);
    _nowPlayingScrollController.removeListener(_onScroll);
    _upcomingScrollController.removeListener(_onScroll);
    _popularScrollController.dispose();
    _topRatedScrollController.dispose();
    _nowPlayingScrollController.dispose();
    _upcomingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              CarouselSlider(
                carouselController: _slideController,
                options: CarouselOptions(
                  viewportFraction: 1,
                  height: 300.0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 15),
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                items: context
                    .watch<MovieProvider>()
                    .PopularMovies
                    .take(5)
                    .map((movie) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(movie: movie),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            image: DecorationImage(
                              image: NetworkImage(movie.posterPath != null
                                  ? '${ApiService.imageBaseUrl}${movie.posterPath}'
                                  : ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              Container(
                height: 305,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                    stops: [0.6, 1],
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: context
                      .watch<MovieProvider>()
                      .PopularMovies
                      .asMap()
                      .entries
                      .take(5)
                      .map((entry) {
                    return GestureDetector(
                      onTap: () => _slideController.animateToPage(entry.key),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: _current == entry.key ? 30 : 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _current == entry.key
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.3)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MovieSection(
                      title: "Popular Movies",
                      movies: context.watch<MovieProvider>().PopularMovies,
                      scrollController: _popularScrollController,
                    ),
                    MovieSection(
                      title: "Top Rated Movies",
                      movies: context.watch<MovieProvider>().TopRatedMovies,
                      scrollController: _topRatedScrollController,
                    ),
                    MovieSection(
                      title: "Now Playing Movies",
                      movies: context.watch<MovieProvider>().NowPlayingMovies,
                      scrollController: _nowPlayingScrollController,
                    ),
                    MovieSection(
                      title: "Upcoming Movies",
                      movies: context.watch<MovieProvider>().UpcomingMovies,
                      scrollController: _upcomingScrollController,
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final ScrollController scrollController;

  const MovieSection({
    Key? key,
    required this.title,
    required this.movies,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              Text("Show All", style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width > 600 ? 600 : 300,
            child: Consumer<MovieProvider>(
              builder: (context, movieProvider, child) {
                if (movieProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (movieProvider.error.isNotEmpty) {
                  return Center(child: Text(movieProvider.error));
                }

                if (movies.isEmpty) {
                  return const Center(child: Text('No movies found'));
                }

                return GridView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 2 : 1,
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return PopularMovieCard(
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
