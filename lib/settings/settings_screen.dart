import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/company_settings.dart';
import '../../widgets/custom_button.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _companyNameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _gstinController;

  int _selectedColorTheme = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>().settings;

    _companyNameController = TextEditingController(text: settings.companyName);
    _addressController = TextEditingController(text: settings.address);
    _cityController = TextEditingController(text: settings.city);
    _stateController = TextEditingController(text: settings.state);
    _pincodeController = TextEditingController(text: settings.pincode);
    _phoneController = TextEditingController(text: settings.phone);
    _emailController = TextEditingController(text: settings.email);
    _gstinController = TextEditingController(text: settings.gstin);
    _selectedColorTheme = settings.invoiceColorTheme;
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final newSettings = CompanySettings(
      companyName: _companyNameController.text,
      address: _addressController.text,
      city: _cityController.text,
      state: _stateController.text,
      pincode: _pincodeController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      gstin: _gstinController.text,
      invoiceColorTheme: _selectedColorTheme,
    );

    await context.read<SettingsProvider>().updateSettings(newSettings);

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Details Section
            const Text(
              'Company Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _companyNameController,
                            decoration: const InputDecoration(
                              labelText: 'Company Name *',
                              prefixIcon: Icon(Icons.business),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _gstinController,
                            decoration: const InputDecoration(
                              labelText: 'GSTIN *',
                              prefixIcon: Icon(Icons.receipt_long),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: 'City',
                              prefixIcon: Icon(Icons.location_city),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _stateController,
                            decoration: const InputDecoration(
                              labelText: 'State',
                              prefixIcon: Icon(Icons.map),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _pincodeController,
                            decoration: const InputDecoration(
                              labelText: 'Pincode',
                              prefixIcon: Icon(Icons.pin_drop),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              prefixIcon: Icon(Icons.phone),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Appearance Section
            const Text(
              'Appearance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dark Mode',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Switch between light and dark theme',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) {
                            themeProvider.toggleTheme();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Invoice Customization
            const Text(
              'Invoice Customization',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Color Theme',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Choose a color theme for your invoices',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _ColorThemeOption(
                          color: Colors.blue,
                          label: 'Blue',
                          isSelected: _selectedColorTheme == 0,
                          onTap: () => setState(() => _selectedColorTheme = 0),
                        ),
                        const SizedBox(width: 12),
                        _ColorThemeOption(
                          color: Colors.green,
                          label: 'Green',
                          isSelected: _selectedColorTheme == 1,
                          onTap: () => setState(() => _selectedColorTheme = 1),
                        ),
                        const SizedBox(width: 12),
                        _ColorThemeOption(
                          color: Colors.purple,
                          label: 'Purple',
                          isSelected: _selectedColorTheme == 2,
                          onTap: () => setState(() => _selectedColorTheme = 2),
                        ),
                        const SizedBox(width: 12),
                        _ColorThemeOption(
                          color: Colors.red,
                          label: 'Red',
                          isSelected: _selectedColorTheme == 3,
                          onTap: () => setState(() => _selectedColorTheme = 3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Save Button
            Row(
              children: [
                CustomButton(
                  text: 'Save Settings',
                  onPressed: _saveSettings,
                  icon: Icons.save,
                  isLoading: _isLoading,
                  width: 200,
                ),
                const SizedBox(width: 12),
                CustomButton(
                  text: 'Reset to Default',
                  onPressed: () {
                    _showResetConfirmation();
                  },
                  icon: Icons.restore,
                  isOutlined: true,
                  width: 200,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
            'Are you sure you want to reset all settings to default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<SettingsProvider>().resetSettings();
              Navigator.pop(context);

              // Reload controllers
              final settings = context.read<SettingsProvider>().settings;
              _companyNameController.text = settings.companyName;
              _addressController.text = settings.address;
              _cityController.text = settings.city;
              _stateController.text = settings.state;
              _pincodeController.text = settings.pincode;
              _phoneController.text = settings.phone;
              _emailController.text = settings.email;
              _gstinController.text = settings.gstin;
              setState(() => _selectedColorTheme = settings.invoiceColorTheme);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset to default'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _gstinController.dispose();
    super.dispose();
  }
}

class _ColorThemeOption extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorThemeOption({
    required this.color,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
