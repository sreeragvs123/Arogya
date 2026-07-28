// ── Shared reusable widgets (exported for other pages) ────────────────────────
import 'package:arogya/examples/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const SummaryChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lightGreen.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: AppColors.primaryGreen),
        const SizedBox(width: 6),
        Text(label,
            style: GoogleFonts.dmSans(
                fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primaryGreen)),
      ]),
    );
  }
}




class PageHeader extends StatelessWidget {
  final bool isWide;
  final String title;
  final String subtitle;
  const PageHeader({required this.isWide, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.borderColor)),
      ),
      child: Row(children: [
        if (!isWide)
          Builder(builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.primaryGreen),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          )),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: GoogleFonts.playfairDisplay(
                  fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.darkText)),
          Text(subtitle,
              style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mutedText)),
        ]),
        const Spacer(),
        Text(_todayDate(), style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mutedText)),
      ]),
    );
  }

  String _todayDate() {
    final now = DateTime.now();
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}

class EmptyState extends StatelessWidget {
  final String message;
  const EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.search_off_rounded, size: 52, color: AppColors.lightGreen),
          const SizedBox(height: 12),
          Text(message,
              style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.mutedText)),
        ]),
      ),
    );
  }
}


class Breadcrumb extends StatelessWidget {
  final List<String> items;
  const Breadcrumb({required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.asMap().entries.expand((entry) {
        final isLast = entry.key == items.length - 1;
        return [
          GestureDetector(
            onTap: isLast ? null : () => Navigator.pop(context),
            child: Text(
              entry.value,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: isLast ? AppColors.primaryGreen : AppColors.mutedText,
                fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          if (!isLast)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.chevron_right_rounded, size: 14, color: AppColors.mutedText),
            ),
        ];
      }).toList(),
    );
  }
}

class FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primaryGreen : AppColors.borderColor),
        ),
        child: Text(label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: selected ? AppColors.white : AppColors.darkText,
            )),
      ),
    );
  }
}