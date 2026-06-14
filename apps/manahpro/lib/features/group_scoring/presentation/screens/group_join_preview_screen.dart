import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:features_shared/features_shared.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/group_entities.dart';
import '../group_invite_share.dart';
import '../group_scoring_providers.dart';
import '../group_scoring_routes.dart';

/// Rich join preview (Sprint 09, task 9.2) — the single destination every entry
/// point (deep link, QR, typed code) funnels to. It reads the full round format
/// via `lookup` so an archer knows *which bow to bring* before joining.
///
/// The actual self-join action lands in Sprint 10; here the host gets a working
/// "open" shortcut and everyone else sees the format + the invite tools.
class GroupJoinPreviewScreen extends ConsumerWidget {
  const GroupJoinPreviewScreen({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(joinPreviewProvider(code));

    return Scaffold(
      appBar: AppBar(title: const Text('Pratinjau Sesi')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _PreviewError(code: code),
        data: (group) => _PreviewBody(group: group, code: code),
      ),
    );
  }
}

class _PreviewBody extends ConsumerWidget {
  const _PreviewBody({required this.group, required this.code});

  final ScoringGroupEntity group;
  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final currentUserId =
        authState is AuthAuthenticated ? authState.user.id : null;
    final isHost =
        currentUserId != null && currentUserId == group.hostUserId.toString();
    final title =
        group.title?.isNotEmpty == true ? group.title! : 'Latihan Bersama';

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(ManahSpacing.base),
        children: [
          const SizedBox(height: ManahSpacing.base),
          Center(
            child: CircleAvatar(
              radius: 32,
              backgroundColor: ManahColors.brandSurface,
              child: const Icon(Icons.groups, color: ManahColors.brand, size: 36),
            ),
          ),
          const SizedBox(height: ManahSpacing.base),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: ManahSpacing.xs),
          Text(
            '${group.hostName ?? 'Host'} mengundangmu · ${group.participantCount} peserta',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.textTheme.bodySmall?.color),
          ),
          const SizedBox(height: ManahSpacing.lg),

          // Round format — so the archer knows which bow to bring (task 9.2).
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ManahRadius.md),
              side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.12)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(ManahSpacing.base),
              child: Column(
                children: [
                  _Row(label: 'Jarak', value: '${group.distanceM} m'),
                  _Row(label: 'Lingkungan', value: group.environment.label),
                  _Row(
                    label: 'Format',
                    value:
                        '${group.numEnds} ronde × ${group.arrowsPerEnd} panah',
                  ),
                  _Row(
                    label: 'Target Face',
                    value: group.targetFaceCm != null
                        ? '${group.targetFaceCm} cm'
                        : '—',
                  ),
                  _Row(label: 'Kode Gabung', value: group.joinCode),
                ],
              ),
            ),
          ),
          const SizedBox(height: ManahSpacing.lg),

          if (isHost)
            FilledButton.icon(
              onPressed: () => context.go(GroupScoringRoutes.detail(group.id)),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Buka Sesi Ini'),
            )
          else
            FilledButton.icon(
              // Self-join lands in Sprint 10 (POST /groups/{group}/join). Until
              // then the preview is the funnel; we tell the user the next step
              // honestly rather than wiring a dead button.
              onPressed: () => _joinComingSoon(context),
              icon: const Icon(Icons.login),
              label: const Text('Gabung Sesi'),
            ),
          const SizedBox(height: ManahSpacing.sm),
          OutlinedButton.icon(
            onPressed: () => _copyCode(context),
            icon: const Icon(Icons.copy),
            label: const Text('Salin Kode'),
          ),
          const SizedBox(height: ManahSpacing.sm),
          TextButton.icon(
            onPressed: () => shareGroupInvite(group),
            icon: const Icon(Icons.ios_share),
            label: const Text('Bagikan Undangan'),
          ),
        ],
      ),
    );
  }

  Future<void> _copyCode(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: group.joinCode));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode disalin')),
      );
    }
  }

  void _joinComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Gabung mandiri aktif sebentar lagi. Untuk kini, minta host '
          'menambahkanmu atau bagikan kode ini.',
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ManahSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.textTheme.bodySmall?.color)),
          Text(value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _PreviewError extends StatelessWidget {
  const _PreviewError({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 56, color: ManahColors.mediumGrey),
            const SizedBox(height: ManahSpacing.base),
            Text(
              'Sesi tidak ditemukan',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: ManahSpacing.xs),
            Text(
              'Kode "$code" tidak valid atau sesinya sudah berakhir. '
              'Minta host membagikan tautan terbaru.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: ManahColors.mediumGrey),
            ),
          ],
        ),
      ),
    );
  }
}
