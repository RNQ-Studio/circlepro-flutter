import 'package:features_shared/features_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../scoring/domain/scoring_entities.dart';
import '../../../scoring/presentation/widgets/arrow_slots.dart';
import '../../../scoring/presentation/widgets/score_pad.dart';
import '../../../scoring/utils/ulid.dart';
import '../../domain/board_participant_entity.dart';
import '../../domain/group_entities.dart';
import '../group_scoring_providers.dart';
import '../group_scoring_routes.dart';

/// Self-scoring within a Latihan Bersama (Sprint 10, tasks 10.2–10.4).
///
/// "Setelah masuk, Andi mencatat dirinya sendiri." This reuses the familiar
/// solo score-entry vocabulary — the [ScorePad] and [ArrowSlots] widgets from
/// `score_input_screen` — but writes through the *group's* offline-first board
/// controller so the score merges into the group (synced via the group endpoint)
/// and, because the row is owned (binder model §1), enriches the member's own
/// progress chart & PB. Each arrow lands in local Drift immediately (crash-safe)
/// and a push is kicked once the end is complete (sparing the field radio).
///
/// Why not literally reuse the solo `score_input_screen`? It is bound to the
/// solo `activeScoringProvider`/repository, whose sync deliberately *excludes*
/// group rows (they belong to the group endpoint). Reusing the solo screen would
/// route the self score to the wrong endpoint; reusing its widgets instead keeps
/// the UX identical while the score flows into the group.
class SelfScoringScreen extends ConsumerStatefulWidget {
  const SelfScoringScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<SelfScoringScreen> createState() => _SelfScoringScreenState();
}

class _SelfScoringScreenState extends ConsumerState<SelfScoringScreen> {
  /// 1-based round currently being edited.
  int _currentEnd = 1;
  bool _leaving = false;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(hostBoardControllerProvider(widget.groupId));
    final authState = ref.watch(authProvider);
    final currentUserId =
        authState is AuthAuthenticated ? authState.user.id : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catat Skorku'),
        actions: [
          async.maybeWhen(
            data: (state) => _SyncStatusChip(
              pending: state.pendingSyncCount,
              onTap: () => ref
                  .read(hostBoardControllerProvider(widget.groupId).notifier)
                  .syncNow(),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          IconButton(
            tooltip: 'Papan peringkat',
            icon: const Icon(Icons.leaderboard),
            onPressed: async.hasValue
                ? () =>
                    context.push(GroupScoringRoutes.leaderboard(widget.groupId))
                : null,
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _SelfError(message: '$e'),
        data: (state) {
          final self = _findSelf(state.participants, currentUserId);
          if (self == null) {
            return const _NotJoined();
          }
          return _ScoringView(
            group: state.group,
            self: self,
            currentEnd: _currentEnd.clamp(1, state.group.numEnds),
            leaving: _leaving,
            onSelectEnd: (e) => setState(() => _currentEnd = e),
            onArrow: (key) => _enterArrow(state.group, self, key),
            onUndo: () => _undo(state.group, self),
            onFinish: () => _finish(context),
            onLeave: () => _confirmLeave(context, self),
          );
        },
      ),
    );
  }

  /// My own row: the owned participant whose user matches the signed-in user.
  BoardParticipant? _findSelf(
    List<BoardParticipant> participants,
    String? currentUserId,
  ) {
    if (currentUserId == null) return null;
    for (final p in participants) {
      if (p.userId != null && p.userId.toString() == currentUserId) return p;
    }
    return null;
  }

  Future<void> _enterArrow(
    ScoringGroupEntity group,
    BoardParticipant self,
    ScoreKey key,
  ) async {
    final end = _currentEnd.clamp(1, group.numEnds);
    final existing = self.arrowsForEnd(end);
    if (existing.length >= group.arrowsPerEnd) return; // end already full

    SystemSound.play(SystemSoundType.click);
    if (key.isX || key.value == 10) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.selectionClick();
    }

    final arrows = [
      ...existing,
      ArrowScore(
        id: Ids.ulid(),
        arrowIndex: existing.length,
        scoreValue: key.isMiss ? 0 : key.value,
        isX: key.isX,
        isMiss: key.isMiss,
      ),
    ];
    final endComplete = arrows.length >= group.arrowsPerEnd;

    // Persist every arrow locally (crash-safe); push only on a complete end so a
    // bad field signal isn't hammered once per tap (sync flag).
    await ref
        .read(hostBoardControllerProvider(widget.groupId).notifier)
        .saveEnd(end, {self.id: arrows}, sync: endComplete);

    // Follow the solo flow: roll to the next round once this one is full.
    if (endComplete && end < group.numEnds && mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      if (mounted) setState(() => _currentEnd = end + 1);
    }
  }

