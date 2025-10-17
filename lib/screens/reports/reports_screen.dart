import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sales_provider.dart';
import '../../providers/purchase_provider.dart';
import '../../widgets/custom_button.dart';
import '../../utils/constants.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final salesProvider = context.watch<SalesProvider>();
    final purchaseProvider = context.watch<PurchaseProvider>();

    // Calculate statistics
    final totalSales = salesProvider.getTotalSales(
      startDate: _startDate,
      endDate: _endDate,
    );

    final totalPurchases = purchaseProvider.getTotalPurchases(
      startDate: _startDate,
      endDate: _endDate,
    );

    final totalGst = salesProvider.getTotalGst(
          startDate: _startDate,
          endDate: _endDate,
        ) +
        purchaseProvider.getTotalGst(
          startDate: _startDate,
          endDate: _endDate,
        );

    final salesCount =
        salesProvider.getBillsByDateRange(_startDate, _endDate).length;
    final purchaseCount =
        purchaseProvider.getBillsByDateRange(_startDate, _endDate).length;

    final profit = totalSales - totalPurchases;
    final profitMargin =
        totalPurchases > 0 ? (profit / totalPurchases * 100) : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Range Selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.date_range, size: 28),
                  const SizedBox(width: 16),
                  const Text(
                    'Report Period:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '${formatDate(_startDate)} - ${formatDate(_endDate)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CustomButton(
                    text: 'Change Period',
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        initialDateRange: DateTimeRange(
                          start: _startDate,
                          end: _endDate,
                        ),
                      );
                      if (picked != null) {
                        setState(() {
                          _startDate = picked.start;
                          _endDate = picked.end;
                        });
                      }
                    },
                    icon: Icons.edit_calendar,
                    isOutlined: true,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'Total Sales',
                  value: formatCurrency(totalSales),
                  subtitle: '$salesCount bills',
                  color: Colors.green,
                  icon: Icons.trending_up_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  title: 'Total Purchases',
                  value: formatCurrency(totalPurchases),
                  subtitle: '$purchaseCount bills',
                  color: Colors.orange,
                  icon: Icons.shopping_cart_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  title: 'Profit',
                  value: formatCurrency(profit),
                  subtitle: '${profitMargin.toStringAsFixed(1)}% margin',
                  color: profit >= 0 ? Colors.blue : Colors.red,
                  icon: Icons.account_balance_wallet_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  title: 'Total GST',
                  value: formatCurrency(totalGst),
                  subtitle: 'Combined',
                  color: AppTheme.primaryLight,
                  icon: Icons.receipt_long_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Detailed Reports
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sales Report
              Expanded(
                child: _DetailedReport(
                  title: 'Sales Report',
                  color: Colors.green,
                  bills:
                      salesProvider.getBillsByDateRange(_startDate, _endDate),
                  isSales: true,
                ),
              ),
              const SizedBox(width: 16),

              // Purchase Report
              Expanded(
                child: _DetailedReport(
                  title: 'Purchase Report',
                  color: Colors.orange,
                  bills: purchaseProvider.getBillsByDateRange(
                      _startDate, _endDate),
                  isSales: false,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Export Buttons
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.file_download_outlined, size: 28),
                  const SizedBox(width: 16),
                  const Text(
                    'Export Reports',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    text: 'Export as PDF',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PDF export feature coming soon!'),
                        ),
                      );
                    },
                    icon: Icons.picture_as_pdf,
                    isOutlined: true,
                  ),
                  const SizedBox(width: 12),
                  CustomButton(
                    text: 'Export as Excel',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Excel export feature coming soon!'),
                        ),
                      );
                    },
                    icon: Icons.table_chart,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailedReport extends StatelessWidget {
  final String title;
  final Color color;
  final List bills;
  final bool isSales;

  const _DetailedReport({
    required this.title,
    required this.color,
    required this.bills,
    required this.isSales,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final totalAmount =
        bills.fold<double>(0, (sum, bill) => sum + bill.grandTotal);
    final totalGst = bills.fold<double>(0, (sum, bill) => sum + bill.totalGst);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    isSales
                        ? Icons.trending_up_rounded
                        : Icons.shopping_cart_rounded,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _ReportRow(
              label: 'Total Bills',
              value: bills.length.toString(),
            ),
            const Divider(height: 24),
            _ReportRow(
              label: 'Total Amount',
              value: formatCurrency(totalAmount),
              isBold: true,
            ),
            const SizedBox(height: 12),
            _ReportRow(
              label: 'Total GST',
              value: formatCurrency(totalGst),
            ),
            const SizedBox(height: 12),
            _ReportRow(
              label: 'Average per Bill',
              value: bills.isNotEmpty
                  ? formatCurrency(totalAmount / bills.length)
                  : formatCurrency(0),
            ),
            if (bills.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Recent ${isSales ? 'Customers' : 'Suppliers'}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...bills.take(5).map((bill) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            isSales ? bill.customerName : bill.supplierName,
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          formatCurrency(bill.grandTotal),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _ReportRow({
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
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            color: isBold ? null : Theme.of(context).textTheme.bodySmall?.color,
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
