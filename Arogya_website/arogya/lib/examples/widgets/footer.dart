import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Container(
      color: AppColors.darkText,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 40),
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.local_hospital_rounded, color: AppColors.lightGreen, size: 22),
                const SizedBox(width: 8),
                Text('Arogya', style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.white)),
              ]),
              const SizedBox(height: 10),
              Text('Smart hospital management\nfor modern healthcare.', style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white54, height: 1.6)),
            ])),
            if (isWide) ...[
              Expanded(child: _FooterCol(title: 'Product', links: ['Features', 'How it works'])),
              Expanded(child: _FooterCol(title: 'Support', links: ['Contact', 'Privacy Policy'])),
            ],
          ]),
          const SizedBox(height: 32),
          const Divider(color: Colors.white12),
          const SizedBox(height: 16),
          Text('© 2025 Arogya. All rights reserved.', style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white38)),
        ],
      ),
    );
  }
}

class _FooterCol extends StatelessWidget {
  final String title;
  final List<String> links;
  const _FooterCol({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.white)),
      const SizedBox(height: 10),
      ...links.map((l) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(l, style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white54)))),
    ]);
  }
}
