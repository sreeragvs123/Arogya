import 'package:flutter/material.dart';
import 'package:frontend/presentation/patients/pages/patients_page.dart';
import '../../presentation/qr_sync/pages/patient_qr_sync_page.dart';
import '../../presentation/doctor_dashboard/pages/doctor_page.dart';
import '../../presentation/auth/pages/auth_page.dart';
import '../../presentation/patient_detail/pages/patient_detail_page.dart';

class AppRoutes {
  // AppRoutes._();

  static const String auth = '/auth';
  static const String dashboard = '/dashboard';
  static const String hospitalDashboard = '/hospital-dashboard';
  static const String myPatients = '/patients';
  static const String scanPatientQr = '/scan-qr';
  static const String notifications = '/notifications';
  static const String patientDetail = '/patients/detail';
  static const String hospitalOverview = '/hospital-overview';
  static const String doctorsDirectory = '/doctors-directory';
  static const String departments = '/departments';
  static const String patientRecords = '/patient-records';
  static const String facilitySettings = '/facility-settings';
  static const String auditCompliance = '/audit-compliance';
  static const String doctorDetail = '/doctor-detail';
}

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.auth:
        return MaterialPageRoute(
          builder: (_) => const AuthPage(),
          settings: settings,
        );

      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (_) => const DoctorDashBoardPage(),
          settings: settings,
        );

      case AppRoutes.scanPatientQr:
        return MaterialPageRoute(
          builder: (_) => const PatientQrSyncPage(),
          settings: settings,
        );

      case AppRoutes.patientDetail:
        final patientId = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => PatientDetailPage(
            patientId: patientId is String ? patientId : patientId.toString(),
          ),
          settings: settings,
        );

      case AppRoutes.myPatients:
        return MaterialPageRoute(
          builder: (_) => const PatientsPage(),
          settings: settings,
        );
      case AppRoutes.notifications:
        return MaterialPageRoute(
          builder: (_) => _NotImplementedPage(routeName: settings.name ?? ''),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const PatientQrSyncPage(),
        );
    }
  }
}

/// Temporary stand-in so navigation never dead-ends while other pages
/// are still being built.
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
