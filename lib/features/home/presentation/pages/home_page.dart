import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/movie_list_widget.dart';
import '../widgets/movie_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadPopularMovies(page: 1));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<HomeBloc>().add(const LoadMoreMovies(category: 'popular'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Discovery'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search page
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading && state == HomeLoading()) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(const RefreshMovies());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(const RefreshMovies());
              },
              child: ListView(
                controller: _scrollController,
                children: [
                  // Popular Movies Section
                  MovieListWidget(
                    title: 'Popular Movies',
                    movies: state.popularMovies,
                    onMovieTap: (movie) {
                      // Navigate to movie details
                    },
                    onLoadMore: state.hasReachedMaxPopular
                        ? null
                        : () {
                            context.read<HomeBloc>().add(
                                  const LoadMoreMovies(category: 'popular'),
                                );
                          },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Top Rated Movies Section
                  MovieListWidget(
                    title: 'Top Rated Movies',
                    movies: state.topRatedMovies,
                    onMovieTap: (movie) {
                      // Navigate to movie details
                    },
                    onLoadMore: state.hasReachedMaxTopRated
                        ? null
                        : () {
                            context.read<HomeBloc>().add(
                                  const LoadMoreMovies(category: 'top_rated'),
                                );
                          },
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('No data available'),
          );
        },
      ),
    );
  }
}
