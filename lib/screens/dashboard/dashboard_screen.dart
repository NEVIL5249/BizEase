import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sales_provider.dart';
import '../../providers/purchase_provider.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/sales_chart.dart';
import '../../models/dashboard_stats.dart';
import '../../utils/constants.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final salesProvider = context.watch<SalesProvider>();
    final purchaseProvider = context.watch<PurchaseProvider>();

    // Calculate statistics
    final stats = _calculateStats(salesProvider, purchaseProvider);

    // Get chart data (combine sales and purchase data)
    final chartData = _getCombinedChartData(salesProvider, purchaseProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _WelcomeSection(),

          const SizedBox(height: 24),

          // Statistics Cards
          _StatisticsGrid(stats: stats),

          const SizedBox(height: 24),

          // Sales Chart
          SizedBox(
            height: 400,
            child: SalesChart(data: chartData),
          ),

          const SizedBox(height: 24),

          // Quick Stats Row
          Row(
            children: [
              Expanded(
                child: _QuickStatCard(
                  title: 'Total Bills',
                  value: '${stats.salesCount + stats.purchaseCount}',
                  subtitle:
                      '${stats.salesCount} Sales, ${stats.purchaseCount} Purchase',
                  icon: Icons.receipt_long_rounded,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _QuickStatCard(
                  title: 'Profit',
                  value: formatCurrency(stats.profit),
                  subtitle:
                      stats.profitPercentage.toStringAsFixed(1) + '% margin',
                  icon: Icons.trending_up_rounded,
                  color: stats.profit >= 0 ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _QuickStatCard(
                  title: 'Avg Sale Value',
                  value: formatCurrency(stats.averageSaleValue),
                  subtitle: 'Per invoice',
                  icon: Icons.calculate_rounded,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  DashboardStats _calculateStats(
      SalesProvider salesProvider, PurchaseProvider purchaseProvider) {
    // Calculate for last 30 days
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    final totalSales = salesProvider.getTotalSales(
      startDate: thirtyDaysAgo,
      endDate: now,
    );

    final totalPurchases = purchaseProvider.getTotalPurchases(
      startDate: thirtyDaysAgo,
      endDate: now,
    );

    final totalGst = salesProvider.getTotalGst(
      startDate: thirtyDaysAgo,
      endDate: now,
    );

    final salesBills = salesProvider.getBillsByDateRange(thirtyDaysAgo, now);
    final purchaseBills =
        purchaseProvider.getBillsByDateRange(thirtyDaysAgo, now);

    return DashboardStats(
      totalSales: totalSales,
      totalPurchases: totalPurchases,
      outstandingAmount: totalSales * 0.15, // Mock 15% outstanding
      totalGstCollected: totalGst,
      salesCount: salesBills.length,
      purchaseCount: purchaseBills.length,
    );
  }

  List<ChartData> _getCombinedChartData(
      SalesProvider salesProvider, PurchaseProvider purchaseProvider) {
    final salesData = salesProvider.getChartData();
    final purchaseData = purchaseProvider.getChartData();

    // Combine both datasets
    List<ChartData> combined = [];
    for (int i = 0; i < salesData.length; i++) {
      combined.add(ChartData(
        label: salesData[i].label,
        sales: salesData[i].sales,
        purchases: i < purchaseData.length ? purchaseData[i].purchases : 0,
      ));
    }

    return combined;
  }
}

class _WelcomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting = 'Good Morning';
    if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
    } else if (hour >= 17) {
      greeting = 'Good Evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Here\'s what\'s happening in your business today',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }
}

class _StatisticsGrid extends StatelessWidget {
  final DashboardStats stats;

  const _StatisticsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SalesStatCard(
            value: formatCurrency(stats.totalSales),
            subtitle: 'Last 30 days',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: PurchaseStatCard(
            value: formatCurrency(stats.totalPurchases),
            subtitle: 'Last 30 days',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutstandingStatCard(
            value: formatCurrency(stats.outstandingAmount),
            subtitle:
                '${(stats.outstandingAmount / stats.totalSales * 100).toStringAsFixed(0)}% of sales',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GSTStatCard(
            value: formatCurrency(stats.totalGstCollected),
            subtitle: 'GST collected',
          ),
        ),
      ],
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _QuickStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
