import '../models/bill_item.dart';
import '../models/sales_bill.dart';
import '../models/purchase_bill.dart';

class CalculationService {
  // Calculate GST amount from base amount and GST rate
  static double calculateGST(double baseAmount, double gstRate) {
    return (baseAmount * gstRate) / 100;
  }

  // Calculate total amount including GST
  static double calculateTotalWithGST(double baseAmount, double gstRate) {
    return baseAmount + calculateGST(baseAmount, gstRate);
  }

  // Calculate base amount from total (reverse GST)
  static double calculateBaseFromTotal(double totalAmount, double gstRate) {
    return totalAmount / (1 + (gstRate / 100));
  }

  // Calculate item total
  static double calculateItemTotal(BillItem item) {
    return item.total;
  }

  // Calculate bill subtotal (sum of all items)
  static double calculateBillSubtotal(List<BillItem> items) {
    return items.fold(0, (sum, item) => sum + item.subtotal);
  }

  // Calculate bill total GST
  static double calculateBillTotalGST(List<BillItem> items) {
    return items.fold(0, (sum, item) => sum + item.gstAmount);
  }

  // Calculate bill grand total
  static double calculateBillGrandTotal(List<BillItem> items) {
    return calculateBillSubtotal(items) + calculateBillTotalGST(items);
  }

  // Calculate GST breakdown by rate
  static Map<double, double> calculateGSTBreakdown(List<BillItem> items) {
    Map<double, double> breakdown = {};

    for (var item in items) {
      if (breakdown.containsKey(item.gstPercent)) {
        breakdown[item.gstPercent] =
            breakdown[item.gstPercent]! + item.gstAmount;
      } else {
        breakdown[item.gstPercent] = item.gstAmount;
      }
    }

    return breakdown;
  }

  // Calculate profit from sales and purchases
  static double calculateProfit(double totalSales, double totalPurchases) {
    return totalSales - totalPurchases;
  }

  // Calculate profit margin percentage
  static double calculateProfitMargin(double profit, double totalPurchases) {
    if (totalPurchases == 0) return 0;
    return (profit / totalPurchases) * 100;
  }

  // Calculate average bill value
  static double calculateAverageBillValue(double totalAmount, int billCount) {
    if (billCount == 0) return 0;
    return totalAmount / billCount;
  }

  // Calculate discount amount
  static double calculateDiscountAmount(
      double originalAmount, double discountPercent) {
    return (originalAmount * discountPercent) / 100;
  }

  // Calculate final amount after discount
  static double calculateAmountAfterDiscount(
      double originalAmount, double discountPercent) {
    return originalAmount -
        calculateDiscountAmount(originalAmount, discountPercent);
  }

  // Calculate percentage
  static double calculatePercentage(double part, double whole) {
    if (whole == 0) return 0;
    return (part / whole) * 100;
  }

  // Calculate compound GST (CGST + SGST)
  static Map<String, double> calculateCompoundGST(
      double gstRate, double baseAmount) {
    double halfRate = gstRate / 2;
    double cgst = calculateGST(baseAmount, halfRate);
    double sgst = calculateGST(baseAmount, halfRate);

    return {
      'cgst': cgst,
      'sgst': sgst,
      'total': cgst + sgst,
    };
  }

  // Calculate IGST (Inter-state GST)
  static double calculateIGST(double baseAmount, double gstRate) {
    return calculateGST(baseAmount, gstRate);
  }

  // Validate GST number format
  static bool isValidGSTIN(String gstin) {
    if (gstin.length != 15) return false;

    // Basic GSTIN format: 2 digits + 10 alphanumeric + 1 digit + 1 alphabet + 1 digit
    RegExp gstinRegex =
        RegExp(r'^\d{2}[A-Z]{5}\d{4}[A-Z]{1}\d{1}[A-Z]{1}\d{1}$');
    return gstinRegex.hasMatch(gstin);
  }

  // Calculate tax liability
  static Map<String, double> calculateTaxLiability(
    List<SalesBill> salesBills,
    List<PurchaseBill> purchaseBills,
  ) {
    double salesGST = salesBills.fold(0, (sum, bill) => sum + bill.totalGst);
    double purchaseGST =
        purchaseBills.fold(0, (sum, bill) => sum + bill.totalGst);
    double netTaxLiability = salesGST - purchaseGST;

    return {
      'outputGST': salesGST, // GST collected from customers
      'inputGST': purchaseGST, // GST paid to suppliers
      'netLiability': netTaxLiability, // Net GST to be paid to government
    };
  }

