import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  const AuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      body: isWide
          ? Row(children: [
              Expanded(child: Container(
                color: AppColors.primaryGreen,
                padding: const EdgeInsets.all(48),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/'),
                    child: Row(children: [
                      const Icon(Icons.local_hospital_rounded, color: AppColors.white, size: 32),
                      const SizedBox(width: 10),
                      Text('Arogya', style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.white)),
                    ]),
                  ),
                  const SizedBox(height: 48),
                  Text('Caring for patients,\nsimplifying hospitals.', style: GoogleFonts.playfairDisplay(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.white, height: 1.2)),
                  const SizedBox(height: 16),
                  Text('Arogya brings together departments, doctors, and patients on a single intelligent platform.', style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.lightGreen, height: 1.7)),
                ]),
              )),
              Expanded(child: Center(child: SingleChildScrollView(
                padding: const EdgeInsets.all(48),
                child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440), child: child),
              ))),
            ])
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(children: [
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/'),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.local_hospital_rounded, color: AppColors.primaryGreen, size: 28),
                    const SizedBox(width: 8),
                    Text('Arogya', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
                  ]),
                ),
                const SizedBox(height: 32),
                child,
              ]),
            ),
    );
  }
}
