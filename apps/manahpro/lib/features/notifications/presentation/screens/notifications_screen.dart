import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/routes/social_routes.dart';
import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/notification_entity.dart';
import '../notifications_providers.dart';

/// In-app notification center (task 2.6): list, mark read, deep-link, prefs.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        actions: [
          IconButton(
            tooltip: 'Tandai semua dibaca',
            icon: const Icon(Icons.done_all),
            onPressed: () => ref.read(notificationsProvider.notifier).markAllRead(),
          ),
          IconButton(
            tooltip: 'Preferensi',
            icon: const Icon(Icons.tune),
            onPressed: () => context.push(SocialRoutes.notificationPrefs),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(ManahSpacing.xl),
            child: Text('Gagal memuat (butuh login & koneksi).\n$e', textAlign: TextAlign.center),
          ),
        ),
        data: (items) => items.isEmpty
            ? const Center(child: Text('Belum ada notifikasi.'))
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(notificationsProvider),
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) => _NotificationTile(notification: items[i]),
                ),
              ),
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.notification});
  final NotificationEntity notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: notification.isRead
          ? null
          : () => ref.read(notificationsProvider.notifier).markRead(notification.id),
      leading: CircleAvatar(
        backgroundColor: notification.isRead ? Theme.of(context).dividerColor.withValues(alpha: 0.2) : ManahColors.brandSurface,
        child: Icon(
          Icons.notifications,
          color: notification.isRead ? ManahColors.mediumGrey : ManahColors.brand,
          size: 20,
        ),
      ),
      title: Text(
        notification.title ?? 'Notifikasi',
        style: TextStyle(fontWeight: notification.isRead ? FontWeight.w400 : FontWeight.w700),
      ),
      subtitle: notification.body != null ? Text(notification.body!) : null,
      trailing: notification.isRead
          ? null
          : const Icon(Icons.circle, size: 10, color: ManahColors.brand),
    );
  }
}
