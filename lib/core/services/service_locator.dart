import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:moazez/core/network/network_info.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/cache/cache_service_impl.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/agreements/data/datasources/agreements_remote_data_source.dart';
import 'package:moazez/feature/agreements/data/datasources/agreements_remote_data_source_impl.dart';
import 'package:moazez/feature/agreements/data/repositories/agreements_repository_impl.dart';
import 'package:moazez/feature/agreements/domain/repositories/agreements_repository.dart';
import 'package:moazez/feature/agreements/domain/usecases/get_team_members_usecase.dart';
import 'package:moazez/feature/agreements/presentation/cubit/create_task_cubit.dart';
import 'package:moazez/feature/agreements/presentation/cubit/team_members_cubit.dart';
import 'package:moazez/feature/agreements/domain/usecases/create_task_usecase.dart';
import 'package:moazez/feature/agreements/domain/usecases/close_task_usecase.dart';
import 'package:moazez/feature/packages/data/datasources/payment_remote_data_source.dart';
import 'package:moazez/feature/packages/domain/repositories/payment_repository.dart';
import 'package:moazez/feature/packages/data/repositories/payment_repository_impl.dart';
import 'package:moazez/feature/packages/domain/usecases/initiate_payment_usecase.dart';
import 'package:moazez/feature/packages/presentation/cubit/payment_cubit.dart';
import 'package:moazez/feature/profile/domain/usecases/get_financial_details_usecase.dart';
import 'package:moazez/feature/profile/presentation/cubit/financial_details_cubit.dart';
import 'package:moazez/feature/search/data/datasources/search_remote_data_source.dart';
import 'package:moazez/feature/search/data/repositories/search_repository_impl.dart';
import 'package:moazez/feature/search/domain/repositories/search_repository.dart';
import 'package:moazez/feature/search/domain/usecases/search_usecase.dart';
import 'package:moazez/feature/search/presentation/cubit/search_cubit.dart';
import 'package:moazez/feature/task_details/data/datasources/task_details_remote_datasoure.dart';
import 'package:moazez/feature/task_details/data/repositories/task_detials_repository_impl.dart';
import 'package:moazez/feature/task_details/domain/repositories/task_details_repository.dart';
import 'package:moazez/feature/task_details/domain/usecase/task_details_usecase.dart';
import 'package:moazez/feature/task_details/domain/usecases/complete_stage_usecase.dart';
import 'package:moazez/feature/task_details/domain/repositories/stage_completion_repository.dart';
import 'package:moazez/feature/task_details/data/repositories/stage_completion_repository_impl.dart';
import 'package:moazez/feature/task_details/presentation/cubit/task_details_cubit.dart';
import 'package:moazez/feature/task_details/presentation/cubit/stage_completion_cubit.dart';
import 'package:moazez/feature/MyTasks/data/datasources/my_tasks_remote_data_source.dart';
import 'package:moazez/feature/MyTasks/data/datasources/my_tasks_remote_data_source_impl.dart';
import 'package:moazez/feature/MyTasks/data/repositories/my_tasks_repository_impl.dart';
import 'package:moazez/feature/MyTasks/domain/repositories/my_tasks_repository.dart';
import 'package:moazez/feature/MyTasks/domain/usecases/get_my_tasks_usecase.dart';
import 'package:moazez/feature/MyTasks/presentation/cubit/my_tasks_cubit.dart';
import 'package:moazez/feature/agreements/presentation/cubit/close_task_cubit.dart';
import 'package:moazez/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:moazez/feature/auth/domain/usecases/send_password_reset_link_usecase.dart';
import 'package:moazez/feature/packages/data/datasources/subscription_remote_data_source.dart';
import 'package:moazez/feature/home_supporter/data/datasources/team_remote_data_source.dart';
import 'package:moazez/feature/packages/data/repositories/subscription_repository_impl.dart';
import 'package:moazez/feature/home_supporter/data/repositories/team_repository_impl.dart';
import 'package:moazez/feature/packages/domain/repositories/subscription_repository.dart';
import 'package:moazez/feature/home_supporter/domain/repositories/team_repository.dart';
import 'package:moazez/feature/packages/domain/usecases/get_current_subscription_usecase.dart';
import 'package:moazez/feature/home_supporter/domain/usecases/get_team_info_usecase.dart';
import 'package:moazez/feature/home_supporter/domain/usecases/get_member_task_stats_usecase.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_cubit.dart';
import 'package:moazez/feature/invitations/data/datasources/invitation_remote_data_source.dart';
import 'package:moazez/feature/invitations/data/repositories/invitation_repository_impl.dart';
import 'package:moazez/feature/invitations/domain/repositories/invitation_repository.dart';
import 'package:moazez/feature/invitations/domain/usecases/get_sent_invitations_usecase.dart';
import 'package:moazez/feature/invitations/domain/usecases/respond_to_invitation_usecase.dart';
import 'package:moazez/feature/invitations/domain/usecases/get_received_invitations_usecase.dart';
import 'package:moazez/feature/invitations/domain/usecases/send_invitation_usecase.dart';
import 'package:moazez/feature/invitations/presentation/cubit/invitation_cubit.dart';
import 'package:moazez/feature/packages/data/datasources/package_remote_data_source.dart';
import 'package:moazez/feature/packages/data/repositories/package_repository_impl.dart';
import 'package:moazez/feature/packages/domain/repositories/package_repository.dart';
import 'package:moazez/feature/packages/domain/usecases/get_packages_usecase.dart';
import 'package:moazez/feature/packages/presentation/cubit/package_cubit.dart';
import 'package:moazez/feature/packages/presentation/cubit/subscription_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/profile/domain/usecases/edit_profile_usecase.dart';
import 'package:moazez/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:moazez/feature/auth/domain/repositories/auth_repository.dart';
import 'package:moazez/feature/auth/domain/usecases/login_usecase.dart';
import 'package:moazez/feature/auth/domain/usecases/logout_usecase.dart';
import 'package:moazez/feature/auth/domain/usecases/register_usecase.dart';
import 'package:moazez/feature/auth/presentation/cubit/login/login_cubit.dart';
import 'package:moazez/feature/auth/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:moazez/feature/auth/presentation/cubit/register/register_cubit.dart';
import 'package:moazez/feature/auth/presentation/cubit/complete_profile_cubit.dart';
import 'package:moazez/feature/auth/domain/usecases/complete_profile_usecase.dart';
import 'package:moazez/feature/profile/data/datasources/profile_remote_data_source.dart';
import 'package:moazez/feature/profile/data/repositories/profile_repository_impl.dart';
import 'package:moazez/feature/profile/domain/repositories/profile_repository.dart';
import 'package:moazez/feature/profile/domain/usecases/get_profile_usecase.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:moazez/feature/rewards/data/datasources/reward_remote_data_source.dart';
import 'package:moazez/feature/rewards/data/repositories/reward_repository_impl.dart';
import 'package:moazez/feature/rewards/domain/repositories/reward_repository.dart';
import 'package:moazez/feature/rewards/domain/usecases/get_my_rewards_usecase.dart';
import 'package:moazez/feature/rewards/domain/usecases/get_team_rewards_usecase.dart';
import 'package:moazez/feature/rewards/presentation/cubit/reward_cubit.dart';
import 'package:moazez/feature/profile/data/datasources/user_subscriptions_remote_data_source.dart';
import 'package:moazez/feature/profile/data/repositories/user_subscriptions_repository_impl.dart';
import 'package:moazez/feature/profile/domain/repositories/user_subscriptions_repository.dart';
import 'package:moazez/feature/profile/domain/usecases/get_user_subscriptions_usecase.dart';
import 'package:moazez/feature/profile/presentation/cubit/user_subscriptions_cubit.dart';
import 'package:moazez/feature/profile/data/datasources/payments_remote_data_source.dart';
import 'package:moazez/feature/profile/data/repositories/payments_repository_impl.dart';
import 'package:moazez/feature/profile/domain/repositories/payments_repository.dart';
import 'package:moazez/feature/profile/domain/usecases/get_payments_usecase.dart';
import 'package:moazez/feature/profile/presentation/cubit/payments_cubit.dart';
import 'package:moazez/feature/profile/data/datasources/financial_details_remote_data_source.dart';
import 'package:moazez/feature/profile/data/repositories/financial_details_repository_impl.dart';
import 'package:moazez/feature/profile/domain/repositories/financial_details_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //############################################################################
  //                           Features - Auth
  //############################################################################

  // Blocs & Cubits
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
  sl.registerFactory(
    () => RegisterCubit(registerUseCase: sl(), teamCubit: sl()),
  );
  sl.registerFactory(() => CompleteProfileCubit(sl()));
  sl.registerFactory(() => LogoutCubit(cacheHelper: sl(), logoutUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => CompleteProfileUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => SendPasswordResetLinkUseCase(sl()));

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
  sl.registerLazySingleton(() => EditProfileUseCase(repository: sl()));
  sl.registerFactory(
    () => ProfileCubit(getProfileUseCase: sl(), editProfileUseCase: sl()),
  );
  sl.registerFactory(
    () => TeamCubit(
      getTeamInfoUseCase: sl(),
      getTeamMembersUsecase: sl(),
      teamRepository: sl(),
    ),
  );
  sl.registerFactory(() => MemberStatsCubit(getMemberTaskStatsUseCase: sl()));
  sl.registerFactory(
    () => InvitationCubit(
      sendInvitationUseCase: sl(),
      getSentInvitationsUseCase: sl(),
      getReceivedInvitationsUseCase: sl(),
      respondToInvitationUseCase: sl(),
    ),
  );
  // Package Cubit
  sl.registerFactory(() => PackageCubit(getPackagesUseCase: sl()));
  // Rewards
  sl.registerFactory(
    () => RewardCubit(getTeamRewardsUseCase: sl(), getMyRewardsUseCase: sl()),
  );
  sl.registerLazySingleton(() => GetTeamRewardsUseCase(sl()));
  sl.registerLazySingleton(() => GetMyRewardsUseCase(sl()));

  // User Subscriptions
  sl.registerLazySingleton<UserSubscriptionsRemoteDataSource>(
      () => UserSubscriptionsRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<UserSubscriptionsRepository>(
      () => UserSubscriptionsRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => GetUserSubscriptionsUseCase(sl()));
  sl.registerFactory(() => UserSubscriptionsCubit(getUserSubscriptionsUseCase: sl()));
  // Payments
  sl.registerLazySingleton<PaymentsRemoteDataSource>(
      () => PaymentsRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<PaymentsRepository>(
      () => PaymentsRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => GetPaymentsUseCase(sl()));
  sl.registerFactory(() => PaymentsCubit(getPaymentsUseCase: sl()));

  // Financial Details
  sl.registerFactory(() => FinancialDetailsCubit(getFinancialDetailsUseCase: sl()));
  sl.registerLazySingleton(() => GetFinancialDetailsUseCase(sl()));
  sl.registerLazySingleton<FinancialDetailsRepository>(
      () => FinancialDetailsRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<FinancialDetailsRemoteDataSource>(
      () => FinancialDetailsRemoteDataSourceImpl(dio: sl()));

  sl.registerLazySingleton<RewardRepository>(
    () => RewardRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  //############################################################################
  //                           Features - Search
  //############################################################################
  sl.registerFactory(() => SearchCubit(searchUseCase: sl()));
  sl.registerLazySingleton(() => SearchUseCase(repository: sl()));
  sl.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<RewardRemoteDataSource>(
    () => RewardRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton(() => GetTeamInfoUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => GetMemberTaskStatsUseCase(teamRepository: sl()),
  );
  sl.registerLazySingleton(() => SendInvitationUseCase(sl()));
  sl.registerLazySingleton(() => GetSentInvitationsUseCase(sl()));
  sl.registerLazySingleton(() => GetReceivedInvitationsUseCase(sl()));
  sl.registerLazySingleton(() => RespondToInvitationUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TeamRepository>(
    () => TeamRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<InvitationRepository>(
    () => InvitationRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TeamRemoteDataSource>(
    () => TeamRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<InvitationRemoteDataSource>(
    () => InvitationRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton(() => CreateTeamUseCase(repository: sl()));

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

  //############################################################################
  //                           Features - Packages
  //############################################################################
  sl.registerLazySingleton<PackageRemoteDataSource>(
    () => PackageRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<PackageRepository>(
    () => PackageRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => GetPackagesUseCase(sl()));
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => InitiatePaymentUseCase(repository: sl()));
  sl.registerFactory(() => PaymentCubit(initiatePaymentUseCase: sl()));
  sl.registerLazySingleton<SubscriptionRemoteDataSource>(
    () => SubscriptionRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => GetCurrentSubscriptionUseCase(sl()));
  sl.registerFactory(
    () => SubscriptionCubit(getCurrentSubscriptionUseCase: sl()),
  );

  sl.registerLazySingleton(() => GetTeamMembersUsecase(sl()));
  sl.registerLazySingleton<AgreementsRemoteDataSource>(
    () => AgreementsRemoteDataSourceImpl(dio: sl(), cacheService: sl()),
  );

  sl.registerLazySingleton<AgreementsRepository>(
    () => AgreementsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => TeamMembersCubit(getTeamMembersUsecase: sl()));
 

  // Create Task
  sl.registerLazySingleton(() => CreateTaskUsecase(sl()));
  sl.registerFactory(() => CreateTaskCubit(createTaskUsecase: sl()));

  // Close Task
  sl.registerLazySingleton(() => CloseTaskUseCase(sl()));
  sl.registerFactory(() => CloseTaskCubit(sl()));

  // Get Task Details
  sl.registerLazySingleton(() => TaskDetailsUseCase(sl()));
  sl.registerLazySingleton<TaskDetailsRemoteDataSource>(
    () => TaskDetailsRemoteDataSourceImpl(dio: sl(), cacheService: sl()),
  );

  sl.registerLazySingleton<TaskDetailsRepository>(
    () => TaskDetailsRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => TaskDetailsCubit(sl()));

  // Complete Stage
  sl.registerLazySingleton<StageCompletionRepository>(
    () => StageCompletionRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => CompleteStageUseCase(repository :sl()));
  sl.registerFactory(() => StageCompletionCubit(completeStageUseCase: sl()));

  // My Tasks
  sl.registerLazySingleton<MyTasksRemoteDataSource>(
    () => MyTasksRemoteDataSourceImpl(dio: sl(), cacheService: sl()),
  );
  sl.registerLazySingleton<MyTasksRepository>(
    () => MyTasksRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetMyTasksUseCase(sl()));
  sl.registerFactory(() => MyTasksCubit(getMyTasksUseCase: sl()));
}
