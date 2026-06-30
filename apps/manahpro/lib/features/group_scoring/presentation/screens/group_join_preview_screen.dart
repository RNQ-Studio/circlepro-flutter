import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:features_shared/features_shared.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../scoring/domain/scoring_enums.dart';
import '../../domain/group_entities.dart';
import '../group_invite_share.dart';
import '../group_scoring_providers.dart';
import '../group_scoring_routes.dart';
import '../widgets/claim_slots_section.dart';
import '../widgets/join_bow_class_sheet.dart';

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
              child:
                  const Icon(Icons.groups, color: ManahColors.brand, size: 36),
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
              side:
                  BorderSide(color: theme.dividerColor.withValues(alpha: 0.12)),
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
                        '${group.countedEndCount} ronde skor × ${group.arrowsPerEnd} panah',
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
          else if (currentUserId == null)
            // Signed out (e.g. a deferred deep link before login). The pending
            // join is resumed after auth (Sprint 09), so just nudge here.
            FilledButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Masuk dulu untuk bergabung ke sesi ini.'),
                ),
              ),
              icon: const Icon(Icons.login),
              label: const Text('Gabung Sesi'),
            )
          else ...[
            // Self-join only makes sense while the session is live; a finished
            // session is closed to joins (Sprint 10 gate). Claiming a past slot
            // still works either way (Sprint 14).
            if (group.status == ScoringSessionStatus.inProgress) ...[
              _SelfJoinButton(group: group),
              const SizedBox(height: ManahSpacing.lg),
            ],
            // The claim landing (task 14.1): guest slots highlighted, each with
            // a big "Ini Saya" — this is where Pak Budi lands from the card.
            ClaimSlotsSection(groupId: group.id),
            const SizedBox(height: ManahSpacing.lg),
          ],
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
}

/// The self-join CTA (Sprint 10, task 10.1). Offers an optional bow-class picker
/// (K8: never blocks joining), calls `POST /groups/{group}/join`, then lands the
/// member straight on their own offline-first scorecard. Idempotent server-side,
/// so a double-tap is safe.
class _SelfJoinButton extends ConsumerStatefulWidget {
  const _SelfJoinButton({required this.group});

  final ScoringGroupEntity group;

  @override
  ConsumerState<_SelfJoinButton> createState() => _SelfJoinButtonState();
}

class _SelfJoinButtonState extends ConsumerState<_SelfJoinButton> {
  bool _joining = false;

  Future<void> _join() async {
    final choice = await showJoinBowClassSheet(
      context,
      defaultDistanceM: widget.group.distanceM,
      defaultTargetFaceCm: widget.group.targetFaceCm,
    );
    if (choice == null || !choice.confirmed || !mounted) return;

    setState(() => _joining = true);
    try {
      await ref.read(groupScoringRepositoryProvider).joinGroup(
            widget.group.id,
            bowClass: choice.bowClass,
            distanceM: choice.distanceM,
            targetFaceCm: choice.targetFaceCm,
          );
      if (!mounted) return;
      // Land on my own scorecard — "join → catat sendiri" (narrative).
      context.pushReplacement(
        GroupScoringRoutes.selfScoring(widget.group.id),
      );
    } catch (e) {
      if (mounted) setState(() => _joining = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal bergabung. Periksa koneksi lalu coba lagi.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: _joining ? null : _join,
      icon: _joining
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.login),
      label: Text(_joining ? 'Bergabung…' : 'Gabung Sesi'),
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
            const Icon(Icons.search_off,
                size: 56, color: ManahColors.mediumGrey),
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
