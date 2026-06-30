import 'package:features_shared/features_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../scoring/domain/scoring_enums.dart';
import '../../domain/board_participant_entity.dart';
import '../../domain/group_entities.dart';
import '../group_invite_share.dart';
import '../group_scoring_providers.dart';
import '../group_scoring_routes.dart';
import '../widgets/add_participant_sheet.dart';

/// Session hub for a Latihan Bersama (Sprint 06) — the make-or-break screen
/// that decides whether the first session happens.
///
/// When the roster is empty it offers exactly **two big actions** ("Bagikan
/// ajakan" + "Tambah pemain"), so there is no three-second hesitation that
/// sends the host back to the wooden board (task 6.3). Once players are in, it
/// shows a **roster card per participant with their running score** (task 6.4);
/// tapping one opens the host board focused on that archer.
///
/// It reuses [hostBoardControllerProvider] so the running totals are the very
/// same offline-first figures the board records — one source of truth.
class GroupDetailScreen extends ConsumerWidget {
  const GroupDetailScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(hostBoardControllerProvider(groupId));
    final authState = ref.watch(authProvider);
    final currentUserId =
        authState is AuthAuthenticated ? authState.user.id : null;

    final group = async.value?.group;
    final isHostAppBar = group != null &&
        currentUserId != null &&
        currentUserId == group.hostUserId.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(group?.titleOrDefault ?? 'Sesi Latihan'),
        actions: [
          if (isHostAppBar)
            IconButton(
              tooltip: 'Klaim Masuk',
              onPressed: () =>
                  context.push(GroupScoringRoutes.claims(group.id)),
              icon: const Icon(Icons.how_to_reg),
            ),
          if (group != null)
            IconButton(
              tooltip: 'QR Undangan',
              onPressed: () => context.push(GroupScoringRoutes.qr(group.id)),
              icon: const Icon(Icons.qr_code_2),
            ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _DetailError(message: '$e'),
        data: (state) {
          final group = state.group;
          final participants = state.participants;
          final isHost = currentUserId != null &&
              currentUserId == group.hostUserId.toString();
          // A joined (non-host) member gets a direct path back to their own
          // scorecard (Sprint 10) — they score themselves, not the whole roster.
          final selfRow = currentUserId == null
              ? null
              : participants
                  .where((p) =>
                      p.userId != null && p.userId.toString() == currentUserId)
                  .firstOrNull;
          return ListView(
            padding: const EdgeInsets.all(ManahSpacing.base),
            children: [
              _FormatSummary(group: group),
              const SizedBox(height: ManahSpacing.lg),
              if (!isHost && selfRow != null) ...[
                FilledButton.icon(
                  onPressed: () =>
                      context.push(GroupScoringRoutes.selfScoring(group.id)),
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Catat Skorku'),
                ),
                const SizedBox(height: ManahSpacing.lg),
              ],
              if (participants.isEmpty)
                _EmptyRosterCoaching(
                  onShare: () => shareGroupInvite(group),
                  onAdd: () => _addPlayers(context, ref),
                )
              else
                _RosterSection(
                  group: group,
                  participants: participants,
                  onTapParticipant: (p) => context.push(
                    GroupScoringRoutes.board(group.id, participantId: p.id),
                  ),
                  onChangeDistance: (p) =>
                      _changeDistance(context, ref, group, p),
                  onShare: () => shareGroupInvite(group),
                  onAdd: () => _addPlayers(context, ref),
                  onOpenBoard: () =>
                      context.push(GroupScoringRoutes.board(group.id)),
                  onOpenButts: () =>
                      context.push(GroupScoringRoutes.butts(group.id)),
                  onOpenStatus: () =>
                      context.push(GroupScoringRoutes.buttStatus(group.id)),
                  onOpenLeaderboard: () =>
                      context.push(GroupScoringRoutes.leaderboard(group.id)),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addPlayers(BuildContext context, WidgetRef ref) async {
    final names = await showAddParticipantSheet(context);
    if (names == null || names.isEmpty || !context.mounted) return;
    await ref
        .read(hostBoardControllerProvider(groupId).notifier)
        .addGuests(names);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          names.length == 1
              ? '${names.first} ditambahkan ke papan.'
              : '${names.length} pemain ditambahkan ke papan.',
        ),
        backgroundColor: ManahColors.success,
      ),
    );
  }

  Future<void> _changeDistance(
    BuildContext context,
    WidgetRef ref,
    ScoringGroupEntity group,
    BoardParticipant participant,
  ) async {
    final choice =
        await showModalBottomSheet<({int distanceM, int? targetFaceCm})>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _DistanceOverrideSheet(
        initialDistanceM: participant.distanceM ?? group.distanceM,
        initialTargetFaceCm: participant.targetFaceCm ?? group.targetFaceCm,
      ),
    );
    if (choice == null || !context.mounted) return;

    try {
      await ref.read(groupScoringRepositoryProvider).assignParticipantDistance(
            group.id,
            participant.id,
            distanceM: choice.distanceM,
            targetFaceCm: choice.targetFaceCm,
          );
      ref.invalidate(hostBoardControllerProvider(group.id));
      ref.invalidate(buttStatusControllerProvider(group.id));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jarak peserta diperbarui.'),
          backgroundColor: ManahColors.success,
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jarak tidak bisa diubah setelah skor masuk.'),
          backgroundColor: ManahColors.error,
        ),
      );
    }
  }

