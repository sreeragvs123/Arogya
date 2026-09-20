class ApiRoutes {
  ApiRoutes._();

  //Auth
  static final String getRefreshToken = "/auth/doctor/refresh";
  static const hospitalSignIn = '/auth/hospital/signIn';
  static final String createHospital = "/auth/hospital/create";
  static final String doctorSignIn = "/auth/doctor/signIn";
  static final String createDoctor = "/auth/doctor/create";
  static final String hospitalSearch = "/hospital/search";
  static final String staffSignIn = "/auth/staff/signIn";
  static  String createStaff(int hospitalId) => "/auth/staff/create/$hospitalId";



  //Hospital_dashboard
  static String hospitalDoctorsBySection(int hospitalId) =>
      '/hospital/dashboard/search/$hospitalId/doctors';
  static String hospitalDoctorsSearch(int hospitalId) =>
      '/hospital/dashboard/search/$hospitalId/doctors/search';
  static String hospitalDoctorsSpecializations(int hospitalId) =>
      '/hospital/dashboard/search/$hospitalId/doctors/specializations';
  static String hospitalDoctorsFilterSpecialization(int hospitalId) =>
      '/hospital/dashboard/search/$hospitalId/doctors/filter-specialization';
  static String hospitalMetrics(int hospitalId) =>
      '/hospital/dashboard/search/$hospitalId/metrics';
  static String doctorCreate(int hospitalId) =>
      '/auth/doctor/create/$hospitalId';
  static String hospitalDoctorDetail(int hospitalId, int doctorId) =>
    '/hospital/dashboard/doctor/$hospitalId/$doctorId';


  //Doctor_dashboard
  static String doctorDashboardSummary(int doctorId) =>
      '/doctor/$doctorId/dashboard/summary';
  static const String doctorDashboardConsultations =
      '/doctor/dashboard/consultations';
  static const String doctorDashboardActivity = '/doctor/dashboard/activity';
  static String consultationStart(String consultationId) =>
      '/doctor/consultations/$consultationId/start';
  static String consultationJoinCall(String consultationId) =>
      '/doctor/consultations/$consultationId/join-call';

  // Patients directory
  static  String doctorPatientsSummary(int doctorId,int hospitalId) => '/doctor/$doctorId/$hospitalId/appointments/count';
  static const String doctorPatientsActive = '/doctor/patients/active';
  static const String doctorPatients = '/doctor/patients';

  // Patient record sync (QR / manual lookup)
  static const String patientLookup = '/patients/lookup';

  // Patient detail workspace
  static String patientDetail(String patientId) => '/patients/$patientId';
  static String patientVitals(String patientId) =>
      '/patients/$patientId/vitals';
  static String patientObservations(String patientId) =>
      '/patients/$patientId/observations';
  static String patientPrescriptionDraft(String patientId) =>
      '/patients/$patientId/prescription/draft';
  static String patientPrescriptionSave(String patientId) =>
      '/patients/$patientId/prescription/save';
  static String patientClinicalReportGenerate(String patientId) =>
      '/patients/$patientId/clinical-report/generate';
}
