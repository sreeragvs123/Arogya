import 'package:arogya/examples/widgets/shared_widgets.dart';
import 'package:flutter/material.dart' hide FilterChip;
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/sidebar.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _categoryFilter = 'All';

  final List<Map<String, dynamic>> _medicines = [
    {'id': 'M001', 'name': 'Paracetamol 500mg', 'category': 'Analgesic', 'stock': 450, 'unit': 'Tablets', 'minStock': 100, 'expiry': 'Dec 2026', 'manufacturer': 'Cipla', 'price': 2.50},
    {'id': 'M002', 'name': 'Amoxicillin 250mg', 'category': 'Antibiotic', 'stock': 80, 'unit': 'Capsules', 'minStock': 100, 'expiry': 'Mar 2026', 'manufacturer': 'Sun Pharma', 'price': 8.00},
    {'id': 'M003', 'name': 'Metformin 500mg', 'category': 'Antidiabetic', 'stock': 300, 'unit': 'Tablets', 'minStock': 100, 'expiry': 'Jun 2027', 'manufacturer': 'Dr. Reddys', 'price': 3.75},
    {'id': 'M004', 'name': 'Atorvastatin 10mg', 'category': 'Cardiac', 'stock': 15, 'unit': 'Tablets', 'minStock': 50, 'expiry': 'Sep 2025', 'manufacturer': 'Zydus', 'price': 12.00},
    {'id': 'M005', 'name': 'Azithromycin 500mg', 'category': 'Antibiotic', 'stock': 120, 'unit': 'Tablets', 'minStock': 60, 'expiry': 'Nov 2026', 'manufacturer': 'Cipla', 'price': 22.00},
    {'id': 'M006', 'name': 'Salbutamol Inhaler', 'category': 'Respiratory', 'stock': 35, 'unit': 'Units', 'minStock': 40, 'expiry': 'Aug 2026', 'manufacturer': 'GSK', 'price': 95.00},
    {'id': 'M007', 'name': 'Omeprazole 20mg', 'category': 'Gastric', 'stock': 500, 'unit': 'Capsules', 'minStock': 100, 'expiry': 'Jan 2027', 'manufacturer': 'Mankind', 'price': 4.50},
    {'id': 'M008', 'name': 'Cetirizine 10mg', 'category': 'Antihistamine', 'stock': 220, 'unit': 'Tablets', 'minStock': 80, 'expiry': 'May 2027', 'manufacturer': 'Sun Pharma', 'price': 3.00},
  ];

  final List<String> _categories = ['All', 'Analgesic', 'Antibiotic', 'Antidiabetic', 'Cardiac', 'Respiratory', 'Gastric', 'Antihistamine'];

  List<Map<String, dynamic>> get _filtered => _medicines.where((m) {
        final matchSearch = m['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            m['id'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            m['manufacturer'].toLowerCase().contains(_searchQuery.toLowerCase());
        final matchCat = _categoryFilter == 'All' || m['category'] == _categoryFilter;
        return matchSearch && matchCat;
      }).toList();

  int get _lowStockCount => _medicines.where((m) => (m['stock'] as int) <= (m['minStock'] as int)).length;
  int get _totalItems => _medicines.length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      drawer: isWide ? null : const AppSidebar(),
      body: Row(
        children: [
          if (isWide) const AppSidebar(),
          Expanded(
            child: Column(
              children: [
                PageHeader(isWide: isWide, title: 'Pharmacy Inventory', subtitle: 'Manage medicine stock and supply'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Low stock alert banner
                        if (_lowStockCount > 0)
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.errorRed.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.errorRed.withOpacity(0.3)),
                            ),
                            child: Row(children: [
                              const Icon(Icons.warning_amber_rounded, color: AppColors.errorRed, size: 18),
                              const SizedBox(width: 10),
                              Text('$_lowStockCount ${_lowStockCount == 1 ? 'medicine is' : 'medicines are'} running low or out of stock.',
                                  style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.errorRed, fontWeight: FontWeight.w500)),
                            ]),
                          ),
                        // Search + Add
                        Row(children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (v) => setState(() => _searchQuery = v),
                              decoration: InputDecoration(
                                hintText: 'Search medicines...',
                                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.mediumGreen, size: 20),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(icon: const Icon(Icons.close_rounded, size: 18), onPressed: () { _searchController.clear(); setState(() => _searchQuery = ''); })
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () => _showAddMedicineDialog(context),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Add Medicine'),
                          ),
                        ]),
                        const SizedBox(height: 16),
                        // Category filters
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _categories.map((c) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(label: c, selected: _categoryFilter == c, onTap: () => setState(() => _categoryFilter = c)),
                            )).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Summary chips
                        Row(children: [
                          SummaryChip(label: '$_totalItems Medicines', icon: Icons.medication_rounded),
                          const SizedBox(width: 10),
                          if (_lowStockCount > 0)
                            _LowStockChip(count: _lowStockCount),
                        ]),
                        const SizedBox(height: 24),
                        // Table header
                        if (isWide)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.lightGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(children: [
                              _ColHeader(label: 'Medicine', flex: 3),
                              _ColHeader(label: 'Category', flex: 2),
                              _ColHeader(label: 'Stock', flex: 2),
                              _ColHeader(label: 'Expiry', flex: 2),
                              _ColHeader(label: 'Price (₹)', flex: 1),
                              _ColHeader(label: 'Actions', flex: 2),
                            ]),
                          ),
                        const SizedBox(height: 8),
                        if (_filtered.isEmpty)
                          EmptyState(message: 'No medicines match "$_searchQuery"')
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (_, i) => _MedicineRow(
                              medicine: _filtered[i],
                              isWide: isWide,
                              onEdit: () => _showAddMedicineDialog(context, medicine: _filtered[i]),
                              onDelete: () => _confirmDelete(context, _filtered[i]['name']),
                              onRestock: () => _showRestockDialog(context, _filtered[i]),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMedicineDialog(BuildContext context, {Map<String, dynamic>? medicine}) {
    final nameCtrl = TextEditingController(text: medicine?['name'] ?? '');
    final mfgCtrl = TextEditingController(text: medicine?['manufacturer'] ?? '');
    final stockCtrl = TextEditingController(text: medicine?['stock']?.toString() ?? '');
    final minCtrl = TextEditingController(text: medicine?['minStock']?.toString() ?? '');
    final expiryCtrl = TextEditingController(text: medicine?['expiry'] ?? '');
    final priceCtrl = TextEditingController(text: medicine?['price']?.toString() ?? '');
    String selectedCategory = medicine?['category'] ?? 'Analgesic';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(medicine == null ? 'Add Medicine' : 'Edit Medicine',
              style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700)),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Medicine Name', prefixIcon: Icon(Icons.medication_rounded, color: AppColors.mediumGreen, size: 20))),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categories.where((c) => c != 'All').map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setDState(() => selectedCategory = v!),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: TextField(controller: stockCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Current Stock'))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: minCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Min Stock'))),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: TextField(controller: expiryCtrl, decoration: const InputDecoration(labelText: 'Expiry (e.g. Dec 2026)'))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price per unit (₹)'))),
                ]),
                const SizedBox(height: 12),
                TextField(controller: mfgCtrl, decoration: const InputDecoration(labelText: 'Manufacturer', prefixIcon: Icon(Icons.factory_outlined, color: AppColors.mediumGreen, size: 20))),
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  setState(() {
                    if (medicine == null) {
                      _medicines.add({
                        'id': 'M${(_medicines.length + 1).toString().padLeft(3, '0')}',
                        'name': nameCtrl.text, 'category': selectedCategory,
                        'stock': int.tryParse(stockCtrl.text) ?? 0,
                        'unit': 'Units', 'minStock': int.tryParse(minCtrl.text) ?? 50,
                        'expiry': expiryCtrl.text, 'manufacturer': mfgCtrl.text,
                        'price': double.tryParse(priceCtrl.text) ?? 0.0,
                      });
                    } else {
                      medicine['name'] = nameCtrl.text;
                      medicine['category'] = selectedCategory;
                      medicine['stock'] = int.tryParse(stockCtrl.text) ?? medicine['stock'];
                      medicine['minStock'] = int.tryParse(minCtrl.text) ?? medicine['minStock'];
                      medicine['expiry'] = expiryCtrl.text;
                      medicine['manufacturer'] = mfgCtrl.text;
                      medicine['price'] = double.tryParse(priceCtrl.text) ?? medicine['price'];
                    }
                  });
                  Navigator.pop(ctx);
                }
              },
              child: Text(medicine == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRestockDialog(BuildContext context, Map<String, dynamic> medicine) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Restock ${medicine['name']}', style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Current stock: ${medicine['stock']} ${medicine['unit']}', style: GoogleFonts.dmSans(color: AppColors.mutedText)),
          const SizedBox(height: 16),
          TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Units to add', prefixIcon: Icon(Icons.add_box_outlined, color: AppColors.mediumGreen, size: 20))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final add = int.tryParse(ctrl.text) ?? 0;
              if (add > 0) setState(() => medicine['stock'] = (medicine['stock'] as int) + add);
              Navigator.pop(context);
            },
            child: const Text('Add Stock'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Remove $name?', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
        content: Text('This medicine will be permanently removed from inventory.', style: GoogleFonts.dmSans(color: AppColors.mutedText)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () { setState(() => _medicines.removeWhere((m) => m['name'] == name)); Navigator.pop(context); },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class _MedicineRow extends StatefulWidget {
  final Map<String, dynamic> medicine;
  final bool isWide;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onRestock;
  const _MedicineRow({required this.medicine, required this.isWide, required this.onEdit, required this.onDelete, required this.onRestock});

  @override
  State<_MedicineRow> createState() => _MedicineRowState();
}

class _MedicineRowState extends State<_MedicineRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.medicine;
    final isLow = (m['stock'] as int) <= (m['minStock'] as int);
    final stockColor = isLow ? AppColors.errorRed : AppColors.successGreen;

    if (!widget.isWide) {
      return _MobileCard(medicine: m, isLow: isLow, stockColor: stockColor, onEdit: widget.onEdit, onDelete: widget.onDelete, onRestock: widget.onRestock);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.surfaceWhite : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _hovered ? AppColors.mediumGreen : AppColors.borderColor),
        ),
        child: Row(children: [
          Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m['name'], style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkText)),
            Text('${m['id']} • ${m['manufacturer']}', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.mutedText)),
          ])),
          Expanded(flex: 2, child: Chip(
            label: Text(m['category'], style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.primaryGreen, fontWeight: FontWeight.w500)),
            backgroundColor: AppColors.lightGreen.withOpacity(0.3),
            side: BorderSide.none,
            padding: EdgeInsets.zero,
          )),
          Expanded(flex: 2, child: Row(children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: stockColor)),
            const SizedBox(width: 6),
            Text('${m['stock']} ${m['unit']}', style: GoogleFonts.dmSans(fontSize: 13, color: stockColor, fontWeight: FontWeight.w600)),
            if (isLow) ...[const SizedBox(width: 4), const Icon(Icons.warning_rounded, size: 13, color: AppColors.errorRed)],
          ])),
          Expanded(flex: 2, child: Text(m['expiry'], style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.mutedText))),
          Expanded(flex: 1, child: Text('₹${m['price'].toStringAsFixed(2)}', style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.darkText, fontWeight: FontWeight.w500))),
          Expanded(flex: 2, child: Row(children: [
            _SmallBtn(icon: Icons.add_box_outlined, label: 'Restock', onTap: widget.onRestock),
            const SizedBox(width: 6),
            IconButton(icon: const Icon(Icons.edit_outlined, size: 15, color: AppColors.mutedText), onPressed: widget.onEdit, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 26, minHeight: 26)),
            IconButton(icon: const Icon(Icons.delete_outline_rounded, size: 15, color: AppColors.mutedText), onPressed: widget.onDelete, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 26, minHeight: 26)),
          ])),
        ]),
      ),
    );
  }
}

