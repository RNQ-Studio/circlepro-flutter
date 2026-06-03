import 'package:flutter/material.dart';

import '../../../../theme/manah_colors.dart';

class _MenuItem {
  const _MenuItem({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

const _menuItems = [
  _MenuItem(
    label: 'Scoring',
    icon: Icons.track_changes_rounded,
  ),
  _MenuItem(
    label: 'Statistik',
    icon: Icons.analytics_rounded,
  ),
  _MenuItem(
    label: 'Riwayat',
    icon: Icons.history_rounded,
  ),
  _MenuItem(
    label: 'Klub',
    icon: Icons.groups_rounded,
  ),
  _MenuItem(
    label: 'Event',
    icon: Icons.emoji_events_rounded,
  ),
  _MenuItem(
    label: 'Pelatih',
    icon: Icons.person_search_rounded,
  ),
  _MenuItem(
    label: 'Lapangan',
    icon: Icons.map_rounded,
  ),
  _MenuItem(
    label: 'Artikel',
    icon: Icons.menu_book_rounded,
  ),
];

class HomeMenuGrid extends StatelessWidget {
  const HomeMenuGrid({super.key, required this.onMenuTap});

  final void Function(String label) onMenuTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _menuItems.length,
      itemBuilder: (context, index) {
        final item = _menuItems[index];
        return _MenuCell(item: item, onTap: () => onMenuTap(item.label));
      },
    );
  }
}

class _MenuCell extends StatefulWidget {
  const _MenuCell({required this.item, required this.onTap});

  final _MenuItem item;
  final VoidCallback onTap;

  @override
  State<_MenuCell> createState() => _MenuCellState();
}

class _MenuCellState extends State<_MenuCell> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cellBgColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F9FD);
    final borderColor = isDark ? Colors.white.withOpacity(0.08) : ManahColors.brand.withOpacity(0.08);
    final iconColor = isDark ? ManahColors.brandLight : ManahColors.brand;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: cellBgColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: borderColor,
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.05 : 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                widget.item.icon,
                color: iconColor,
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.item.label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: theme.colorScheme.onSurface.withOpacity(0.85),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