  // Calculate return on investment (ROI)
  static double calculateROI(double profit, double investment) {
    if (investment == 0) return 0;
    return (profit / investment) * 100;
  }

  // Calculate break-even point
  static double calculateBreakEvenPoint(
      double fixedCosts, double pricePerUnit, double variableCostPerUnit) {
    double contribution = pricePerUnit - variableCostPerUnit;
    if (contribution == 0) return 0;
    return fixedCosts / contribution;
  }

  // Calculate inventory value
  static double calculateInventoryValue(List<BillItem> items) {
    return items.fold(
        0, (sum, item) => sum + (item.quantity * (item.mrp ?? item.rate)));
  }

  // Round to 2 decimal places
  static double roundToTwoDecimals(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  // Convert amount to words (for invoice printing)
  static String amountToWords(double amount) {
    if (amount == 0) return 'Zero Rupees';

    List<String> ones = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine'
    ];
    List<String> teens = [
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen'
    ];
    List<String> tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety'
    ];

    int rupees = amount.floor();
    int paise = ((amount - rupees) * 100).round();

    String result = _convertNumberToWords(rupees, ones, teens, tens);
    result += ' Rupees';

    if (paise > 0) {
      result += ' and ${_convertNumberToWords(paise, ones, teens, tens)} Paise';
    }

    return result;
  }

  static String _convertNumberToWords(
      int number, List<String> ones, List<String> teens, List<String> tens) {
    if (number == 0) return '';
    if (number < 10) return ones[number];
    if (number < 20) return teens[number - 10];
    if (number < 100) {
      return '${tens[number ~/ 10]} ${ones[number % 10]}'.trim();
    }
    if (number < 1000) {
      return '${ones[number ~/ 100]} Hundred ${_convertNumberToWords(number % 100, ones, teens, tens)}'
          .trim();
    }
    if (number < 100000) {
      return '${_convertNumberToWords(number ~/ 1000, ones, teens, tens)} Thousand ${_convertNumberToWords(number % 1000, ones, teens, tens)}'
          .trim();
    }
    if (number < 10000000) {
      return '${_convertNumberToWords(number ~/ 100000, ones, teens, tens)} Lakh ${_convertNumberToWords(number % 100000, ones, teens, tens)}'
          .trim();
    }
    return '${_convertNumberToWords(number ~/ 10000000, ones, teens, tens)} Crore ${_convertNumberToWords(number % 10000000, ones, teens, tens)}'
        .trim();
  }

  // Calculate expected revenue
  static double calculateExpectedRevenue(
      List<SalesBill> bills, DateTime startDate, DateTime endDate) {
    return bills
        .where((bill) =>
            bill.billDate
                .isAfter(startDate.subtract(const Duration(days: 1))) &&
            bill.billDate.isBefore(endDate.add(const Duration(days: 1))))
        .fold(0, (sum, bill) => sum + bill.grandTotal);
  }

  // Calculate growth rate
  static double calculateGrowthRate(double currentValue, double previousValue) {
    if (previousValue == 0) return 0;
    return ((currentValue - previousValue) / previousValue) * 100;
  }

  // Calculate moving average
  static double calculateMovingAverage(List<double> values, int period) {
    if (values.isEmpty || period <= 0) return 0;

    int count = values.length < period ? values.length : period;
    List<double> recentValues = values.sublist(values.length - count);

    double sum = recentValues.fold(0, (a, b) => a + b);
    return sum / count;
  }

  // Calculate variance
  static double calculateVariance(List<double> values) {
    if (values.isEmpty) return 0;

// In calculateVariance function
    double mean = values.fold(0.0, (a, b) => a + b) / values.length;
    double sumSquaredDiff =
        values.fold(0, (sum, value) => sum + ((value - mean) * (value - mean)));

    return sumSquaredDiff / values.length;
  }

  // Calculate standard deviation
  static double calculateStandardDeviation(List<double> values) {
    return calculateVariance(values) == 0 ? 0 : calculateVariance(values);
  }
}
