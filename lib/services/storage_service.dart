import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sales_bill.dart';
import '../models/purchase_bill.dart';
import '../models/company_settings.dart';

class StorageService {
  static const String _keyPrefix = 'bizease_';

  // Storage keys
  static const String keySalesBills = '${_keyPrefix}sales_bills';
  static const String keyPurchaseBills = '${_keyPrefix}purchase_bills';
  static const String keyCompanySettings = '${_keyPrefix}company_settings';
  static const String keyThemeMode = '${_keyPrefix}theme_mode';
  static const String keyAppVersion = '${_keyPrefix}app_version';
  static const String keyLastBackup = '${_keyPrefix}last_backup';

  // Get SharedPreferences instance
  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // === Sales Bills Storage ===

  // Save sales bills
  static Future<bool> saveSalesBills(List<SalesBill> bills) async {
    try {
      final prefs = await _getPrefs();
      final jsonList = bills.map((bill) => bill.toJson()).toList();
      final jsonString = json.encode(jsonList);
      return await prefs.setString(keySalesBills, jsonString);
    } catch (e) {
      print('Error saving sales bills: $e');
      return false;
    }
  }

  // Load sales bills
  static Future<List<SalesBill>> loadSalesBills() async {
    try {
      final prefs = await _getPrefs();
      final jsonString = prefs.getString(keySalesBills);

      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => SalesBill.fromJson(json)).toList();
    } catch (e) {
      print('Error loading sales bills: $e');
      return [];
    }
  }

  // Add single sales bill
  static Future<bool> addSalesBill(SalesBill bill) async {
    try {
      final bills = await loadSalesBills();
      bills.insert(0, bill);
      return await saveSalesBills(bills);
    } catch (e) {
      print('Error adding sales bill: $e');
      return false;
    }
  }

  // Update sales bill
  static Future<bool> updateSalesBill(String id, SalesBill updatedBill) async {
    try {
      final bills = await loadSalesBills();
      final index = bills.indexWhere((bill) => bill.id == id);

      if (index == -1) return false;

      bills[index] = updatedBill;
      return await saveSalesBills(bills);
    } catch (e) {
      print('Error updating sales bill: $e');
      return false;
    }
  }

  // Delete sales bill
  static Future<bool> deleteSalesBill(String id) async {
    try {
      final bills = await loadSalesBills();
      bills.removeWhere((bill) => bill.id == id);
      return await saveSalesBills(bills);
    } catch (e) {
      print('Error deleting sales bill: $e');
      return false;
    }
  }

  // === Purchase Bills Storage ===

  // Save purchase bills
  static Future<bool> savePurchaseBills(List<PurchaseBill> bills) async {
    try {
      final prefs = await _getPrefs();
      final jsonList = bills.map((bill) => bill.toJson()).toList();
      final jsonString = json.encode(jsonList);
      return await prefs.setString(keyPurchaseBills, jsonString);
    } catch (e) {
      print('Error saving purchase bills: $e');
      return false;
    }
  }

  // Load purchase bills
  static Future<List<PurchaseBill>> loadPurchaseBills() async {
    try {
      final prefs = await _getPrefs();
      final jsonString = prefs.getString(keyPurchaseBills);

      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => PurchaseBill.fromJson(json)).toList();
    } catch (e) {
      print('Error loading purchase bills: $e');
      return [];
    }
  }

  // Add single purchase bill
  static Future<bool> addPurchaseBill(PurchaseBill bill) async {
    try {
      final bills = await loadPurchaseBills();
      bills.insert(0, bill);
      return await savePurchaseBills(bills);
    } catch (e) {
      print('Error adding purchase bill: $e');
      return false;
    }
  }

  // Update purchase bill
  static Future<bool> updatePurchaseBill(
      String id, PurchaseBill updatedBill) async {
    try {
      final bills = await loadPurchaseBills();
      final index = bills.indexWhere((bill) => bill.id == id);

      if (index == -1) return false;

      bills[index] = updatedBill;
      return await savePurchaseBills(bills);
    } catch (e) {
      print('Error updating purchase bill: $e');
      return false;
    }
  }

  // Delete purchase bill
  static Future<bool> deletePurchaseBill(String id) async {
    try {
      final bills = await loadPurchaseBills();
      bills.removeWhere((bill) => bill.id == id);
      return await savePurchaseBills(bills);
    } catch (e) {
      print('Error deleting purchase bill: $e');
      return false;
    }
  }

  // === Company Settings Storage ===

  // Save company settings
  static Future<bool> saveCompanySettings(CompanySettings settings) async {
    try {
      final prefs = await _getPrefs();
      final jsonString = json.encode(settings.toJson());
      return await prefs.setString(keyCompanySettings, jsonString);
    } catch (e) {
      print('Error saving company settings: $e');
      return false;
    }
  }

  // Load company settings
  static Future<CompanySettings> loadCompanySettings() async {
    try {
      final prefs = await _getPrefs();
      final jsonString = prefs.getString(keyCompanySettings);

      if (jsonString == null) return CompanySettings();

      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return CompanySettings.fromJson(jsonMap);
    } catch (e) {
      print('Error loading company settings: $e');
      return CompanySettings();
    }
  }

  // === Theme Storage ===

  // Save theme mode
  static Future<bool> saveThemeMode(String mode) async {
    try {
      final prefs = await _getPrefs();
      return await prefs.setString(keyThemeMode, mode);
    } catch (e) {
      print('Error saving theme mode: $e');
      return false;
    }
  }

  // Load theme mode
  static Future<String?> loadThemeMode() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(keyThemeMode);
    } catch (e) {
      print('Error loading theme mode: $e');
      return null;
    }
  }

  // === Utility Methods ===

  // Clear all app data
  static Future<bool> clearAllData() async {
    try {
      final prefs = await _getPrefs();

      // Get all keys that start with our prefix
      final keys = prefs.getKeys().where((key) => key.startsWith(_keyPrefix));

      for (final key in keys) {
        await prefs.remove(key);
      }

      return true;
    } catch (e) {
      print('Error clearing all data: $e');
      return false;
    }
  }

  // Export all data as JSON string
  static Future<String> exportAllData() async {
    try {
      final salesBills = await loadSalesBills();
      final purchaseBills = await loadPurchaseBills();
      final companySettings = await loadCompanySettings();
      final themeMode = await loadThemeMode();

      final data = {
        'sales_bills': salesBills.map((bill) => bill.toJson()).toList(),
        'purchase_bills': purchaseBills.map((bill) => bill.toJson()).toList(),
        'company_settings': companySettings.toJson(),
        'theme_mode': themeMode,
        'export_date': DateTime.now().toIso8601String(),
        'app_version': '1.0.0',
      };

      return json.encode(data);
    } catch (e) {
      print('Error exporting data: $e');
      return '{}';
    }
  }

  // Import data from JSON string
  static Future<bool> importData(String jsonString) async {
    try {
      final Map<String, dynamic> data = json.decode(jsonString);

      // Import sales bills
      if (data.containsKey('sales_bills')) {
        final salesBillsList = (data['sales_bills'] as List)
            .map((json) => SalesBill.fromJson(json))
            .toList();
        await saveSalesBills(salesBillsList);
      }

      // Import purchase bills
      if (data.containsKey('purchase_bills')) {
        final purchaseBillsList = (data['purchase_bills'] as List)
            .map((json) => PurchaseBill.fromJson(json))
            .toList();
        await savePurchaseBills(purchaseBillsList);
      }

      // Import company settings
      if (data.containsKey('company_settings')) {
        final settings = CompanySettings.fromJson(data['company_settings']);
        await saveCompanySettings(settings);
      }

      // Import theme mode
      if (data.containsKey('theme_mode') && data['theme_mode'] != null) {
        await saveThemeMode(data['theme_mode']);
      }

      return true;
    } catch (e) {
      print('Error importing data: $e');
      return false;
    }
  }

  // Get storage size (approximate)
  static Future<int> getStorageSize() async {
    try {
      final prefs = await _getPrefs();
      int totalSize = 0;

      for (final key in prefs.getKeys()) {
        if (key.startsWith(_keyPrefix)) {
          final value = prefs.get(key);
          if (value is String) {
            totalSize += value.length;
          }
        }
      }

      return totalSize;
    } catch (e) {
      print('Error calculating storage size: $e');
      return 0;
    }
  }

  // Check if data exists
  static Future<bool> hasData() async {
    try {
      final salesBills = await loadSalesBills();
      final purchaseBills = await loadPurchaseBills();
      return salesBills.isNotEmpty || purchaseBills.isNotEmpty;
    } catch (e) {
      print('Error checking data existence: $e');
      return false;
    }
  }

  // Get last backup date
  static Future<DateTime?> getLastBackupDate() async {
    try {
      final prefs = await _getPrefs();
      final dateString = prefs.getString(keyLastBackup);

      if (dateString == null) return null;

      return DateTime.parse(dateString);
    } catch (e) {
      print('Error getting last backup date: $e');
      return null;
    }
  }

  // Update last backup date
  static Future<bool> updateLastBackupDate() async {
    try {
      final prefs = await _getPrefs();
      return await prefs.setString(
          keyLastBackup, DateTime.now().toIso8601String());
    } catch (e) {
      print('Error updating last backup date: $e');
      return false;
    }
  }
}
