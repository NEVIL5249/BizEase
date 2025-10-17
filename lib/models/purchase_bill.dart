import 'bill_item.dart';

class PurchaseBill {
  String id;
  String supplierName;
  DateTime billDate;
  List<BillItem> items;
  String? billNumber; // Supplier's bill number
  String? notes;

  PurchaseBill({
    required this.id,
    required this.supplierName,
    required this.billDate,
    required this.items,
    this.billNumber,
    this.notes,
  });

  // Calculate subtotal (sum of all items subtotal)
  double get subtotal {
    return items.fold(0, (sum, item) => sum + item.subtotal);
  }

  // Calculate total GST amount
  double get totalGst {
    return items.fold(0, (sum, item) => sum + item.gstAmount);
  }

  // Calculate grand total
  double get grandTotal {
    return subtotal + totalGst;
  }

  // Get GST breakdown by rate
  Map<double, double> get gstBreakdown {
    Map<double, double> breakdown = {};
    for (var item in items) {
      breakdown[item.gstPercent] =
          (breakdown[item.gstPercent] ?? 0) + item.gstAmount;
    }
    return breakdown;
  }

  // Calculate total items count
  int get totalItems {
    return items.length;
  }

  // Calculate total quantity
  double get totalQuantity {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplierName': supplierName,
      'billDate': billDate.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'billNumber': billNumber,
      'notes': notes,
    };
  }

  // Create from JSON
  factory PurchaseBill.fromJson(Map<String, dynamic> json) {
    return PurchaseBill(
      id: json['id'] ?? '',
      supplierName: json['supplierName'] ?? '',
      billDate: DateTime.parse(json['billDate']),
      items: (json['items'] as List)
          .map((item) => BillItem.fromJson(item))
          .toList(),
      billNumber: json['billNumber'],
      notes: json['notes'],
    );
  }

  // Generate purchase order number
  static String generatePurchaseNumber() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    return 'PO-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${timestamp.toString().substring(timestamp.toString().length - 4)}';
  }

  // Create a copy with modified fields
  PurchaseBill copyWith({
    String? id,
    String? supplierName,
    DateTime? billDate,
    List<BillItem>? items,
    String? billNumber,
    String? notes,
  }) {
    return PurchaseBill(
      id: id ?? this.id,
      supplierName: supplierName ?? this.supplierName,
      billDate: billDate ?? this.billDate,
      items: items ?? this.items,
      billNumber: billNumber ?? this.billNumber,
      notes: notes ?? this.notes,
    );
  }
}