class _MobileCard extends StatelessWidget {
  final Map<String, dynamic> medicine;
  final bool isLow;
  final Color stockColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onRestock;
  const _MobileCard({required this.medicine, required this.isLow, required this.stockColor, required this.onEdit, required this.onDelete, required this.onRestock});

  @override
  Widget build(BuildContext context) {
    final m = medicine;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderColor)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(m['name'], style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600))),
          if (isLow) const Icon(Icons.warning_rounded, color: AppColors.errorRed, size: 16),
        ]),
        const SizedBox(height: 4),
        Text('${m['category']} • ${m['manufacturer']}', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mutedText)),
        const SizedBox(height: 8),
        Row(children: [
          Text('Stock: ', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mutedText)),
          Text('${m['stock']} ${m['unit']}', style: GoogleFonts.dmSans(fontSize: 12, color: stockColor, fontWeight: FontWeight.w600)),
          const SizedBox(width: 16),
          Text('Exp: ${m['expiry']}', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mutedText)),
          const SizedBox(width: 16),
          Text('₹${m['price'].toStringAsFixed(2)}', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _SmallBtn(icon: Icons.add_box_outlined, label: 'Restock', onTap: onRestock),
          const SizedBox(width: 8),
          _SmallBtn(icon: Icons.edit_outlined, label: 'Edit', onTap: onEdit),
          const Spacer(),
          IconButton(icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.mutedText), onPressed: onDelete, padding: EdgeInsets.zero),
        ]),
      ]),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SmallBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: AppColors.surfaceWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderColor)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 13, color: AppColors.primaryGreen),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.primaryGreen, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}

class _ColHeader extends StatelessWidget {
  final String label;
  final int flex;
  const _ColHeader({required this.label, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(label, style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
    );
  }
}

class _LowStockChip extends StatelessWidget {
  final int count;
  const _LowStockChip({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.errorRed),
        const SizedBox(width: 6),
        Text('$count Low Stock', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.errorRed)),
      ]),
    );
  }
}
