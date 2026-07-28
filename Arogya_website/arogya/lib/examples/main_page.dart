import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/departments_page.dart';
import 'pages/doctors_page.dart';
import 'pages/patients_page.dart';
import 'pages/inventory_page.dart';
import 'pages/patient_register_page.dart';
import 'pages/qr_card_page.dart';
import 'pages/checkup_receipt_page.dart';




class ArogyaApp extends StatelessWidget {
  const ArogyaApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arogya — Hospital Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
 
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;
 
    switch (settings.name) {
      case '/':
        return _fadeRoute(const HomePage(), settings);
 
      case '/login':
        return _fadeRoute(const LoginPage(), settings);
 
      case '/register':
        return _fadeRoute(const RegisterPage(), settings);
 
      case '/dashboard':
        return _fadeRoute(
          DashboardPage(hospitalName: args?['hospitalName'] ?? 'Hospital'),
          settings,
        );
 
      case '/departments':
        return _fadeRoute(
          DepartmentsPage(hospitalId: args?['hospitalId'] ?? ''),
          settings,
        );
 
      case '/doctors':
        return _fadeRoute(
          DoctorsPage(
            departmentId: args?['departmentId'] ?? '',
            departmentName: args?['departmentName'] ?? 'Department',
          ),
          settings,
        );
 
      case '/patients':
        return _fadeRoute(
          PatientsPage(
            doctorId: args?['doctorId'] ?? '',
            doctorName: args?['doctorName'] ?? 'Doctor',
          ),
          settings,
        );
 
      case '/inventory':
        return _fadeRoute(const InventoryPage(), settings);
 
      case '/patient-register':
        return _fadeRoute(const PatientRegisterPage(), settings);
 
      case '/qr-card':
        return _fadeRoute(
          QrCardPage(patientData: args ?? {}),
          settings,
        );
 
      case '/checkup-receipt':
        return _fadeRoute(
          CheckupReceiptPage(patientId: args?['patientId'] ?? ''),
          settings,
        );
 
      default:
        return _fadeRoute(const NotFoundPage(), settings);
    }
  }
 
  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
 
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                size: 64, color: AppColors.lightGreen),
            const SizedBox(height: 16),
            Text('Page not found',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
 