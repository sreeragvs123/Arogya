class ApiRoutes {
  ApiRoutes._();

  //Auth
  static final String getRefreshToken = "auth/doctor/refresh";
  static final String hospitalSignIn = "/auth/hospital/signIn";
  static final String createHospital = "/auth/hospital/create";
  static final String doctorSignIn = "/auth/doctor/signIn";
  static final String createDoctor = "/auth/doctor/create";

  static final String hospitalSearch = "/hospital/search";



  //Hospital_dashboard
  static String hospitalDoctorsBySection(int hospitalId) =>'/hospital/dashboard/$hospitalId/doctors';
  static String hospitalDoctorsSearch(int hospitalId) =>'/hospital/dashboard/$hospitalId/doctors/search';
  static String hospitalDoctorsSpecializations(int hospitalId) =>'/hospital/dashboard/$hospitalId/doctors/specializations';
  static String hospitalDoctorsFilterSpecialization(int hospitalId) =>'/hospital/dashboard/$hospitalId/doctors/filter-specialization';
  static String hospitalMetrics(int hospitalId) =>'/hospital/dashboard/$hospitalId/metrics';

}
