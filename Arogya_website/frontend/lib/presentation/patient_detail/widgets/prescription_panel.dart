import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'added_medicine_chip.dart';

class PrescriptionPanel extends StatefulWidget {
  const PrescriptionPanel({super.key});

  @override
  State<PrescriptionPanel> createState() => _PrescriptionPanelState();
}

class _PrescriptionPanelState extends State<PrescriptionPanel> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  String _timing = 'After Food';

  final List<AddedMedicine> _addedMedicines = const [
    AddedMedicine(name: 'Atorvastatin 10mg', dosageSchedule: '1-0-1 • After Food'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  void _handleAddToPrescription() {
    // TODO: validate fields, append to prescription draft (bloc/state), clear inputs
  }

  void _handleDiscard() {
    // TODO: clear the current draft / navigate back
  }

  void _handleSave() {
    // TODO: persist prescription via repository call
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
                    for (final medicine in _addedMedicines)
                      AddedMedicineChip(medicine: medicine, onRemove: () {}), // TODO: remove from list
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
              onPressed: _handleDiscard,
              child: const Text('Discard', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _handleSave,
              icon: const Icon(Icons.save_outlined, size: 18, color: Colors.white),
              label: const Text('Save Prescription', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15)),
            ),
          ],
        ),
      ],
    );
  }
}
