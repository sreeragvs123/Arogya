import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import 'package:frontend/presentation/auth/pages/auth_page.dart';
import 'package:frontend/presentation/doctor_dashboard/pages/doctor_page.dart';
import 'package:frontend/presentation/doctor_patient_detail/pages/patient_detail_page.dart';
import 'package:frontend/presentation/doctor_patients/pages/patients_page.dart';
import 'package:frontend/presentation/doctor_qr_sync/pages/patient_qr_sync_page.dart';
import 'package:frontend/presentation/hospital_doctor_dashboard/pages/hospital_dashboard_page.dart';
import 'package:frontend/presentation/hospital_doctor_detail/pages/doctor_detail_page.dart';
import 'package:frontend/presentation/hospital_staff_dashboard/pages/hospital_staff_page.dart';
import 'package:frontend/presentation/staff_dashboard/pages/department_doctors_page.dart';
import 'package:frontend/presentation/staff_dashboard/pages/doctor_queue_page.dart';
import 'package:frontend/presentation/staff_dashboard/widgets/doctor_card.dart';

// ─── Route Name Constants ────────────────────────────────────────────────────

class AppRoutes {
  AppRoutes._();

  // Shared / Auth
  static const String auth = '/auth';

  // Doctor portal
  static const String doctorDashboard = '/doctor-dashboard';
  static const String myPatients = '/patients';
  static const String patientDetail = '/patients/detail';
  static const String scanPatientQr = '/scan-qr';
  static const String notifications = '/notifications';

  // Hospital admin portal
  static const String hospitalDashboard = '/hospital-dashboard';
  static const String staffDirectory = '/hospital/staff';
  static const String doctorDetail = '/hospital/doctor-detail';
  static const String hospitalOverview = '/hospital-overview';
  static const String doctorsDirectory = '/doctors-directory';
  static const String departments = '/departments';
  static const String patientRecords = '/patient-records';
  static const String facilitySettings = '/facility-settings';
  static const String auditCompliance = '/audit-compliance';

  // Staff portal
  static const String staffDashboard = '/staff-dashboard';
  static const String departmentDoctors = '/staff/department-doctors';
  static const String doctorQueue = '/staff/doctor-queue';
}



class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {


      case AppRoutes.auth:
        return _route(settings, (_) => const AuthPage());

      case AppRoutes.doctorDashboard:
        final session = _arg<DoctorSession>(settings);
        return _route(settings, (_) => DoctorDashBoardPage(session: session!));


      case AppRoutes.myPatients:
        return _route(settings, (_) => const PatientsPage());

      case AppRoutes.patientDetail:
        final args = settings.arguments;
        final patientId = args is String
            ? args
            : (args is Map && args['patientId'] != null
                ? args['patientId'].toString()
                : '1');
        return _route(settings, (_) => PatientDetailPage(patientId: patientId));

      case AppRoutes.scanPatientQr:
        return _route(settings, (_) => const PatientQrSyncPage());


      case AppRoutes.hospitalDashboard:
        final (hospitalId, adminSession) = _resolveHospital(settings);
        return _route(
          settings,
          (_) => HospitalDashboardPage(
            hospitalId: hospitalId,
            session: adminSession,
          ),
        );


      case AppRoutes.staffDirectory:
        final (hospitalId, adminSession) = _resolveHospital(settings);
        return _route(
          settings,
          (_) => HospitalStaffPage(
            hospitalId: hospitalId,
            session: adminSession,
          ),
        );


      case AppRoutes.doctorDetail:
        int hospitalId = 1;
        int doctorId = 1;
        if (settings.arguments is Map<String, dynamic>) {
          final map = settings.arguments as Map<String, dynamic>;
          hospitalId = (map['hospitalId'] as int?) ?? 1;
          final raw = map['doctorId'];
          doctorId = raw is int ? raw : int.tryParse(raw.toString()) ?? 1;
        }
        return _route(
          settings,
          (_) => DoctorDetailPage(hospitalId: hospitalId, doctorId: doctorId),
        );


      case AppRoutes.departmentDoctors:
        final staffSession = _arg<StaffSession>(settings) ??
            StaffSession(
              accessToken: '',
              expiresAt: DateTime.now().add(const Duration(hours: 1)),
              role: UserRole.staff,
              staffId: 0,
              staffName: 'Staff User',
              hospitalId: null,
              department: 'GENERAL',
            );
        return _route(
          settings,
          (_) => DepartmentDoctorsPage(session: staffSession),
        );


      case AppRoutes.doctorQueue:
        final doctor = _arg<DoctorProfile>(settings) ??
            const DoctorProfile(
              name: 'Doctor',
              role: 'Specialist',
              specialty: 'General Medicine',
              cabin: '101',
              wait: '0m',
              pending: 0,
            );
        return _route(settings, (_) => DoctorQueuePage(doctor: doctor));

      // ── Notifications (stub) ──────────────────────────────────────────────
      case AppRoutes.notifications:
        return _route(
          settings,
          (_) => _NotImplementedPage(routeName: settings.name ?? ''),
        );

      // ── Default fallback ──────────────────────────────────────────────────
      default:
        return _route(settings, (_) => const AuthPage());
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Creates a [MaterialPageRoute] with the correct [RouteSettings].
  static MaterialPageRoute<T> _route<T>(
    RouteSettings settings,
    Widget Function(BuildContext) builder,
  ) =>
      MaterialPageRoute<T>(builder: builder, settings: settings);

  /// Casts [settings.arguments] to [T] if possible, otherwise returns null.
  static T? _arg<T>(RouteSettings settings) {
    final args = settings.arguments;
    if (args is T) return args;
    if (args is Map<String, dynamic>) {
      final v = args['session'] ?? args['data'];
      if (v is T) return v;
    }
    return null;
  }

  /// Resolves a (hospitalId, HospitalAdminSession?) pair from route arguments.
  static (int, HospitalAdminSession?) _resolveHospital(RouteSettings settings) {
    final args = settings.arguments;
    if (args is HospitalAdminSession) {
      return (args.hospitalId ?? 1, args);
    } else if (args is int) {
      return (args, null);
    } else if (args is Map<String, dynamic>) {
      final id = (args['hospitalId'] as int?) ?? 1;
      final s = args['session'] as HospitalAdminSession?;
      return (s?.hospitalId ?? id, s);
    }
    return (1, null);
  }
}

// ─── Stub Page ───────────────────────────────────────────────────────────────

class _NotImplementedPage extends StatelessWidget {
  final String routeName;
  const _NotImplementedPage({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('TODO: build page for "$routeName"')),
    );
  }
}
