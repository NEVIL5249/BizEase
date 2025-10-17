import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/inventory_item.dart';

class InventoryProvider extends ChangeNotifier {
  List<InventoryItem> _inventory = [];

  List<InventoryItem> get inventory => _inventory;

  // Load inventory from SharedPreferences
  Future<void> loadInventory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('inventory');
    if (data != null) {
      final List decoded = jsonDecode(data);
      _inventory = decoded.map((e) => InventoryItem.fromMap(e)).toList();
      notifyListeners();
    }
  }

  // Save inventory to SharedPreferences
  Future<void> saveInventory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_inventory.map((e) => e.toMap()).toList());
    await prefs.setString('inventory', data);
  }

  // Add or update an item
  void addOrUpdateItem(InventoryItem item) {
    final index = _inventory.indexWhere((i) => i.productName == item.productName);
    if (index >= 0) {
      _inventory[index].quantity += item.quantity;
    } else {
      _inventory.add(item);
    }
    saveInventory();
    notifyListeners();
  }

  // Get an item by product name
  InventoryItem? getItemByName(String productName) {
    try {
      return _inventory.firstWhere((item) => item.productName == productName);
    } catch (e) {
      return null;
    }
  }

  // Deduct stock for a sold item
  void deductItem(String productName, int quantity) {
    final index = _inventory.indexWhere((i) => i.productName == productName);
    if (index >= 0) {
      _inventory[index].quantity -= quantity;
      if (_inventory[index].quantity < 0) _inventory[index].quantity = 0;
      saveInventory();
      notifyListeners();
    }
  }

  // Optional: get low stock items
  List<InventoryItem> getLowStockItems() {
    return _inventory.where((item) => item.quantity <= 0).toList();
  }
}
