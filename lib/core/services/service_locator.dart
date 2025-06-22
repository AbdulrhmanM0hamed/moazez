import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:moazez/core/network/network_info.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/cache/cache_service_impl.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:moazez/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:moazez/feature/auth/domain/repositories/auth_repository.dart';
import 'package:moazez/feature/auth/domain/usecases/login_usecase.dart';
import 'package:moazez/feature/auth/domain/usecases/logout_usecase.dart';
import 'package:moazez/feature/auth/domain/usecases/register_usecase.dart';
import 'package:moazez/feature/auth/presentation/cubit/login/login_cubit.dart';
import 'package:moazez/feature/auth/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:moazez/feature/auth/presentation/cubit/register/register_cubit.dart';
import 'package:moazez/feature/profile/data/datasources/profile_remote_data_source.dart';
import 'package:moazez/feature/profile/data/repositories/profile_repository_impl.dart';
import 'package:moazez/feature/profile/domain/repositories/profile_repository.dart';
import 'package:moazez/feature/profile/domain/usecases/get_profile_usecase.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //############################################################################
  //                           Features - Auth
  //############################################################################

  // Blocs & Cubits
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
  sl.registerFactory(() => RegisterCubit(registerUseCase: sl()));
  sl.registerFactory(() => LogoutCubit(cacheHelper: sl(), logoutUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: sl(), cacheService: sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerFactory(() => ProfileCubit(getProfileUseCase: sl()));

  //############################################################################
  //                                Core
  //############################################################################

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Cache Service
  sl.registerLazySingleton<CacheService>(() => CacheServiceImpl(sl()));

  //############################################################################
  //                              External
  //############################################################################

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        headers: {'Accept': 'application/json'},
      ),
    );
    // You can add interceptors here for logging, token handling, etc.
    return dio;
  });

  sl.registerLazySingleton(() => Connectivity());
}
