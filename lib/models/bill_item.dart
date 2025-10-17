class BillItem {
  String productName;
  double quantity;
  double rate;
  double gstPercent;
  String hsnCode;
  String? size; // Optional, mainly for purchase bills
  double? mrp; // Optional, mainly for purchase bills

  BillItem({
    required this.productName,
    required this.quantity,
    required this.rate,
    required this.gstPercent,
    required this.hsnCode,
    this.size,
    this.mrp,
  });

  // Calculate GST Amount
  double get gstAmount {
    return (rate * quantity * gstPercent) / 100;
  }

  // Calculate total without GST
  double get subtotal {
    return rate * quantity;
  }

  // Calculate total with GST
  double get total {
    return subtotal + gstAmount;
  }

  // Calculate total rate (base rate + GST per unit)
  double get totalRate {
    return rate + (rate * gstPercent / 100);
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'quantity': quantity,
      'rate': rate,
      'gstPercent': gstPercent,
      'hsnCode': hsnCode,
      'size': size,
      'mrp': mrp,
    };
  }

  // Create from JSON
  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      productName: json['productName'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      rate: (json['rate'] ?? 0).toDouble(),
      gstPercent: (json['gstPercent'] ?? 0).toDouble(),
      hsnCode: json['hsnCode'] ?? '',
      size: json['size'],
      mrp: json['mrp']?.toDouble(),
    );
  }

  // Create a copy with modified fields
  BillItem copyWith({
    String? productName,
    double? quantity,
    double? rate,
    double? gstPercent,
    String? hsnCode,
    String? size,
    double? mrp,
  }) {
    return BillItem(
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      gstPercent: gstPercent ?? this.gstPercent,
      hsnCode: hsnCode ?? this.hsnCode,
      size: size ?? this.size,
      mrp: mrp ?? this.mrp,
    );
  }
}
