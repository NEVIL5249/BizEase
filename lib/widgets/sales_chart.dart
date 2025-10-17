import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/dashboard_stats.dart';
import '../utils/constants.dart';

class SalesChart extends StatelessWidget {
  final List<ChartData> data;

  const SalesChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get max value for Y axis
    double maxY = 0;
    for (var item in data) {
      if (item.sales > maxY) maxY = item.sales;
      if (item.purchases > maxY) maxY = item.purchases;
    }
    maxY = maxY * 1.2; // Add 20% padding
    if (maxY == 0) maxY = 1000; // Default minimum

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sales vs Purchase (Last 30 Days)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  _Legend(
                    color: Colors.green,
                    label: 'Sales',
                  ),
                  const SizedBox(width: 20),
                  _Legend(
                    color: Colors.orange,
                    label: 'Purchase',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Chart
          Expanded(
            child: data.isEmpty
                ? Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  )
                : BarChart(
                    BarChartData(
                      maxY: maxY,
                      barGroups: _generateBarGroups(),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              // Show every 5th label to avoid crowding
                              if (value.toInt() % 5 != 0) {
                                return const SizedBox();
                              }
                              if (value.toInt() >= 0 &&
                                  value.toInt() < data.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    data[value.toInt()].label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '₹${(value / 1000).toStringAsFixed(0)}K',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: maxY / 5,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${rodIndex == 0 ? 'Sales' : 'Purchase'}\n',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: formatCurrency(rod.toY),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: item.sales,
            color: Colors.green,
            width: 8,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          BarChartRodData(
            toY: item.purchases,
            color: Colors.orange,
            width: 8,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
        barsSpace: 4,
      );
    }).toList();
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}
