import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/data/repositories/auth/auth_repository_impl.dart';
import 'package:frontend/data/repositories/hospital/hospital_repository_impl.dart';
import 'package:frontend/data/repositories/hospital_dashboard/hospital_dashboard_repository_impl.dart';
import 'package:frontend/data/resources/auth/auth_remote_datasource.dart';
import 'package:frontend/data/resources/hospital/hospital_remote_datasource.dart';
import 'package:frontend/data/resources/hospital_dashboard/hospital_dashboard_remote_datasource.dart';
import 'package:frontend/domain/repositories/auth/auth_repository.dart';
import 'package:frontend/domain/repositories/hospital/hospital_repository.dart';
import 'package:frontend/domain/repositories/hospital_dashboard/hospital_dashboard_repository.dart';
import 'package:frontend/domain/usecases/auth/doctor_signin_usecase.dart';
import 'package:frontend/domain/usecases/auth/hospital_signin_usecase.dart';
import 'package:frontend/domain/usecases/auth/hosptial_create_usecase.dart';
import 'package:frontend/domain/usecases/hospital/search_hospital_usecase.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/filter_doctors_by_specialization_usecase.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/get_doctors_by_section_usecase.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/get_hospital_metrics_usecase.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/get_specializations_usecase.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/search_doctors_usecase.dart';
import 'package:frontend/presentation/auth/bloc/auth_bloc.dart';
import 'package:frontend/presentation/hospital_dashboard/bloc/hospital_dashboard_bloc.dart';
import 'package:frontend/presentation/hospital_search/bloc/hospital_search_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //Api
  sl.registerLazySingleton<Dio>(() => ApiClient().dio);




  //Auth
  sl.registerLazySingleton<DoctorSignInUsecase>(() => DoctorSignInUsecase());
  sl.registerLazySingleton<HospitalSignInUsecase>(
    () => HospitalSignInUsecase(),
  );
  sl.registerLazySingleton<HosptialCreateUsecase>(
    () => HosptialCreateUsecase(),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(sl<HosptialCreateUsecase>()),
  );




  // Auth - Hospital search
  sl.registerLazySingleton<HospitalRemoteDataSource>(
    () => HospitalRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<HospitalRepository>(
    () => HospitalRepositoryImpl(
      remoteDataSource: sl<HospitalRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<SearchHospitalUsecase>(
    () => SearchHospitalUsecase(sl<HospitalRepository>()),
  );
  sl.registerFactory<HospitalSearchBloc>(
    () => HospitalSearchBloc(sl<SearchHospitalUsecase>()),
  );



  //Hospital Dashboard
  sl.registerLazySingleton<HospitalDashboardRemoteDataSource>(
    () => HospitalDashboardRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<HospitalDashboardRepository>(
    () => HospitalDashboardRepositoryImpl(remoteDataSource: sl<HospitalDashboardRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetDoctorsBySectionUsecase());
  sl.registerLazySingleton(() => SearchDoctorsUsecase());
  sl.registerLazySingleton(() => FilterDoctorsBySpecializationUsecase());
  sl.registerLazySingleton(() => GetSpecializationsUsecase());
  sl.registerLazySingleton(() => GetHospitalMetricsUsecase());
  sl.registerFactory(
    () => HospitalDashboardBloc(
      getDoctorsBySectionUsecase: sl(),
      searchDoctorsUsecase: sl(),
      filterDoctorsBySpecializationUsecase: sl(),
      getSpecializationsUsecase: sl(),
      getHospitalMetricsUsecase: sl(),
    ),
  );



  
}
