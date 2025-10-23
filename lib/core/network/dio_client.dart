import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import '../constants/app_constants.dart';

class DioClient {
  static DioClient? _instance;
  late Dio _dio;

  DioClient._internal() {
    _dio = Dio();
    _setupInterceptors();
  }

  static DioClient get instance {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    // Base configuration
    _dio.options = BaseOptions(
      baseUrl: AppConstants.tmdbBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // API Key interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['api_key'] = AppConstants.tmdbApiKey;
          handler.next(options);
        },
      ),
    );

    // Logging interceptor
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
      ),
    );

    // Cache interceptor
    _dio.interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          store: HiveCacheStore(),
          policy: CachePolicy.forceCache,
          maxStale: AppConstants.cacheExpiration,
          hitCacheOnErrorExcept: [401, 403, 404],
          keyBuilder: (request) {
            return request.uri.toString();
          },
        ),
      ),
    );

    // Error handling interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Handle unauthorized access
            error.error = 'Unauthorized access. Please check your API key.';
          } else if (error.response?.statusCode == 404) {
            // Handle not found
            error.error = 'Resource not found.';
          } else if (error.response?.statusCode == 429) {
            // Handle rate limiting
            error.error = 'Rate limit exceeded. Please try again later.';
          } else if (error.type == DioExceptionType.connectionTimeout ||
                     error.type == DioExceptionType.receiveTimeout ||
                     error.type == DioExceptionType.sendTimeout) {
            // Handle timeout
            error.error = 'Request timeout. Please check your internet connection.';
          } else if (error.type == DioExceptionType.connectionError) {
            // Handle connection error
            error.error = 'No internet connection. Please check your network.';
          }
          handler.next(error);
        },
      ),
    );
  }
}
