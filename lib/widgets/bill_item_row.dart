import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/bill_item.dart';
import '../models/inventory_item.dart';
import '../providers/inventory_provider.dart';
import '../utils/constants.dart';

/// -------------------- Editable Row Widget --------------------
class BillItemRow extends StatelessWidget {
  final BillItem item;
  final Function(BillItem) onChanged;
  final VoidCallback onDelete;
  final bool showMRP; // For purchase bills

  const BillItemRow({
    super.key,
    required this.item,
    required this.onChanged,
    required this.onDelete,
    this.showMRP = false,
  });

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = context.watch<InventoryProvider>();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Product Name with Autocomplete
                Expanded(
                  flex: 3,
                  child: Autocomplete<String>(
                    initialValue: TextEditingValue(text: item.productName),
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      final filteredItems = inventoryProvider.inventory
                          .where((invItem) => invItem.productName
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()))
                          .map((e) => e.productName);
                      if (filteredItems.isEmpty && textEditingValue.text.isNotEmpty) {
                        return ['No items found'];
                      }
                      return filteredItems;
                    },
                    onSelected: (selected) {
                      final invItem = inventoryProvider.getItemByName(selected);
                      if (invItem != null) {
                        onChanged(item.copyWith(
                          productName: invItem.productName,
                          rate: invItem.rate,
                          gstPercent: invItem.gstPercent,
                          hsnCode: invItem.hsnCode,
                          mrp: invItem.mrp,
                          size: invItem.size,
                        ));
                      }
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => onChanged(item.copyWith(productName: value)),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // HSN Code
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    label: 'HSN Code',
                    value: item.hsnCode,
                    onChanged: (value) => onChanged(item.copyWith(hsnCode: value)),
                  ),
                ),
                const SizedBox(width: 12),

                // Quantity
                Expanded(
                  flex: 1,
                  child: _buildNumberField(
                    label: 'Qty',
                    value: item.quantity,
                    onChanged: (value) => onChanged(item.copyWith(quantity: value)),
                  ),
                ),
                const SizedBox(width: 12),

                // Rate
                Expanded(
                  flex: 2,
                  child: _buildNumberField(
                    label: 'Rate',
                    value: item.rate,
                    onChanged: (value) => onChanged(item.copyWith(rate: value)),
                  ),
                ),
                const SizedBox(width: 12),

                // GST %
                Expanded(
                  flex: 1,
                  child: _buildGSTDropdown(
                    value: item.gstPercent,
                    onChanged: (value) => onChanged(item.copyWith(gstPercent: value)),
                  ),
                ),
                const SizedBox(width: 12),

                // Total
                Expanded(
                  flex: 2,
                  child: _buildReadOnlyField(
                    label: 'Total',
                    value: formatCurrency(item.total),
                  ),
                ),
                const SizedBox(width: 12),

                // Delete button
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: Colors.red,
                  tooltip: 'Delete Item',
                ),
              ],
            ),

            // Additional fields for purchase bills
            if (showMRP) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Size/Unit',
                      value: item.size ?? '',
                      onChanged: (value) => onChanged(item.copyWith(size: value)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNumberField(
                      label: 'MRP',
                      value: item.mrp ?? 0,
                      onChanged: (value) => onChanged(item.copyWith(mrp: value)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildReadOnlyField(
                      label: 'Total Rate (with GST)',
                      value: formatCurrency(item.totalRate),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // -------------------- Helpers --------------------
  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildNumberField({
    required String label,
    required double value,
    required Function(double) onChanged,
  }) {
    return TextFormField(
      initialValue: value == 0 ? '' : value.toString(),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      onChanged: (val) {
        final parsed = double.tryParse(val);
        if (parsed != null) {
          onChanged(parsed);
        }
      },
    );
  }

  Widget _buildGSTDropdown({
    required double value,
    required Function(double) onChanged,
  }) {
    return DropdownButtonFormField<double>(
      value: value,
      decoration: const InputDecoration(
        labelText: 'GST %',
        border: OutlineInputBorder(),
      ),
      items: gstRates.map((rate) {
        return DropdownMenuItem(
          value: rate,
          child: Text('${rate.toInt()}%'),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) {
          onChanged(val);
        }
      },
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
      ),
      readOnly: true,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }
}

/// -------------------- Compact ListTile Widget --------------------
class BillItemListTile extends StatelessWidget {
  final BillItem item;

  const BillItemListTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        item.productName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        'Qty: ${item.quantity} × ${formatCurrency(item.rate)} + ${item.gstPercent}% GST',
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
      trailing: Text(
        formatCurrency(item.total),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}
