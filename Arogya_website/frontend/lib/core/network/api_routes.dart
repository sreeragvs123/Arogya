class ApiRoutes {
  ApiRoutes._();

  //Auth
  static final String getRefreshToken = "/auth/doctor/refresh";
  static const String hospitalSignIn = '/auth/hospital/signIn';
  static final String createHospital = "/auth/hospital/create";
  static final String doctorSignIn = "/auth/doctor/signIn";
  static final String hospitalSearch = "/hospital/search";
  static final String staffSignIn = "/auth/staff/signIn";




  //Hospital_doctor_dashboard
  static const doctorsBySection = '/hospital/dashboard/search/doctors';
  static const doctorsSearch = '/hospital/dashboard/search/doctors/search';
  static const doctorSpecializations = '/hospital/dashboard/search/doctors/specializations';
  static const doctorsFilter = '/hospital/dashboard/search/doctors/filter-specialization';
  static const hospitalMetrics = '/hospital/dashboard/search/metrics';
  static String doctorCreate = "hospital/dashboard/doctor/create";
  static String hospitalDoctorDetail(int doctorId) =>'/hospital/dashboard/doctor/$doctorId';



  //Hospital_staff_dashboard
  static const staffCreate = '/hospital/dashboard/staff';
  static const String getAllStaff = '/hospital/dashboard/staff';



  //Doctor_dashboard
  static String doctorDashboardSummary(int doctorId) =>
      '/doctor/$doctorId/dashboard/summary';
  static const String doctorDashboardConsultations =
      '/doctor/consultations/today';
  static const String doctorDashboardActivity = '/doctor/dashboard/activity';
  static String consultationStart(String consultationId) =>
      '/doctor/consultations/$consultationId/start';
  static String consultationJoinCall(String consultationId) =>
      '/doctor/consultations/$consultationId/join-call';

  // Patients directory
  static String doctorPatientsSummary(int doctorId, int hospitalId) =>
      '/doctor/$doctorId/$hospitalId/appointments/count';
  static const String doctorPatientsActive = '/doctor/patients/active';
  static const String doctorPatients = '/doctor/patients/search';

  // Patient record sync (QR / manual lookup)
  static const String patientLookup = '/patients/lookup';

  // Patient detail workspace
  static String patientDetail(String patientId) => '/patients/$patientId/card';
  static String patientVitals(String patientId) =>
      '/doctor/appointment/$patientId/vitals';
  static String patientObservations(String patientId) =>
      '/doctor/appointment/$patientId/observations';
  static String patientPrescriptionDraft(String patientId) =>
      '/patients/$patientId/prescription/draft';
  static String patientPrescriptionSave(String patientId) =>
      '/doctor/appointment/$patientId/prescription-items';
  static String patientClinicalReportGenerate(String patientId) =>
      '/patients/$patientId/clinical-report/generate';
}
