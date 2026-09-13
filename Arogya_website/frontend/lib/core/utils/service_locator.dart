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
import 'package:frontend/domain/usecases/hospital_dashboard/create_doctor_usecase.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/filter_doctors_by_specialization_usecase.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/get_doctors_by_section_usecase.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/get_hospital_metrics_usecase.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/get_specializations_usecase.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/search_doctors_usecase.dart';
import 'package:frontend/data/repositories/doctor_dashboard/doctor_dashboard_repository_impl.dart';
import 'package:frontend/data/resources/doctor_dashboard/doctor_dashboard_remote_datasource.dart';
import 'package:frontend/domain/repositories/doctor_dashboard/doctor_dashboard_repository.dart';
import 'package:frontend/domain/usecases/doctor_dashboard/get_dashboard_summary_usecase.dart';
import 'package:frontend/domain/usecases/doctor_dashboard/get_recent_activity_usecase.dart';
import 'package:frontend/domain/usecases/doctor_dashboard/get_upcoming_consultations_usecase.dart';
import 'package:frontend/domain/usecases/doctor_dashboard/join_consultation_call_usecase.dart';
import 'package:frontend/domain/usecases/doctor_dashboard/start_consultation_usecase.dart';
import 'package:frontend/presentation/auth/bloc/auth_bloc.dart';
import 'package:frontend/data/repositories/patients/patients_repository_impl.dart';
import 'package:frontend/data/resources/patients/patients_remote_datasource.dart';
import 'package:frontend/domain/repositories/patients/patients_repository.dart';
import 'package:frontend/domain/usecases/patients/get_active_patient_usecase.dart';
import 'package:frontend/domain/usecases/patients/get_patients_directory_summary_usecase.dart';
import 'package:frontend/domain/usecases/patients/get_patients_usecase.dart';
import 'package:frontend/domain/usecases/patients/lookup_patient_usecase.dart';
import 'package:frontend/presentation/doctor_dashboard/bloc/dashboard_bloc.dart';
import 'package:frontend/presentation/patients/bloc/patients_bloc.dart';
import 'package:frontend/data/repositories/patient_detail/patient_detail_repository_impl.dart';
import 'package:frontend/data/resources/patient_detail/patient_detail_remote_datasource.dart';
import 'package:frontend/domain/repositories/patient_detail/patient_detail_repository.dart';
import 'package:frontend/domain/usecases/patient_detail/generate_clinical_report_usecase.dart';
import 'package:frontend/domain/usecases/patient_detail/get_patient_detail_usecase.dart';
import 'package:frontend/domain/usecases/patient_detail/get_prescription_draft_usecase.dart';
import 'package:frontend/domain/usecases/patient_detail/get_recent_observations_usecase.dart';
import 'package:frontend/domain/usecases/patient_detail/get_vitals_usecase.dart';
import 'package:frontend/domain/usecases/patient_detail/save_observations_usecase.dart';
import 'package:frontend/domain/usecases/patient_detail/save_prescription_usecase.dart';
import 'package:frontend/domain/usecases/patient_detail/update_vitals_usecase.dart';
import 'package:frontend/presentation/patient_detail/bloc/patient_details_bloc.dart';
import 'package:frontend/presentation/qr_sync/bloc/qr_bloc.dart';
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
    () => AuthBloc(sl<HosptialCreateUsecase>(),sl<HospitalSignInUsecase>()),
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
  sl.registerLazySingleton(() => CreateDoctorUsecase(sl()));


  //Doctor Dashboard
  sl.registerLazySingleton<DoctorDashboardRemoteDataSource>(
    () => DoctorDashboardRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<DoctorDashboardRepository>(
    () => DoctorDashboardRepositoryImpl(remoteDataSource: sl<DoctorDashboardRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetDashboardSummaryUsecase(sl()));
  sl.registerLazySingleton(() => GetUpcomingConsultationsUsecase(sl()));
  sl.registerLazySingleton(() => GetRecentActivityUsecase(sl()));
  sl.registerLazySingleton(() => StartConsultationUsecase(sl()));
  sl.registerLazySingleton(() => JoinConsultationCallUsecase(sl()));
  sl.registerFactory(
    () => DashboardBloc(
      getDashboardSummaryUsecase: sl(),
      getUpcomingConsultationsUsecase: sl(),
      getRecentActivityUsecase: sl(),
      startConsultationUsecase: sl(),
      joinConsultationCallUsecase: sl(),
    ),
  );

  //Patients Directory
  sl.registerLazySingleton<PatientsRemoteDataSource>(
    () => PatientsRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<PatientsRepository>(
    () => PatientsRepositoryImpl(remoteDataSource: sl<PatientsRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetPatientsDirectorySummaryUsecase(sl()));
  sl.registerLazySingleton(() => GetActivePatientUsecase(sl()));
  sl.registerLazySingleton(() => GetPatientsUsecase(sl()));
  sl.registerLazySingleton(() => LookupPatientUsecase(sl()));
  sl.registerFactory(
    () => PatientsBloc(
      getPatientsDirectorySummaryUsecase: sl(),
      getActivePatientUsecase: sl(),
      getPatientsUsecase: sl(),
    ),
  );

  //Patient QR Sync
  sl.registerFactory(() => QrBloc(lookupPatientUsecase: sl()));

  //Patient Detail
  sl.registerLazySingleton<PatientDetailRemoteDataSource>(
    () => PatientDetailRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<PatientDetailRepository>(
    () => PatientDetailRepositoryImpl(remoteDataSource: sl<PatientDetailRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetPatientDetailUsecase(sl()));
  sl.registerLazySingleton(() => GetVitalsUsecase(sl()));
  sl.registerLazySingleton(() => GetRecentObservationsUsecase(sl()));
  sl.registerLazySingleton(() => UpdateVitalsUsecase(sl()));
  sl.registerLazySingleton(() => SaveObservationsUsecase(sl()));
  sl.registerLazySingleton(() => GetPrescriptionDraftUsecase(sl()));
  sl.registerLazySingleton(() => SavePrescriptionUsecase(sl()));
  sl.registerLazySingleton(() => GenerateClinicalReportUsecase(sl()));
  sl.registerFactory(
    () => PatientDetailsBloc(
      getPatientDetailUsecase: sl(),
      getVitalsUsecase: sl(),
      getRecentObservationsUsecase: sl(),
      updateVitalsUsecase: sl(),
      saveObservationsUsecase: sl(),
      getPrescriptionDraftUsecase: sl(),
      savePrescriptionUsecase: sl(),
      generateClinicalReportUsecase: sl(),
    ),
  );
}
