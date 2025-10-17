import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../utils/constants.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/top_app_bar.dart';
import 'dashboard/dashboard_screen.dart';
import 'sales/sales_screen.dart';
import 'purchase/purchase_screen.dart';
import 'reports/reports_screen.dart';
import 'package:BizEase/settings/settings_screen.dart';
import 'package:BizEase/screens/inventory/inventory_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WindowListener {
  NavigationItem _selectedItem = NavigationItem.dashboard;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    // Show dialog on X button
    bool exit = await _showExitDialog();
    if (exit) {
      await windowManager.destroy();
    }
  }

  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Theme.of(context).colorScheme.primary,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Exit BizEase?',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Are you sure you want to close the application?',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Exit'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarNavigation(
            selectedItem: _selectedItem,
            onItemSelected: (item) {
              setState(() {
                _selectedItem = item;
              });
            },
          ),
          Expanded(
            child: Column(
              children: [
                TopAppBar(title: _getTitle()),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_selectedItem) {
      case NavigationItem.dashboard:
        return 'Dashboard';
      case NavigationItem.sales:
        return 'Sales Management';
      case NavigationItem.purchase:
        return 'Purchase Management';
      case NavigationItem.inventory:       // ✅ added
        return 'Inventory Management';
      case NavigationItem.reports:
        return 'Reports';
      case NavigationItem.settings:
        return 'Settings';
    }
  }

  Widget _buildContent() {
    switch (_selectedItem) {
      case NavigationItem.dashboard:
        return const DashboardScreen();
      case NavigationItem.sales:
        return const SalesScreen();
      case NavigationItem.purchase:
        return const PurchaseScreen();
      case NavigationItem.inventory:       // ✅ added
        return const InventoryScreen();
      case NavigationItem.reports:
        return const ReportsScreen();
      case NavigationItem.settings:
        return const SettingsScreen();
    }
  }
}
