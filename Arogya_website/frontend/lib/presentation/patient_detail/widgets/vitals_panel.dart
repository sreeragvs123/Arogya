import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class VitalsPanel extends StatefulWidget {
  const VitalsPanel({super.key});

  @override
  State<VitalsPanel> createState() => _VitalsPanelState();
}

class _VitalsPanelState extends State<VitalsPanel> {
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _bloodPressureController = TextEditingController();
  final TextEditingController _bodyTempController = TextEditingController();
  final TextEditingController _bloodSugarController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  @override
  void dispose() {
    _heartRateController.dispose();
    _bloodPressureController.dispose();
    _bodyTempController.dispose();
    _bloodSugarController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _handleUpdateVitals() {
    // TODO: validate fields, persist via repository call,
    // then refresh VitalsTrendCard (likely via bloc/state once wired up).
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
                controller: _heartRateController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _VitalsField(
                label: 'Blood Pressure (mmHg)',
                hint: 'e.g. 120/80',
                controller: _bloodPressureController,
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
                controller: _bodyTempController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _VitalsField(
                label: 'Blood Sugar (mg/dL)',
                hint: 'e.g. 95',
                controller: _bloodSugarController,
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
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _VitalsField(
                label: 'Height (cm)',
                hint: 'e.g. 175',
                controller: _heightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _handleUpdateVitals,
            icon: const Icon(Icons.autorenew_rounded, size: 18, color: Colors.white),
            label: const Text(
              'Update Vitals',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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