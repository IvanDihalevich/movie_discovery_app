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

    // Cache interceptor - disabled for now to avoid permission issues
    // _dio.interceptors.add(
    //   DioCacheInterceptor(
    //     options: CacheOptions(
    //       store: HiveCacheStore('dio_cache'),
    //       policy: CachePolicy.forceCache,
    //       maxStale: AppConstants.cacheExpiration,
    //       hitCacheOnErrorExcept: [401, 403, 404],
    //       keyBuilder: (request) {
    //         return request.uri.toString();
    //       },
    //     ),
    //   ),
    // );

    // Error handling interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Handle unauthorized access
            error = DioException(
              requestOptions: error.requestOptions,
              error: 'Unauthorized access. Please check your API key.',
              type: error.type,
              response: error.response,
            );
          } else if (error.response?.statusCode == 404) {
            // Handle not found
            error = DioException(
              requestOptions: error.requestOptions,
              error: 'Resource not found.',
              type: error.type,
              response: error.response,
            );
          } else if (error.response?.statusCode == 429) {
            // Handle rate limiting
            error = DioException(
              requestOptions: error.requestOptions,
              error: 'Rate limit exceeded. Please try again later.',
              type: error.type,
              response: error.response,
            );
          } else if (error.type == DioExceptionType.connectionTimeout ||
                     error.type == DioExceptionType.receiveTimeout ||
                     error.type == DioExceptionType.sendTimeout) {
            // Handle timeout
            error = DioException(
              requestOptions: error.requestOptions,
              error: 'Request timeout. Please check your internet connection.',
              type: error.type,
              response: error.response,
            );
          } else if (error.type == DioExceptionType.connectionError) {
            // Handle connection error
            error = DioException(
              requestOptions: error.requestOptions,
              error: 'No internet connection. Please check your network.',
              type: error.type,
              response: error.response,
            );
          }
          handler.next(error);
        },
      ),
    );
  }
}