  // Share is link-first now (Sprint 09): an HTTPS invite that opens the preview
  // straight from WhatsApp, with the typed code as a fallback (see
  // [shareGroupInvite]).
}

/// Small extension so detail/board share one default title.
extension on ScoringGroupEntity {
  String get titleOrDefault =>
      title?.isNotEmpty == true ? title! : 'Latihan Bersama';
}

class _FormatSummary extends StatelessWidget {
  const _FormatSummary({required this.group});

  final ScoringGroupEntity group;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: ManahColors.brandSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManahRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.base),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.sports_score, color: ManahColors.brand),
            ),
            const SizedBox(width: ManahSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${group.roundPresetLabel ?? '${group.distanceM} m'} · '
                    '${group.countedEndCount}×${group.arrowsPerEnd} · '
                    '${group.environment.label}',
                    style: ManahTextStyles.bodyM
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Kode gabung: ${group.joinCode}',
                    style: ManahTextStyles.bodyS
                        .copyWith(color: ManahColors.mediumGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty roster (task 6.3) — two big, warm coaching actions, nothing else.
class _EmptyRosterCoaching extends StatelessWidget {
  const _EmptyRosterCoaching({required this.onShare, required this.onAdd});

  final VoidCallback onShare;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: ManahSpacing.lg),
        Icon(Icons.groups_2_outlined, size: 72, color: ManahColors.brandLight),
        const SizedBox(height: ManahSpacing.base),
        Text(
          'Papan masih kosong',
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: ManahSpacing.xs),
        Text(
          'Ajak teman selatihan, atau catat sendiri nama mereka. '
          'Beberapa ketukan saja dan papan siap secepat kertas.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.textTheme.bodySmall?.color),
        ),
        const SizedBox(height: ManahSpacing.xl),
        _BigActionCard(
          icon: Icons.ios_share,
          title: 'Bagikan ajakan',
          subtitle: 'Kirim kode gabung lewat WhatsApp/grup',
          onTap: onShare,
        ),
        const SizedBox(height: ManahSpacing.base),
        _BigActionCard(
          icon: Icons.person_add_alt_1,
          title: 'Tambah pemain',
          subtitle: 'Ketik nama satu per satu — kelas busur menyusul',
          filled: true,
          onTap: onAdd,
        ),
      ],
    );
  }
}

