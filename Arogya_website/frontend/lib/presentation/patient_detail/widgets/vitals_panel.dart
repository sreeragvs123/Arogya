import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Screenshots only showed the Prescription and Clinical Report tabs in
/// detail, so this is a minimal placeholder — expand with real vitals
/// charts/tables once that design is available.
class VitalsPanel extends StatelessWidget {
  const VitalsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: const Text(
        'Detailed vitals view — TODO once design is provided.',
        style: TextStyle(color: AppColors.textMuted),
      ),
    );
  }
}
