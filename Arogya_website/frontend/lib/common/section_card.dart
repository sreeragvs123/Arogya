import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Generic white/tinted rounded card used for the right-rail panels.
/// Keeps padding, radius, and border consistent without repeating
/// BoxDecoration boilerplate in every widget.
class SectionCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;

  const SectionCard({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.cardBackground,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
