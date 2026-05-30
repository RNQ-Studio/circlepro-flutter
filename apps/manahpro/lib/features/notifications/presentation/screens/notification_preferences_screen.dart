import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/manah_tokens.dart';
import '../notifications_providers.dart';

/// Per-category notification preferences (task 2.5/2.6).
class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  static const _labels = {
    'rating': 'Rating & Peringkat',
    'event': 'Event & Lomba',
    'social': 'Sosial (like, komentar, follow)',
    'market': 'Marketplace',
    'marketing': 'Promosi & Info',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationPrefsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Preferensi Notifikasi')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat: $e')),
        data: (prefs) => ListView(
          padding: const EdgeInsets.all(ManahSpacing.base),
          children: [
            for (final p in prefs) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: ManahSpacing.sm),
                child: Text(
                  _labels[p.category] ?? p.category,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: const Icon(Icons.notifications_active_outlined),
                title: const Text('Push'),
                value: p.pushEnabled,
                onChanged: (v) => ref.read(notificationPrefsProvider.notifier).toggle(p.category, push: v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                value: p.emailEnabled,
                onChanged: (v) => ref.read(notificationPrefsProvider.notifier).toggle(p.category, email: v),
              ),
              const Divider(),
            ],
          ],
        ),
      ),
    );
  }
}
