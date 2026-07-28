import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class Navbar extends StatelessWidget {
  final ScrollController scrollController;
  const Navbar({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
            child: Row(children: [
              const Icon(Icons.local_hospital_rounded, color: AppColors.primaryGreen, size: 28),
              const SizedBox(width: 10),
              Text('Arogya', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
            ]),
          ),
          const Spacer(),
          if (isWide) ...[
            TextButton(onPressed: () {}, child: Text('Features', style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.darkText, fontWeight: FontWeight.w500))),
            TextButton(onPressed: () {}, child: Text('How it works', style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.darkText, fontWeight: FontWeight.w500))),
            const SizedBox(width: 24),
            OutlinedButton(onPressed: () => Navigator.pushNamed(context, '/login'), child: const Text('Login')),
            const SizedBox(width: 12),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: const Text('Register Hospital')),
          ] else
            IconButton(icon: const Icon(Icons.menu_rounded, color: AppColors.primaryGreen), onPressed: () {}),
        ],
      ),
    );
  }
}