class _BigActionCard extends StatelessWidget {
  const _BigActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = filled ? ManahColors.brand : theme.cardColor;
    final fg = filled ? Colors.white : ManahColors.brand;
    final subFg = filled ? Colors.white70 : theme.textTheme.bodySmall?.color;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ManahRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(ManahSpacing.lg),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(ManahRadius.lg),
          border: Border.all(
            color: filled
                ? ManahColors.brand
                : ManahColors.brandLight.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor:
                  filled ? Colors.white24 : ManahColors.brandSurface,
              child: Icon(icon, color: fg, size: 26),
            ),
            const SizedBox(width: ManahSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold, color: fg),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(color: subFg),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: fg),
          ],
        ),
      ),
    );
  }
}

class _RosterSection extends StatelessWidget {
  const _RosterSection({
    required this.group,
    required this.participants,
    required this.onTapParticipant,
    required this.onChangeDistance,
    required this.onShare,
    required this.onAdd,
    required this.onOpenBoard,
    required this.onOpenButts,
    required this.onOpenStatus,
    required this.onOpenLeaderboard,
  });

  final ScoringGroupEntity group;
  final List<BoardParticipant> participants;
  final ValueChanged<BoardParticipant> onTapParticipant;
  final ValueChanged<BoardParticipant> onChangeDistance;
  final VoidCallback onShare;
  final VoidCallback onAdd;
  final VoidCallback onOpenBoard;
  final VoidCallback onOpenButts;
  final VoidCallback onOpenStatus;
  final VoidCallback onOpenLeaderboard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Peserta (${participants.length})',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.person_add_alt_1, size: 18),
              label: const Text('Tambah'),
            ),
          ],
        ),
        const SizedBox(height: ManahSpacing.xs),
        for (final p in participants)
          Padding(
            padding: const EdgeInsets.only(bottom: ManahSpacing.sm),
            child: _RosterCard(
              group: group,
              participant: p,
              onTap: () => onTapParticipant(p),
              onChangeDistance:
                  p.arrowsShot == 0 ? () => onChangeDistance(p) : null,
            ),
          ),
        const SizedBox(height: ManahSpacing.base),
        OutlinedButton.icon(
          onPressed: onShare,
          icon: const Icon(Icons.ios_share),
          label: const Text('Bagikan ajakan'),
        ),
        const SizedBox(height: ManahSpacing.sm),
        OutlinedButton.icon(
          onPressed: onOpenStatus,
          icon: const Icon(Icons.speed_outlined),
          label: const Text('Monitor Bantalan'),
        ),
        const SizedBox(height: ManahSpacing.sm),
        FilledButton.icon(
          onPressed: onOpenButts,
          icon: const Icon(Icons.adjust),
          label: const Text('Pilih Bantalan'),
        ),
        const SizedBox(height: ManahSpacing.sm),
        OutlinedButton.icon(
          onPressed: onOpenLeaderboard,
          icon: const Icon(Icons.leaderboard),
          label: const Text('Papan Peringkat & Kartu Hasil'),
        ),
        const SizedBox(height: ManahSpacing.sm),
        OutlinedButton.icon(
          onPressed: onOpenBoard,
          icon: const Icon(Icons.sports_score),
          label: const Text('Buka Papan Skor'),
        ),
      ],
    );
  }
}

class _RosterCard extends StatelessWidget {
  const _RosterCard({
    required this.group,
    required this.participant,
    required this.onTap,
    required this.onChangeDistance,
  });

