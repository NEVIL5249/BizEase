import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/purchase_bill.dart';
import '../../models/bill_item.dart';
import '../../providers/purchase_provider.dart';
import '../../models/inventory_item.dart';
import '../../providers/inventory_provider.dart';
import '../../widgets/bill_item_row.dart';
import '../../widgets/custom_button.dart';
import '../../utils/constants.dart';

class CreatePurchaseBill extends StatefulWidget {
  const CreatePurchaseBill({super.key});

  @override
  State<CreatePurchaseBill> createState() => _CreatePurchaseBillState();
}

class _CreatePurchaseBillState extends State<CreatePurchaseBill> {
  final _formKey = GlobalKey<FormState>();
  final _supplierNameController = TextEditingController();
  final _billNumberController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<BillItem> _items = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addNewItem();
  }

  void _addNewItem() {
    setState(() {
      _items.add(BillItem(
        productName: '',
        quantity: 1,
        rate: 0,
        gstPercent: 18,
        hsnCode: '',
        size: '',
        mrp: 0,
      ));
    });
  }

  void _removeItem(int index) {
    if (_items.length > 1) {
      setState(() {
        _items.removeAt(index);
      });
    }
  }

  void _updateItem(int index, BillItem updatedItem) {
    setState(() {
      _items[index] = updatedItem;
    });
  }

  double get _subtotal {
    return _items.fold(0, (sum, item) => sum + item.subtotal);
  }

  double get _totalGst {
    return _items.fold(0, (sum, item) => sum + item.gstAmount);
  }

  double get _grandTotal {
    return _subtotal + _totalGst;
  }

  Future<void> _saveBill() async {
    if (!_formKey.currentState!.validate()) return;

    if (_supplierNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter supplier name')),
      );
      return;
    }

    if (_items.any((item) => item.productName.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all product names')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final bill = PurchaseBill(
      id: PurchaseBill.generatePurchaseNumber(),
      supplierName: _supplierNameController.text,
      billDate: _selectedDate,
      items: _items,
      billNumber: _billNumberController.text.isEmpty
          ? null
          : _billNumberController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    final inventoryProvider = context.read<InventoryProvider>();
    await context.read<PurchaseProvider>().addBill(bill);

for (final item in bill.items) {
  inventoryProvider.addOrUpdateItem(
    InventoryItem(
      productName: item.productName,
      quantity: item.quantity.toInt(),          // convert double -> int
      rate: item.rate,
      gstPercent: item.gstPercent,      // convert double -> int
      hsnCode: item.hsnCode,
      size: item.size ?? '',                     // if InventoryItem.size is non-nullable
      mrp: item.mrp ?? 0,                        // if InventoryItem.mrp is non-nullable
    ),
  );
}


    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Purchase bill ${bill.id} created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      _resetForm();
    }
  }

  void _resetForm() {
    _supplierNameController.clear();
    _billNumberController.clear();
    _notesController.clear();
    setState(() {
      _selectedDate = DateTime.now();
      _items = [
        BillItem(
          productName: '',
          quantity: 1,
          rate: 0,
          gstPercent: 18,
          hsnCode: '',
          size: '',
          mrp: 0,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Purchase Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _supplierNameController,
                            decoration: const InputDecoration(
                              labelText: 'Supplier Name *',
                              prefixIcon: Icon(Icons.store_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _billNumberController,
                            decoration: const InputDecoration(
                              labelText: 'Bill Number',
                              prefixIcon: Icon(Icons.numbers),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (date != null) {
                                setState(() => _selectedDate = date);
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Bill Date',
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              child: Text(formatDate(_selectedDate)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomButton(
                  text: 'Add Item',
                  onPressed: _addNewItem,
                  icon: Icons.add,
                  isOutlined: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return BillItemRow(
                  item: _items[index],
                  onChanged: (updatedItem) => _updateItem(index, updatedItem),
                  onDelete: () => _removeItem(index),
                  showMRP: true,
                );
              },
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bill Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SummaryRow(
                            label: 'Subtotal',
                            value: formatCurrency(_subtotal),
                          ),
                          const SizedBox(height: 8),
                          _SummaryRow(
                            label: 'GST',
                            value: formatCurrency(_totalGst),
                          ),
                          const Divider(height: 24),
                          _SummaryRow(
                            label: 'Grand Total',
                            value: formatCurrency(_grandTotal),
                            isBold: true,
                            isLarge: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    CustomButton(
                      text: 'Save Bill',
                      onPressed: _saveBill,
                      icon: Icons.save,
                      isLoading: _isLoading,
                      width: 200,
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      text: 'Reset',
                      onPressed: _resetForm,
                      icon: Icons.refresh,
                      isOutlined: true,
                      width: 200,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _supplierNameController.dispose();
    _billNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isLarge;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? 18 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isLarge ? 20 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? Theme.of(context).colorScheme.primary : null,
          ),
        ),
      ],
    );
  }
}
