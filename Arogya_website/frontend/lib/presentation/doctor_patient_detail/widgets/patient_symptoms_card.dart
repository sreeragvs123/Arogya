import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PatientSymptomsCard extends StatefulWidget {
  final List<String> symptoms;
  final ValueChanged<String> onAddSymptom;
  final ValueChanged<String> onRemoveSymptom;

  const PatientSymptomsCard({
    super.key,
    required this.symptoms,
    required this.onAddSymptom,
    required this.onRemoveSymptom,
  });

  @override
  State<PatientSymptomsCard> createState() => _PatientSymptomsCardState();
}

class _PatientSymptomsCardState extends State<PatientSymptomsCard> {
  final TextEditingController _symptomController = TextEditingController();

  @override
  void dispose() {
    _symptomController.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _symptomController.text.trim();
    if (value.isEmpty) return;
    widget.onAddSymptom(value);
    _symptomController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patient Symptoms',
            style: TextStyle(fontFamily: 'Georgia', fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tag symptoms reported during this visit.',
            style: TextStyle(fontSize: 13.5, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _symptomController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Dizziness, Fatigue, Headache',
                    prefixIcon: Icon(Icons.sick_outlined, color: AppColors.textMuted),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.add_rounded, color: AppColors.primary),
                label: const Text('Add', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.emergencyBackground,
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          if (widget.symptoms.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.symptoms
                  .map((symptom) => _SymptomChip(
                        label: symptom,
                        onRemove: () => widget.onRemoveSymptom(symptom),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _SymptomChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _SymptomChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.softPanel,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.close_rounded, size: 15, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}