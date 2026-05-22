import 'package:flutter/material.dart';
import 'package:core/core.dart';

import '../widgets/gallery_menu_card.dart';
import 'dialog_popup_screen.dart';
import 'form_input_screen.dart';
import 'cards_list_screen.dart';
import 'navigation_tab_screen.dart';
import 'loading_empty_screen.dart';
import 'animation_screen.dart';
import 'feedback_screen.dart';
import 'utilities_screen.dart';

class UiGalleryHomeScreen extends StatelessWidget {
  const UiGalleryHomeScreen({super.key});

  List<_MenuData> _buildMenus(AppLocalizations l10n) => [
        _MenuData(
          title: l10n.galleryMenuDialogTitle,
          subtitle: l10n.galleryMenuDialogSubtitle,
          icon: Icons.chat_bubble_outline,
          color: Colors.indigo,
        ),
        _MenuData(
          title: l10n.galleryMenuFormTitle,
          subtitle: l10n.galleryMenuFormSubtitle,
          icon: Icons.edit_note_outlined,
          color: Colors.teal,
        ),
        _MenuData(
          title: l10n.galleryMenuCardsTitle,
          subtitle: l10n.galleryMenuCardsSubtitle,
          icon: Icons.dashboard_outlined,
          color: Colors.purple,
        ),
        _MenuData(
          title: l10n.galleryMenuNavTitle,
          subtitle: l10n.galleryMenuNavSubtitle,
          icon: Icons.explore_outlined,
          color: Colors.amber,
        ),
        _MenuData(
          title: l10n.galleryMenuLoadingTitle,
          subtitle: l10n.galleryMenuLoadingSubtitle,
          icon: Icons.hourglass_empty_outlined,
          color: Colors.blueGrey,
        ),
        _MenuData(
          title: l10n.galleryMenuAnimTitle,
          subtitle: l10n.galleryMenuAnimSubtitle,
          icon: Icons.auto_awesome_outlined,
          color: Colors.pink,
        ),
        _MenuData(
          title: l10n.galleryMenuFeedbackTitle,
          subtitle: l10n.galleryMenuFeedbackSubtitle,
          icon: Icons.thumb_up_alt_outlined,
          color: Colors.cyan,
        ),
        _MenuData(
          title: l10n.galleryMenuUtilitiesTitle,
          subtitle: l10n.galleryMenuUtilitiesSubtitle,
          icon: Icons.build_outlined,
          color: Colors.brown,
        ),
      ];

  void _navigate(BuildContext context, int index) {
    final screens = [
      const DialogPopupScreen(),
      const FormInputScreen(),
      const CardsListScreen(),
      const NavigationTabScreen(),
      const LoadingEmptyScreen(),
      const AnimationScreen(),
      const FeedbackScreen(),
      const UtilitiesScreen(),
    ];
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screens[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final menus = _buildMenus(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.galleryTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.widgets_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.gallerySubtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.1,
              ),
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final m = menus[index];
                return GalleryMenuCard(
                  title: m.title,
                  subtitle: m.subtitle,
                  icon: m.icon,
                  color: m.color,
                  onTap: () => _navigate(context, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuData {
  const _MenuData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}
