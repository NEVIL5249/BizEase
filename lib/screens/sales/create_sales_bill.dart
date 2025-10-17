import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/sales_bill.dart';
import '../../models/bill_item.dart';
import '../../providers/sales_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../models/inventory_item.dart';
import '../../widgets/bill_item_row.dart';
import '../../widgets/custom_button.dart';
import '../../utils/constants.dart';

class CreateSalesBill extends StatefulWidget {
  const CreateSalesBill({super.key});

  @override
  State<CreateSalesBill> createState() => _CreateSalesBillState();
}

class _CreateSalesBillState extends State<CreateSalesBill> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
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

    if (_customerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter customer name')),
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

    final inventoryProvider = context.read<InventoryProvider>();

    // Stock validation
    for (final item in _items) {
      final stockItem = inventoryProvider.getItemByName(item.productName);
      if (stockItem == null || stockItem.quantity < item.quantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Insufficient stock for ${item.productName}')),
        );
        setState(() => _isLoading = false);
        return;
      }
    }

    final bill = SalesBill(
      id: SalesBill.generateInvoiceNumber(),
      customerName: _customerNameController.text,
      billDate: _selectedDate,
      items: _items,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    await context.read<SalesProvider>().addBill(bill);

    // Deduct sold items from inventory
    // for (final item in bill.items) {
    //   inventoryProvider.deductItem(
    //     InventoryItem(
    //       productName: item.productName,
    //       quantity: item.quantity.toInt(),
    //       rate: item.rate,
    //       gstPercent: item.gstPercent,
    //       hsnCode: item.hsnCode,
    //       size: item.size ?? '',
    //       mrp: item.mrp ?? 0,
    //     ),
    //   );
    // }

    for (final item in bill.items) {
  inventoryProvider.deductItem(
    item.productName,
    item.quantity.toInt(),  // quantity as int
  );
}


    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sales bill ${bill.id} created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      _resetForm();
    }
  }

  void _resetForm() {
    _customerNameController.clear();
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
            // Header Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bill Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Customer Name
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _customerNameController,
                            decoration: const InputDecoration(
                              labelText: 'Customer Name *',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Bill Date
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

            // Items Section
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

            // Items List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return BillItemRow(
                  item: _items[index],
                  onChanged: (updatedItem) => _updateItem(index, updatedItem),
                  onDelete: () => _removeItem(index),
                );
              },
            ),

            const SizedBox(height: 24),

            // Notes
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

            // Summary and Actions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Card
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

                // Action Buttons
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
    _customerNameController.dispose();
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