  Future<void> _undo(ScoringGroupEntity group, BoardParticipant self) async {
    final end = _currentEnd.clamp(1, group.numEnds);
    final existing = self.arrowsForEnd(end);
    if (existing.isEmpty) return;
    HapticFeedback.selectionClick();
    final arrows = existing.sublist(0, existing.length - 1);
    await ref
        .read(hostBoardControllerProvider(widget.groupId).notifier)
        .saveEnd(end, {self.id: arrows}, sync: false);
  }

  Future<void> _finish(BuildContext context) async {
    // Force a final push so the completed session reaches the group + backend
    // (which awards PB/gamification for an owned, completed row).
    await ref
        .read(hostBoardControllerProvider(widget.groupId).notifier)
        .syncNow();
    if (!context.mounted) return;
    context.pushReplacement(GroupScoringRoutes.leaderboard(widget.groupId));
  }

  Future<void> _confirmLeave(
      BuildContext context, BoardParticipant self) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari sesi?'),
        content: const Text(
          'Baris skormu akan dihapus dari sesi ini. Kamu bisa gabung lagi '
          'lewat tautan/kode bila berubah pikiran.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: ManahColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    setState(() => _leaving = true);
    try {
      await ref
          .read(hostBoardControllerProvider(widget.groupId).notifier)
          .leave(self.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamu keluar dari sesi.')),
      );
      context.go(GroupScoringRoutes.list);
    } catch (e) {
      if (mounted) setState(() => _leaving = false);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal keluar. Periksa koneksi lalu coba lagi.'),
        ),
      );
    }
  }
}

class _ScoringView extends StatelessWidget {
  const _ScoringView({
    required this.group,
    required this.self,
    required this.currentEnd,
    required this.leaving,
    required this.onSelectEnd,
    required this.onArrow,
    required this.onUndo,
    required this.onFinish,
    required this.onLeave,
  });

  final ScoringGroupEntity group;
  final BoardParticipant self;
  final int currentEnd;
  final bool leaving;
  final ValueChanged<int> onSelectEnd;
  final ValueChanged<ScoreKey> onArrow;
  final VoidCallback onUndo;
  final VoidCallback onFinish;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final endArrows = self.arrowsForEnd(currentEnd);
    final isComplete = self.arrowsShot >= group.plannedArrows;
    final endTotal = endArrows.fold<int>(0, (s, a) => s + a.scoreValue);
    final maxPossible = group.plannedArrows * 10;
    final avg = self.arrowsShot == 0
        ? null
        : (self.totalScore / self.arrowsShot).toStringAsFixed(2);

