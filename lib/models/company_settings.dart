class CompanySettings {
  String companyName;
  String address;
  String city;
  String state;
  String pincode;
  String phone;
  String email;
  String gstin;
  String? logoPath;
  int invoiceColorTheme; // 0: Blue, 1: Green, 2: Purple, 3: Red

  CompanySettings({
    this.companyName = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
    this.phone = '',
    this.email = '',
    this.gstin = '',
    this.logoPath,
    this.invoiceColorTheme = 0,
  });

  // Check if basic company info is set
  bool get isConfigured {
    return companyName.isNotEmpty && address.isNotEmpty && gstin.isNotEmpty;
  }

  // Get full address
  String get fullAddress {
    List<String> parts = [];
    if (address.isNotEmpty) parts.add(address);
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) parts.add(state);
    if (pincode.isNotEmpty) parts.add(pincode);
    return parts.join(', ');
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'phone': phone,
      'email': email,
      'gstin': gstin,
      'logoPath': logoPath,
      'invoiceColorTheme': invoiceColorTheme,
    };
  }

  // Create from JSON
  factory CompanySettings.fromJson(Map<String, dynamic> json) {
    return CompanySettings(
      companyName: json['companyName'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      gstin: json['gstin'] ?? '',
      logoPath: json['logoPath'],
      invoiceColorTheme: json['invoiceColorTheme'] ?? 0,
    );
  }

  // Create a copy with modified fields
  CompanySettings copyWith({
    String? companyName,
    String? address,
    String? city,
    String? state,
    String? pincode,
    String? phone,
    String? email,
    String? gstin,
    String? logoPath,
    int? invoiceColorTheme,
  }) {
    return CompanySettings(
      companyName: companyName ?? this.companyName,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gstin: gstin ?? this.gstin,
      logoPath: logoPath ?? this.logoPath,
      invoiceColorTheme: invoiceColorTheme ?? this.invoiceColorTheme,
    );
  }
}
