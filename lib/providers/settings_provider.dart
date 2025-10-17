import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/company_settings.dart';
import '../utils/constants.dart';

class SettingsProvider extends ChangeNotifier {
  CompanySettings _settings = CompanySettings();

  CompanySettings get settings => _settings;

  SettingsProvider() {
    _loadSettings();
  }

  // Load settings from storage
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(AppConstants.keyCompanySettings);

      if (settingsJson != null) {
        final decoded = json.decode(settingsJson);
        _settings = CompanySettings.fromJson(decoded);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  // Update company settings
  Future<void> updateSettings(CompanySettings newSettings) async {
    _settings = newSettings;
    notifyListeners();
    await _saveSettings();
  }

  // Update individual fields
  Future<void> updateCompanyName(String name) async {
    _settings = _settings.copyWith(companyName: name);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> updateAddress(String address) async {
    _settings = _settings.copyWith(address: address);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> updateCity(String city) async {
    _settings = _settings.copyWith(city: city);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> updateState(String state) async {
    _settings = _settings.copyWith(state: state);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> updatePincode(String pincode) async {
    _settings = _settings.copyWith(pincode: pincode);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> updatePhone(String phone) async {
    _settings = _settings.copyWith(phone: phone);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> updateEmail(String email) async {
    _settings = _settings.copyWith(email: email);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> updateGstin(String gstin) async {
    _settings = _settings.copyWith(gstin: gstin);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> updateLogoPath(String? logoPath) async {
    _settings = _settings.copyWith(logoPath: logoPath);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> updateInvoiceColorTheme(int theme) async {
    _settings = _settings.copyWith(invoiceColorTheme: theme);
    notifyListeners();
    await _saveSettings();
  }

  // Save settings to storage
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = json.encode(_settings.toJson());
      await prefs.setString(AppConstants.keyCompanySettings, settingsJson);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  // Reset settings
  Future<void> resetSettings() async {
    _settings = CompanySettings();
    notifyListeners();
    await _saveSettings();
  }
}