    return SafeArea(
      child: Column(
        children: [
          LinearProgressIndicator(
            value: group.plannedArrows == 0
                ? 0
                : self.arrowsShot / group.plannedArrows,
            minHeight: 4,
            backgroundColor: ManahColors.brandSurface,
          ),
          // The binder reassurance (task 10.3): this still counts for *you*.
          const _CountsForYouBanner(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ManahSpacing.base,
              vertical: ManahSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TOTAL', style: theme.textTheme.labelSmall),
                    Text('${self.totalScore} / $maxPossible',
                        style: theme.textTheme.headlineMedium),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('AVG / PANAH', style: theme.textTheme.labelSmall),
                    Text(avg ?? '–', style: theme.textTheme.headlineSmall),
                  ],
                ),
              ],
            ),
          ),
          _EndStrip(
            currentEnd: currentEnd,
            numEnds: group.numEnds,
            shotEnds: {
              for (var e = 1; e <= group.numEnds; e++)
                if (self.arrowsForEnd(e).isNotEmpty) e,
            },
            onSelect: onSelectEnd,
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(ManahSpacing.base),
            child: Column(
              children: [
                ArrowSlots(arrows: endArrows, capacity: group.arrowsPerEnd),
                const SizedBox(height: ManahSpacing.sm),
                Text('Total Ronde: $endTotal',
                    style: theme.textTheme.titleMedium),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.sm),
            child: ScorePad(
              onScore: onArrow,
              onUndo: onUndo,
              undoEnabled: endArrows.isNotEmpty,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(ManahSpacing.base),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: leaving ? null : onLeave,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ManahColors.error,
                      side: const BorderSide(color: ManahColors.error),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Keluar'),
                  ),
                ),
                const SizedBox(width: ManahSpacing.md),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onFinish,
                    icon: Icon(isComplete ? Icons.check_circle : Icons.flag),
                    label: Text(isComplete ? 'Lihat Hasil' : 'Selesai'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The honest, gentle reminder (task 10.3): a self session in a group is still
/// the member's own session — it enriches their personal progress & PB.
class _CountsForYouBanner extends StatelessWidget {
  const _CountsForYouBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
          ManahSpacing.base, ManahSpacing.sm, ManahSpacing.base, 0),
      padding: const EdgeInsets.symmetric(
          horizontal: ManahSpacing.base, vertical: ManahSpacing.sm),
      decoration: BoxDecoration(
        color: ManahColors.brandSurface,
        borderRadius: BorderRadius.circular(ManahRadius.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.insights, size: 18, color: ManahColors.brand),
          const SizedBox(width: ManahSpacing.sm),
          Expanded(
            child: Text(
              'Skor ini tetap dihitung untuk progres & rekor pribadimu.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: ManahColors.brand),
            ),
          ),
        ],
      ),
    );
  }
}

/// Round chips — one tap jumps to any round to correct a past one (task 10.2).
/// A shot round carries a ✓.
class _EndStrip extends StatelessWidget {
  const _EndStrip({
    required this.currentEnd,
    required this.numEnds,
    required this.shotEnds,
    required this.onSelect,
  });

  final int currentEnd;
  final int numEnds;
  final Set<int> shotEnds;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: ManahSpacing.base, vertical: ManahSpacing.sm),
        itemCount: numEnds,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final end = i + 1;
          final isActive = end == currentEnd;
          final isShot = shotEnds.contains(end);
          return ChoiceChip(
            selected: isActive,
            selectedColor: ManahColors.brand,
            showCheckmark: false,
            onSelected: (_) => onSelect(end),
            avatar: isShot
                ? Icon(Icons.check_circle,
                    size: 16,
                    color: isActive ? Colors.white : ManahColors.success)
                : null,
            label: Text(
              'R$end',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : null,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SyncStatusChip extends StatelessWidget {
  const _SyncStatusChip({required this.pending, required this.onTap});

  final int pending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final synced = pending == 0;
    final color = synced ? ManahColors.success : ManahColors.amberDeep;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ManahSpacing.sm),
      child: InkWell(
        onTap: synced ? null : onTap,
        borderRadius: BorderRadius.circular(ManahRadius.full),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(ManahRadius.full),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(synced ? Icons.cloud_done : Icons.cloud_upload,
                  size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                synced ? 'Tersinkron' : 'Lokal ($pending)',
                style: TextStyle(
                    color: color, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotJoined extends StatelessWidget {
  const _NotJoined();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_off_outlined,
                size: 56, color: ManahColors.mediumGrey),
            const SizedBox(height: ManahSpacing.base),
            Text('Kamu belum tergabung di sesi ini',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: ManahSpacing.xs),
            Text(
              'Buka tautan atau pindai QR sesi, lalu tekan "Gabung".',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.textTheme.bodySmall?.color),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelfError extends StatelessWidget {
  const _SelfError({required this.message});

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
