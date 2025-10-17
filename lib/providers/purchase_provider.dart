import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/purchase_bill.dart';
import '../models/dashboard_stats.dart';
import '../utils/constants.dart';

class PurchaseProvider extends ChangeNotifier {
  List<PurchaseBill> _bills = [];

  List<PurchaseBill> get bills => _bills;
  int get billsCount => _bills.length;

  PurchaseProvider() {
    _loadBills();
  }

  // Load bills from storage
  Future<void> _loadBills() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final billsJson = prefs.getString(AppConstants.keyPurchaseBills);

      if (billsJson != null) {
        final List<dynamic> decoded = json.decode(billsJson);
        _bills = decoded.map((json) => PurchaseBill.fromJson(json)).toList();
        // Sort by date (newest first)
        _bills.sort((a, b) => b.billDate.compareTo(a.billDate));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading purchase bills: $e');
    }
  }

  // Save bills to storage
  Future<void> _saveBills() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final billsJson =
          json.encode(_bills.map((bill) => bill.toJson()).toList());
      await prefs.setString(AppConstants.keyPurchaseBills, billsJson);
    } catch (e) {
      debugPrint('Error saving purchase bills: $e');
    }
  }

  // Add new bill
  Future<void> addBill(PurchaseBill bill) async {
    _bills.insert(0, bill); // Add at beginning (newest first)
    notifyListeners();
    await _saveBills();
  }

  // Update existing bill
  Future<void> updateBill(String id, PurchaseBill updatedBill) async {
    final index = _bills.indexWhere((bill) => bill.id == id);
    if (index != -1) {
      _bills[index] = updatedBill;
      notifyListeners();
      await _saveBills();
    }
  }

  // Delete bill
  Future<void> deleteBill(String id) async {
    _bills.removeWhere((bill) => bill.id == id);
    notifyListeners();
    await _saveBills();
  }

  // Get bill by ID
  PurchaseBill? getBillById(String id) {
    try {
      return _bills.firstWhere((bill) => bill.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get bills by date range
  List<PurchaseBill> getBillsByDateRange(DateTime startDate, DateTime endDate) {
    return _bills.where((bill) {
      return bill.billDate
              .isAfter(startDate.subtract(const Duration(days: 1))) &&
          bill.billDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  // Get bills by supplier
  List<PurchaseBill> getBillsBySupplier(String supplierName) {
    return _bills
        .where((bill) => bill.supplierName
            .toLowerCase()
            .contains(supplierName.toLowerCase()))
        .toList();
  }

  // Calculate total purchases
  double getTotalPurchases({DateTime? startDate, DateTime? endDate}) {
    var billsToCalculate = _bills;

    if (startDate != null && endDate != null) {
      billsToCalculate = getBillsByDateRange(startDate, endDate);
    }

    return billsToCalculate.fold(0, (sum, bill) => sum + bill.grandTotal);
  }

  // Calculate total GST paid
  double getTotalGst({DateTime? startDate, DateTime? endDate}) {
    var billsToCalculate = _bills;

    if (startDate != null && endDate != null) {
      billsToCalculate = getBillsByDateRange(startDate, endDate);
    }

    return billsToCalculate.fold(0, (sum, bill) => sum + bill.totalGst);
  }

  // Get top suppliers
  Map<String, double> getTopSuppliers({int limit = 5}) {
    Map<String, double> supplierTotals = {};

    for (var bill in _bills) {
      supplierTotals[bill.supplierName] =
          (supplierTotals[bill.supplierName] ?? 0) + bill.grandTotal;
    }

    var sorted = supplierTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sorted.take(limit));
  }

  // Get chart data for last 30 days
  List<ChartData> getChartData() {
    List<ChartData> chartData = [];
    DateTime now = DateTime.now();

    for (int i = 29; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));
      double dailyPurchases = _bills
          .where((bill) =>
              bill.billDate.year == date.year &&
              bill.billDate.month == date.month &&
              bill.billDate.day == date.day)
          .fold(0, (sum, bill) => sum + bill.grandTotal);

      chartData.add(ChartData(
        label: '${date.day}/${date.month}',
        sales: 0, // Will be filled by combining with sales data
        purchases: dailyPurchases,
      ));
    }

    return chartData;
  }

  // Get monthly stats
  List<MonthlyStats> getMonthlyStats(int year) {
    List<MonthlyStats> stats = [];

    for (int month = 1; month <= 12; month++) {
      var monthBills = _bills
          .where((bill) =>
              bill.billDate.year == year && bill.billDate.month == month)
          .toList();

      double purchases =
          monthBills.fold(0, (sum, bill) => sum + bill.grandTotal);
      double gst = monthBills.fold(0, (sum, bill) => sum + bill.totalGst);

      stats.add(MonthlyStats(
        month: month,
        year: year,
        purchases: purchases,
        gst: gst,
        purchaseCount: monthBills.length,
      ));
    }

    return stats;
  }

  // Search bills
  List<PurchaseBill> searchBills(String query) {
    if (query.isEmpty) return _bills;

    return _bills
        .where((bill) =>
            bill.supplierName.toLowerCase().contains(query.toLowerCase()) ||
            bill.id.toLowerCase().contains(query.toLowerCase()) ||
            (bill.billNumber?.toLowerCase().contains(query.toLowerCase()) ??
                false))
        .toList();
  }

  // Get total items purchased
  int getTotalItemsPurchased() {
    return _bills.fold(0, (sum, bill) => sum + bill.totalItems);
  }

  // Get total quantity purchased
  double getTotalQuantityPurchased() {
    return _bills.fold(0, (sum, bill) => sum + bill.totalQuantity);
  }
}
