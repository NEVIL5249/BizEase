import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SidebarNavigation extends StatelessWidget {
  final NavigationItem selectedItem;
  final Function(NavigationItem) onItemSelected;

  const SidebarNavigation({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: AppConstants.sidebarWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          right: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo and App Name
          Container(
            height: AppConstants.appBarHeight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryLight, AppTheme.secondaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.business_center_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              children: navigationItems.map((navItem) {
                return _NavigationTile(
                  navItem: navItem,
                  isSelected: selectedItem == navItem.item,
                  onTap: () => onItemSelected(navItem.item),
                );
              }).toList(),
            ),
          ),

          // Version Info
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Version ${AppConstants.appVersion}',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationTile extends StatefulWidget {
  final NavItem navItem;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavigationTile({
    required this.navItem,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavigationTile> createState() => _NavigationTileState();
}

class _NavigationTileState extends State<_NavigationTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : _isHovered
                        ? (isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey.withOpacity(0.05))
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: widget.isSelected
                    ? Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                        width: 1,
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    widget.navItem.icon,
                    size: 22,
                    color: widget.isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  const SizedBox(width: 14),
                  Text(
                    widget.navItem.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: widget.isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
