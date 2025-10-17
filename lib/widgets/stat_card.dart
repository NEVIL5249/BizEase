import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? widget.color.withOpacity(0.5)
                  : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.color.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.color,
                      size: 28,
                    ),
                  ),

                  // Optional action icon
                  if (widget.onTap != null)
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),

              // Value
              Text(
                widget.value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Subtitle
              if (widget.subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  widget.subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Specialized stat cards with predefined colors

class SalesStatCard extends StatelessWidget {
  final String value;
  final String? subtitle;
  final VoidCallback? onTap;

  const SalesStatCard({
    super.key,
    required this.value,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StatCard(
      title: 'Total Sales',
      value: value,
      icon: Icons.trending_up_rounded,
      color: Colors.green,
      subtitle: subtitle,
      onTap: onTap,
    );
  }
}

class PurchaseStatCard extends StatelessWidget {
  final String value;
  final String? subtitle;
  final VoidCallback? onTap;

  const PurchaseStatCard({
    super.key,
    required this.value,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StatCard(
      title: 'Total Purchases',
      value: value,
      icon: Icons.shopping_cart_rounded,
      color: Colors.orange,
      subtitle: subtitle,
      onTap: onTap,
    );
  }
}

class OutstandingStatCard extends StatelessWidget {
  final String value;
  final String? subtitle;
  final VoidCallback? onTap;

  const OutstandingStatCard({
    super.key,
    required this.value,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StatCard(
      title: 'Outstanding',
      value: value,
      icon: Icons.account_balance_wallet_rounded,
      color: Colors.red,
      subtitle: subtitle,
      onTap: onTap,
    );
  }
}

class GSTStatCard extends StatelessWidget {
  final String value;
  final String? subtitle;
  final VoidCallback? onTap;

  const GSTStatCard({
    super.key,
    required this.value,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StatCard(
      title: 'Total GST',
      value: value,
      icon: Icons.receipt_long_rounded,
      color: AppTheme.primaryLight,
      subtitle: subtitle,
      onTap: onTap,
    );
  }
}
