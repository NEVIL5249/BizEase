class DashboardStats {
  double totalSales;
  double totalPurchases;
  double outstandingAmount;
  double totalGstCollected;
  int salesCount;
  int purchaseCount;

  DashboardStats({
    this.totalSales = 0,
    this.totalPurchases = 0,
    this.outstandingAmount = 0,
    this.totalGstCollected = 0,
    this.salesCount = 0,
    this.purchaseCount = 0,
  });

  // Calculate profit margin
  double get profit {
    return totalSales - totalPurchases;
  }

  // Calculate profit percentage
  double get profitPercentage {
    if (totalPurchases == 0) return 0;
    return (profit / totalPurchases) * 100;
  }

  // Average sale value
  double get averageSaleValue {
    if (salesCount == 0) return 0;
    return totalSales / salesCount;
  }

  // Average purchase value
  double get averagePurchaseValue {
    if (purchaseCount == 0) return 0;
    return totalPurchases / purchaseCount;
  }
}

// Chart Data Model
class ChartData {
  String label;
  double sales;
  double purchases;

  ChartData({
    required this.label,
    required this.sales,
    required this.purchases,
  });
}

// Monthly stats for reports
class MonthlyStats {
  int month;
  int year;
  double sales;
  double purchases;
  double gst;
  int salesCount;
  int purchaseCount;

  MonthlyStats({
    required this.month,
    required this.year,
    this.sales = 0,
    this.purchases = 0,
    this.gst = 0,
    this.salesCount = 0,
    this.purchaseCount = 0,
  });

  String get monthName {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  String get period {
    return '$monthName $year';
  }
}
