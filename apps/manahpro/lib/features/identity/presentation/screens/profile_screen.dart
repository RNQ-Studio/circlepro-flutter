import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/routes/social_routes.dart';
import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/profile_entity.dart';
import '../profile_providers.dart';

/// ManahPro athlete profile (task 2.3): avatar, identity, stats and bow setup.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(SocialRoutes.editProfile),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(ManahSpacing.xl),
            child: Text('Gagal memuat profil (butuh login & koneksi).\n$e', textAlign: TextAlign.center),
          ),
        ),
        data: (p) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(myProfileProvider),
          child: ListView(
            padding: const EdgeInsets.all(ManahSpacing.base),
            children: [_Header(profile: p), const SizedBox(height: ManahSpacing.lg), _StatsRow(stats: p.stats)],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.profile});
  final ProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = [profile.city, profile.province].whereType<String>().where((s) => s.isNotEmpty).join(', ');

    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: ManahColors.brandSurface,
          backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
          child: profile.avatarUrl == null
              ? const Icon(Icons.person, size: 44, color: ManahColors.brand)
              : null,
        ),
        const SizedBox(height: ManahSpacing.md),
        Text(profile.displayName, style: theme.textTheme.headlineSmall),
        if (profile.username != null)
          Text('@${profile.username}', style: theme.textTheme.bodyMedium?.copyWith(color: ManahColors.mediumGrey)),
        if (profile.bio != null && profile.bio!.isNotEmpty) ...[
          const SizedBox(height: ManahSpacing.sm),
          Text(profile.bio!, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: ManahSpacing.sm),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: ManahSpacing.sm,
          children: [
            if (profile.primaryBowClass != null)
              Chip(
                avatar: const Icon(Icons.sports, size: 16, color: ManahColors.brand),
                label: Text(profile.primaryBowClass!.label),
              ),
            if (location.isNotEmpty)
              Chip(avatar: const Icon(Icons.place_outlined, size: 16), label: Text(location)),
          ],
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});
  final ProfileStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(label: 'Sesi', value: '${stats.totalSessions}'),
        _Stat(label: 'Panah', value: '${stats.totalArrows}'),
        _Stat(label: 'PB', value: '${stats.personalBests}'),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: ManahSpacing.xs),
        padding: const EdgeInsets.symmetric(vertical: ManahSpacing.base),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(ManahRadius.md),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Text(value, style: theme.textTheme.titleLarge),
            Text(label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
