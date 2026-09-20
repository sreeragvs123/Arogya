import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/patient_detail/patient_detail_entity.dart';
import 'added_medicine_chip.dart';

class PrescriptionPanel extends StatefulWidget {
  final List<PrescriptionItemEntity> items;
  final void Function(String name, String dosage, String frequency, String timing) onAddItem;
  final ValueChanged<String> onRemoveItem;
  final VoidCallback onDiscard;
  final VoidCallback onSave;
  final bool isSaving;

  const PrescriptionPanel({
    super.key,
    required this.items,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onDiscard,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<PrescriptionPanel> createState() => _PrescriptionPanelState();
}

class _PrescriptionPanelState extends State<PrescriptionPanel> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  String _timing = 'After Food';

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  void _handleAddToPrescription() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a medicine name first.')),
      );
      return;
    }
    widget.onAddItem(name, _dosageController.text.trim(), _frequencyController.text.trim(), _timing);
    _nameController.clear();
    _dosageController.clear();
    _frequencyController.clear();
    setState(() => _timing = 'After Food');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Prescription Formulation',
            style: TextStyle(fontFamily: 'Georgia', fontSize: 24, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search Hospital Inventory (e.g. Paracetamol, Amoxicillin)...',
            prefixIcon: Icon(Icons.inventory_2_outlined, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Medicine Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(hintText: 'Enter medicine'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Dosage', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _dosageController,
                                decoration: const InputDecoration(hintText: 'e.g. 500mg'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Frequency (M-A-N)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _frequencyController,
                                decoration: const InputDecoration(hintText: 'e.g. 1-0-1'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Timing', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                initialValue: _timing,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'After Food', child: Text('After Food')),
                                  DropdownMenuItem(value: 'Before Food', child: Text('Before Food')),
                                  DropdownMenuItem(value: 'Empty Stomach', child: Text('Empty Stomach')),
                                ],
                                onChanged: (value) => setState(() => _timing = value ?? _timing),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _handleAddToPrescription,
                        icon: const Icon(Icons.add_rounded, color: AppColors.primary),
                        label: const Text('Add to Prescription',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.emergencyBackground,
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.softPanel,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Added Medicines', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 14),
                    if (widget.items.isEmpty)
                      const Text('No medicines added yet.',
                          style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary))
                    else
                      for (final medicine in widget.items)
                        AddedMedicineChip(
                          key: ValueKey(medicine.id),
                          medicine: medicine,
                          onRemove: () => widget.onRemoveItem(medicine.id),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Divider(color: AppColors.divider),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: widget.isSaving ? null : widget.onDiscard,
              child: const Text('Discard', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: widget.isSaving ? null : widget.onSave,
              icon: widget.isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.save_outlined, size: 18, color: Colors.white),
              label: Text(widget.isSaving ? 'Saving...' : 'Save Prescription',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15)),
            ),
          ],
        ),
      ],
    );
  }
}
