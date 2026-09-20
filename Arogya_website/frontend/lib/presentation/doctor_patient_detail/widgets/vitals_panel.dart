import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class VitalsPanel extends StatelessWidget {
  final TextEditingController heartRateController;
  final TextEditingController bloodPressureController;
  final TextEditingController bodyTempController;
  final TextEditingController bloodSugarController;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final bool isSaving;
  final VoidCallback onUpdateVitals;

  const VitalsPanel({
    super.key,
    required this.heartRateController,
    required this.bloodPressureController,
    required this.bodyTempController,
    required this.bloodSugarController,
    required this.weightController,
    required this.heightController,
    required this.onUpdateVitals,
    this.isSaving = false,
  });

  void _handleUpdateVitals(BuildContext context) {
    final hasAnyValue = [
      heartRateController.text,
      bloodPressureController.text,
      bodyTempController.text,
      bloodSugarController.text,
      weightController.text,
      heightController.text,
    ].any((v) => v.trim().isNotEmpty);

    if (!hasAnyValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter at least one measurement to update.')),
      );
      return;
    }

    onUpdateVitals();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vitals Update',
          style: TextStyle(fontFamily: 'Georgia', fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        const Text(
          'Record current physiological measurements',
          style: TextStyle(fontSize: 13.5, color: AppColors.textMuted),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _VitalsField(
                label: 'Heart Rate (BPM)',
                hint: 'e.g. 72',
                controller: heartRateController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _VitalsField(
                label: 'Blood Pressure (mmHg)',
                hint: 'e.g. 120/80',
                controller: bloodPressureController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _VitalsField(
                label: 'Body Temp (°F)',
                hint: 'e.g. 98.4',
                controller: bodyTempController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _VitalsField(
                label: 'Blood Sugar (mg/dL)',
                hint: 'e.g. 95',
                controller: bloodSugarController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _VitalsField(
                label: 'Weight (kg)',
                hint: 'e.g. 72',
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _VitalsField(
                label: 'Height (cm)',
                hint: 'e.g. 175',
                controller: heightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: isSaving ? null : () => _handleUpdateVitals(context),
            icon: isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.autorenew_rounded, size: 18, color: Colors.white),
            label: Text(
              isSaving ? 'Updating...' : 'Update Vitals',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}

class _VitalsField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _VitalsField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