  final ScoringGroupEntity group;
  final BoardParticipant participant;
  final VoidCallback onTap;
  final VoidCallback? onChangeDistance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = participant.labelOr('Saya');
    final endsDone = participant.endsShot;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManahRadius.md),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.12)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: participant.isGuest
              ? ManahColors.lightGrey
              : ManahColors.brandSurface,
          child: participant.isGuest
              ? const Icon(Icons.person_outline, color: ManahColors.mediumGrey)
              : Text(
                  name.isNotEmpty ? name.characters.first.toUpperCase() : '?',
                  style: const TextStyle(
                      color: ManahColors.brand, fontWeight: FontWeight.bold),
                ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: ManahSpacing.xs),
            if (participant.isGuest)
              _Tag(label: 'Tamu', color: ManahColors.mediumGrey)
            else
              _Tag(label: 'Saya', color: ManahColors.brand),
            if (!participant.isSynced) ...[
              const SizedBox(width: ManahSpacing.xs),
              _Tag(label: 'Lokal', color: ManahColors.amberDeep),
            ],
            if (participant.targetButt != null) ...[
              const SizedBox(width: ManahSpacing.xs),
              _Tag(label: participant.targetLabel, color: ManahColors.brand),
            ],
          ],
        ),
        subtitle: Text(
          '${participant.distanceLabel} · $endsDone/${group.countedEndCount} rambahan · ${participant.arrowsShot} panah',
          style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${participant.totalScore}',
                  style: ManahTextStyles.h3.copyWith(color: ManahColors.brand),
                ),
                Text(
                  'total',
                  style: ManahTextStyles.bodyS.copyWith(
                    fontSize: 10,
                    color: ManahColors.mediumGrey,
                  ),
                ),
              ],
            ),
            if (onChangeDistance != null)
              IconButton(
                tooltip: 'Ubah jarak',
                icon: const Icon(Icons.straighten, size: 18),
                onPressed: onChangeDistance,
              ),
          ],
        ),
      ),
    );
  }
}

class _DistanceOverrideSheet extends StatefulWidget {
  const _DistanceOverrideSheet({
    required this.initialDistanceM,
    required this.initialTargetFaceCm,
  });

  final int initialDistanceM;
  final int? initialTargetFaceCm;

  @override
  State<_DistanceOverrideSheet> createState() => _DistanceOverrideSheetState();
}

class _DistanceOverrideSheetState extends State<_DistanceOverrideSheet> {
  late int _distanceM = widget.initialDistanceM;
  late int? _targetFaceCm = widget.initialTargetFaceCm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final distances = DistanceCategory.values.map((d) => d.meters).toList();
    final faces = {
      if (widget.initialTargetFaceCm != null) widget.initialTargetFaceCm!,
      122,
      80,
      60,
      40,
    }.toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          ManahSpacing.base,
          0,
          ManahSpacing.base,
          MediaQuery.of(context).viewInsets.bottom + ManahSpacing.base,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Jarak peserta',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: ManahSpacing.xs),
            Text(
              'Bisa diubah sebelum peserta punya skor.',
              style: ManahTextStyles.bodyS.copyWith(
                color: ManahColors.mediumGrey,
              ),
            ),
            const SizedBox(height: ManahSpacing.base),
            Wrap(
              spacing: ManahSpacing.xs,
              runSpacing: ManahSpacing.xs,
              children: [
                for (final distance in distances)
                  ChoiceChip(
                    label: Text('$distance m'),
                    selected: _distanceM == distance,
                    onSelected: (_) => setState(() => _distanceM = distance),
                  ),
              ],
            ),
            const SizedBox(height: ManahSpacing.base),
            Wrap(
              spacing: ManahSpacing.xs,
              runSpacing: ManahSpacing.xs,
              children: [
                for (final face in faces)
                  ChoiceChip(
                    label: Text('$face cm'),
                    selected: _targetFaceCm == face,
                    onSelected: (_) => setState(() => _targetFaceCm = face),
                  ),
              ],
            ),
            const SizedBox(height: ManahSpacing.lg),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(
                (distanceM: _distanceM, targetFaceCm: _targetFaceCm),
              ),
              icon: const Icon(Icons.check),
              label: const Text('Simpan Jarak'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(ManahRadius.full),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: ManahColors.error),
            const SizedBox(height: ManahSpacing.base),
            Text('Gagal memuat sesi.\n$message', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
