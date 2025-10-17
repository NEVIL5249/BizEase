import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sales_provider.dart';
import '../../providers/settings_provider.dart';
import '../../models/sales_bill.dart';
import '../../widgets/bill_item_row.dart';
import '../../utils/constants.dart';
import '../../utils/pdf_generator.dart';

class SalesHistory extends StatefulWidget {
  const SalesHistory({super.key});

  @override
  State<SalesHistory> createState() => _SalesHistoryState();
}

class _SalesHistoryState extends State<SalesHistory> {
  final _searchController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final salesProvider = context.watch<SalesProvider>();

    List<SalesBill> bills = salesProvider.bills;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      bills = salesProvider.searchBills(_searchQuery);
    }

    // Apply date filter
    if (_startDate != null && _endDate != null) {
      bills = salesProvider.getBillsByDateRange(_startDate!, _endDate!);
    }

    return Column(
      children: [
        // Filters
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Search
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search by customer or invoice',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Date Filter
                  OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        initialDateRange: _startDate != null && _endDate != null
                            ? DateTimeRange(start: _startDate!, end: _endDate!)
                            : null,
                      );
                      if (picked != null) {
                        setState(() {
                          _startDate = picked.start;
                          _endDate = picked.end;
                        });
                      }
                    },
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      _startDate != null && _endDate != null
                          ? '${formatDate(_startDate!)} - ${formatDate(_endDate!)}'
                          : 'Filter by Date',
                    ),
                  ),

                  if (_startDate != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _startDate = null;
                          _endDate = null;
                        });
                      },
                      icon: const Icon(Icons.clear),
                      tooltip: 'Clear Date Filter',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Bills List
        Expanded(
          child: bills.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No sales bills found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: bills.length,
                  itemBuilder: (context, index) {
                    return _BillCard(bill: bills[index]);
                  },
                ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _BillCard extends StatelessWidget {
  final SalesBill bill;

  const _BillCard({required this.bill});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(
            Icons.receipt_long_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          bill.customerName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${bill.id} • ${formatDate(bill.billDate)}',
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatCurrency(bill.grandTotal),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '${bill.items.length} items',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
        children: [
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Items
                const Text(
                  'Items:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ...bill.items.map((item) => BillItemListTile(item: item)),

                const SizedBox(height: 16),

                // Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(
                        label: 'Subtotal',
                        value: formatCurrency(bill.subtotal),
                      ),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: 'GST',
                        value: formatCurrency(bill.totalGst),
                      ),
                      const Divider(height: 16),
                      _SummaryRow(
                        label: 'Grand Total',
                        value: formatCurrency(bill.grandTotal),
                        isBold: true,
                      ),
                    ],
                  ),
                ),

                if (bill.notes != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Notes: ${bill.notes}',
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        final settings = context.read<SettingsProvider>().settings;
                        await PDFGenerator.generateSalesBillPDF(bill, settings);
                      },
                      icon: const Icon(Icons.print),
                      label: const Text('Print'),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {
                        _showDeleteConfirmation(context, bill);
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, SalesBill bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bill'),
        content: Text('Are you sure you want to delete bill ${bill.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SalesProvider>().deleteBill(bill.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bill deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
