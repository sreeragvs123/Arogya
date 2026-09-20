import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'clinical_observation_card.dart';
import 'patient_symptoms_card.dart';

class ObservationsPanel extends StatelessWidget {
  final List<String> symptoms;
  final ValueChanged<String> onAddSymptom;
  final ValueChanged<String> onRemoveSymptom;
  final TextEditingController clinicalNoteController;
  final VoidCallback onSaveClinicalNote;
  final bool isSavingNote;

  const ObservationsPanel({
    super.key,
    required this.symptoms,
    required this.onAddSymptom,
    required this.onRemoveSymptom,
    required this.clinicalNoteController,
    required this.onSaveClinicalNote,
    this.isSavingNote = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Visit Observations',
          style: TextStyle(fontFamily: 'Georgia', fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        const Text(
          'Log reported symptoms and clinical notes for this visit.',
          style: TextStyle(fontSize: 13.5, color: AppColors.textMuted),
        ),
        const SizedBox(height: 24),
        PatientSymptomsCard(
          symptoms: symptoms,
          onAddSymptom: onAddSymptom,
          onRemoveSymptom: onRemoveSymptom,
        ),
        const SizedBox(height: 24),
        const Divider(color: AppColors.divider),
        const SizedBox(height: 24),
        ClinicalObservationCard(
          controller: clinicalNoteController,
          onSave: onSaveClinicalNote,
          isSaving: isSavingNote,
        ),
      ],
    );
  }
}