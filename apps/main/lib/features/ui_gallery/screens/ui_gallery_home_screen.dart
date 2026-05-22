import 'package:flutter/material.dart';

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

  static final _menus = [
    (
      title: 'Dialog & Popup',
      subtitle: 'Alert, bottom sheet, custom dialog',
      icon: Icons.chat_bubble_outline,
      color: Colors.indigo,
    ),
    (
      title: 'Form & Input',
      subtitle: 'TextField, dropdown, date picker',
      icon: Icons.edit_note_outlined,
      color: Colors.teal,
    ),
    (
      title: 'Cards & List',
      subtitle: 'Card variants dan dismissible list',
      icon: Icons.dashboard_outlined,
      color: Colors.purple,
    ),
    (
      title: 'Navigation',
      subtitle: 'TabBar, stepper, drawer demo',
      icon: Icons.explore_outlined,
      color: Colors.amber,
    ),
    (
      title: 'Loading & Empty',
      subtitle: 'Shimmer, progress, empty states',
      icon: Icons.hourglass_empty_outlined,
      color: Colors.blueGrey,
    ),
    (
      title: 'Animation',
      subtitle: 'Hero, animated container, stagger',
      icon: Icons.auto_awesome_outlined,
      color: Colors.pink,
    ),
    (
      title: 'Feedback',
      subtitle: 'Rating, like, poll, OTP input',
      icon: Icons.thumb_up_alt_outlined,
      color: Colors.cyan,
    ),
    (
      title: 'Utilities',
      subtitle: 'Chip, badge, search, clipboard',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Component Gallery'),
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
                    '8 kategori komponen interaktif',
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
              itemCount: _menus.length,
              itemBuilder: (context, index) {
                final m = _menus[index];
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
