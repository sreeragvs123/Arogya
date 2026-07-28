import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class DashboardStatCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String route;

  const DashboardStatCard({super.key, required this.icon, required this.label, required this.value, required this.color, required this.route});

  @override
  State<DashboardStatCard> createState() => _DashboardStatCardState();
}

class _DashboardStatCardState extends State<DashboardStatCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, widget.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _hovered ? widget.color : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _hovered ? widget.color : AppColors.borderColor),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Icon(widget.icon, color: _hovered ? AppColors.white : widget.color, size: 26),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.value, style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w700, color: _hovered ? AppColors.white : AppColors.darkText)),
              Text(widget.label, style: GoogleFonts.dmSans(fontSize: 12, color: _hovered ? AppColors.lightGreen : AppColors.mutedText)),
            ]),
          ]),
        ),
      ),
    );
  }
}
