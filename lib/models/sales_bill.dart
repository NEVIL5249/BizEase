import 'bill_item.dart';

class SalesBill {
  String id;
  String customerName;
  DateTime billDate;
  List<BillItem> items;
  String? notes;

  SalesBill({
    required this.id,
    required this.customerName,
    required this.billDate,
    required this.items,
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

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'billDate': billDate.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'notes': notes,
    };
  }

  // Create from JSON
  factory SalesBill.fromJson(Map<String, dynamic> json) {
    return SalesBill(
      id: json['id'] ?? '',
      customerName: json['customerName'] ?? '',
      billDate: DateTime.parse(json['billDate']),
      items: (json['items'] as List)
          .map((item) => BillItem.fromJson(item))
          .toList(),
      notes: json['notes'],
    );
  }

  // Generate invoice number (based on date and sequence)
  static String generateInvoiceNumber() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    return 'INV-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${timestamp.toString().substring(timestamp.toString().length - 4)}';
  }

  // Create a copy with modified fields
  SalesBill copyWith({
    String? id,
    String? customerName,
    DateTime? billDate,
    List<BillItem>? items,
    String? notes,
  }) {
    return SalesBill(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      billDate: billDate ?? this.billDate,
      items: items ?? this.items,
      notes: notes ?? this.notes,
    );
  }
}
