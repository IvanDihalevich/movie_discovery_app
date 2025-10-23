import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../../features/home/data/datasources/movie_remote_data_source.dart';
import '../../features/home/data/datasources/movie_local_data_source.dart';
import '../../features/home/data/repositories/movie_repository_impl.dart';
import '../../features/home/domain/repositories/movie_repository.dart';
import '../../features/home/domain/usecases/get_popular_movies.dart';
import '../../features/home/domain/usecases/get_top_rated_movies.dart';
import '../../features/home/domain/usecases/get_now_playing_movies.dart';
import '../../features/home/domain/usecases/get_upcoming_movies.dart';
import '../../features/home/domain/usecases/get_movie_details.dart';
import '../../features/home/domain/usecases/search_movies.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();

  // External dependencies
  getIt.registerLazySingleton<Dio>(() => DioClient.instance.dio);
  getIt.registerLazySingleton<HiveInterface>(() => Hive);

  // Data sources
  getIt.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<MovieRemoteDataSourceImpl>(
    () => MovieRemoteDataSourceImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(hive: getIt<HiveInterface>()),
  );

  // Repository
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: getIt<MovieRemoteDataSource>(),
      localDataSource: getIt<MovieLocalDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<GetPopularMovies>(
    () => GetPopularMovies(getIt<MovieRepository>()),
  );
  getIt.registerLazySingleton<GetTopRatedMovies>(
    () => GetTopRatedMovies(getIt<MovieRepository>()),
  );
  getIt.registerLazySingleton<GetNowPlayingMovies>(
    () => GetNowPlayingMovies(getIt<MovieRepository>()),
  );
  getIt.registerLazySingleton<GetUpcomingMovies>(
    () => GetUpcomingMovies(getIt<MovieRepository>()),
  );
  getIt.registerLazySingleton<GetMovieDetails>(
    () => GetMovieDetails(getIt<MovieRepository>()),
  );
  getIt.registerLazySingleton<SearchMovies>(
    () => SearchMovies(getIt<MovieRepository>()),
  );

  // BLoC
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      getPopularMovies: getIt<GetPopularMovies>(),
      getTopRatedMovies: getIt<GetTopRatedMovies>(),
      getNowPlayingMovies: getIt<GetNowPlayingMovies>(),
      getUpcomingMovies: getIt<GetUpcomingMovies>(),
      getMovieDetails: getIt<GetMovieDetails>(),
    ),
  );
}
