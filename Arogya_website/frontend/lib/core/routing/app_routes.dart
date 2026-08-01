import 'package:flutter/material.dart';
import '../../presentation/qr_sync/pages/patient_qr_sync_page.dart';
import '../../presentation/dashboard/pages/dashboard_page.dart';
import '../../presentation/auth/pages/auth_page.dart';
import '../../presentation/patient_detail/pages/patient_detail_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String auth = '/auth';
  static const String dashboard = '/dashboard';
  static const String myPatients = '/patients';
  static const String scanPatientQr = '/scan-qr';
  static const String notifications = '/notifications';
  static const String patientDetail = '/patients/detail';
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
          builder: (_) => const DashboardPage(),
          settings: settings,
        );

      case AppRoutes.scanPatientQr:
        return MaterialPageRoute(
          builder: (_) => const PatientQrSyncPage(),
          settings: settings,
        );

      case AppRoutes.patientDetail:
        return MaterialPageRoute(
          builder: (_) => const PatientDetailPage(),
          settings: settings,
        );

      case AppRoutes.myPatients:
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
