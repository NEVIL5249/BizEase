import 'package:flutter/material.dart';

// App Constants
class AppConstants {
  static const String appName = 'BizEase';
  static const String appVersion = '1.0.0';
  static const double sidebarWidth = 260.0;
  static const double appBarHeight = 70.0;

  // Storage Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keySalesBills = 'sales_bills';
  static const String keyPurchaseBills = 'purchase_bills';
  static const String keyCompanySettings = 'company_settings';
}

// App Theme
class AppTheme {
  // Light Theme Colors
  static const Color primaryLight = Color(0xFF6366F1); // Indigo
  static const Color secondaryLight = Color(0xFF8B5CF6); // Purple
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF818CF8);
  static const Color secondaryDark = Color(0xFFA78BFA);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: primaryLight,
      secondary: secondaryLight,
      surface: surfaceLight,
      background: backgroundLight,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: surfaceLight,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: surfaceLight,
      foregroundColor: textPrimaryLight,
      centerTitle: false,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: primaryDark,
      secondary: secondaryDark,
      surface: surfaceDark,
      background: backgroundDark,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade800),
      ),
      color: surfaceDark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: primaryDark,
        foregroundColor: backgroundDark,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryDark, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: surfaceDark,
      foregroundColor: textPrimaryDark,
      centerTitle: false,
    ),
  );
}

// Navigation Items
enum NavigationItem {
  dashboard,
  sales,
  purchase,
  reports,
  settings,
}

class NavItem {
  final String title;
  final IconData icon;
  final NavigationItem item;

  NavItem({
    required this.title,
    required this.icon,
    required this.item,
  });
}

// Navigation Menu Items
final List<NavItem> navigationItems = [
  NavItem(
    title: 'Dashboard',
    icon: Icons.dashboard_rounded,
    item: NavigationItem.dashboard,
  ),
  NavItem(
    title: 'Sales',
    icon: Icons.receipt_long_rounded,
    item: NavigationItem.sales,
  ),
  NavItem(
    title: 'Purchase',
    icon: Icons.shopping_cart_rounded,
    item: NavigationItem.purchase,
  ),
  NavItem(
    title: 'Reports',
    icon: Icons.assessment_rounded,
    item: NavigationItem.reports,
  ),
  NavItem(
    title: 'Settings',
    icon: Icons.settings_rounded,
    item: NavigationItem.settings,
  ),
];

// Currency Formatter
String formatCurrency(double amount) {
  return '₹${amount.toStringAsFixed(2)}';
}

// Date Formatter
String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
}

// GST Rates
const List<double> gstRates = [0, 5, 12, 18, 28];
