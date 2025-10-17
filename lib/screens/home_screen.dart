import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/top_app_bar.dart';
import 'dashboard/dashboard_screen.dart';
import 'sales/sales_screen.dart';
import 'purchase/purchase_screen.dart';
import 'reports/reports_screen.dart';
import 'package:bizease/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NavigationItem _selectedItem = NavigationItem.dashboard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          SidebarNavigation(
            selectedItem: _selectedItem,
            onItemSelected: (item) {
              setState(() {
                _selectedItem = item;
              });
            },
          ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top App Bar
                TopAppBar(title: _getTitle()),

                // Content
                Expanded(
                  child: _buildContent(),
                ),
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
      case NavigationItem.reports:
        return const ReportsScreen();
      case NavigationItem.settings:
        return const SettingsScreen();
    }
  }
}
