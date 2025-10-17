class InventoryItem {
  final String productName;
  int quantity;
  final double rate;
  final double gstPercent;
  final String hsnCode;
  final String size;
  final double mrp;

  InventoryItem({
    required this.productName,
    required this.quantity,
    required this.rate,
    required this.gstPercent,
    required this.hsnCode,
    required this.size,
    required this.mrp,
  });

  Map<String, dynamic> toMap() => {
        'productName': productName,
        'quantity': quantity,
        'rate': rate,
        'gstPercent': gstPercent,
        'hsnCode': hsnCode,
        'size': size,
        'mrp': mrp,
      };

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      productName: map['productName'],
      quantity: map['quantity'],
      rate: map['rate'],
      gstPercent: map['gstPercent'],
      hsnCode: map['hsnCode'],
      size: map['size'],
      mrp: map['mrp'],
    );
  }
}
