class ApiRoutes {
  ApiRoutes._();

  //Auth
  static final String getRefreshToken = "auth/doctor/refresh";
  static const hospitalSignIn = '/auth/hospital/signIn';
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
  static String doctorCreate(int hospitalId) => '/auth/doctor/create/$hospitalId';

  // Doctor dashboard (clinician-facing "home" screen).
  // Scoped to the signed-in doctor via the Authorization bearer token
  // (see ApiClient interceptor) rather than a path parameter.
  static const String doctorDashboardSummary = '/doctor/dashboard/summary';
  static const String doctorDashboardConsultations = '/doctor/dashboard/consultations';
  static const String doctorDashboardActivity = '/doctor/dashboard/activity';
  static String consultationStart(String consultationId) => '/doctor/consultations/$consultationId/start';
  static String consultationJoinCall(String consultationId) => '/doctor/consultations/$consultationId/join-call';

  // Patients directory (also scoped to the signed-in doctor via the bearer token)
  static const String doctorPatientsSummary = '/doctor/patients/summary';
  static const String doctorPatientsActive = '/doctor/patients/active';
  static const String doctorPatients = '/doctor/patients';

  // Patient record sync (QR / manual lookup)
  static const String patientLookup = '/patients/lookup';

  // Patient detail workspace
  static String patientDetail(String patientId) => '/patients/$patientId';
  static String patientVitals(String patientId) => '/patients/$patientId/vitals';
  static String patientObservations(String patientId) => '/patients/$patientId/observations';
  static String patientPrescriptionDraft(String patientId) => '/patients/$patientId/prescription/draft';
  static String patientPrescriptionSave(String patientId) => '/patients/$patientId/prescription/save';
  static String patientClinicalReportGenerate(String patientId) =>
      '/patients/$patientId/clinical-report/generate';
}
