import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../scoring/domain/scoring_entities.dart';
import '../../../scoring/utils/ulid.dart';
import '../../domain/board_participant_entity.dart';
import '../group_scoring_providers.dart';

/// The **host board** (Sprint 05) — the hero flow: one screen, every
/// participant visible, scored *end-by-end following the whistle*. Generalized
/// from `multi_archer_scorer_screen` (events): the round format is dynamic
/// (honours the group's `arrows_per_end`/`num_ends`, so indoor 3-arrow and
/// outdoor 6-arrow are both correct), guests are first-class (keyed by session
/// id, not `user_id`), and every "Simpan Rambahan" lands offline-first in Drift
/// then syncs in the background — never blocking on a dead signal (K2).
class HostBoardScreen extends ConsumerStatefulWidget {
  const HostBoardScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<HostBoardScreen> createState() => _HostBoardScreenState();
}

/// A single arrow being entered for the current end (before "Simpan Rambahan").
class _ArrowInput {
  _ArrowInput({this.value, this.isX = false, this.isMiss = false});

  int? value; // null = empty slot
  bool isX;
  bool isMiss;

  bool get isFilled => value != null;

  String get display {
    if (!isFilled) return '';
    if (isMiss) return 'M';
    if (isX) return 'X';
    return '$value';
  }
}

class _HostBoardScreenState extends ConsumerState<HostBoardScreen> {
  int _currentEnd = 1;
  int _activeIndex = 0;
  int _activeArrowIndex = 0;
  bool _isSaving = false;

  /// Scores for the *current* end, keyed by participant session id.
  final Map<String, List<_ArrowInput>> _temp = {};
  int? _seededEnd;
  Set<String> _seededIds = const {};

  /// Rebuild the per-end input buffer from stored arrows whenever the end or
  /// the roster changes (so navigating to a past end shows what's there).
  void _seedTemp(List<BoardParticipant> participants, int arrowsPerEnd) {
    final ids = participants.map((p) => p.id).toSet();
    if (_seededEnd == _currentEnd &&
        _seededIds.containsAll(ids) &&
        ids.containsAll(_seededIds)) {
      return;
    }
    _temp.clear();
    for (final p in participants) {
      final existing = p.arrowsForEnd(_currentEnd);
      _temp[p.id] = List.generate(arrowsPerEnd, (i) {
        if (i < existing.length) {
          final a = existing[i];
          return _ArrowInput(
            value: a.isMiss ? 0 : a.scoreValue,
            isX: a.isX,
            isMiss: a.isMiss,
          );
        }
        return _ArrowInput();
      });
    }
    _seededEnd = _currentEnd;
    _seededIds = ids;
    if (_activeIndex >= participants.length) _activeIndex = 0;
    _activeArrowIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(hostBoardControllerProvider(widget.groupId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Papan Skor'),
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
            tooltip: 'Tambah pemanah',
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: async.hasValue ? _promptAddGuest : null,
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _BoardError(message: '$e'),
        data: (state) {
          final group = state.group;
          final participants = state.participants;
          if (participants.isEmpty) {
            return _EmptyRoster(onAdd: _promptAddGuest);
          }

          _seedTemp(participants, group.arrowsPerEnd);
          final active = participants[_activeIndex];
          final activeScores = _temp[active.id]!;

          return Column(
            children: [
              _EndSelector(
                currentEnd: _currentEnd,
                numEnds: group.numEnds,
                onPrev: _currentEnd > 1
                    ? () => setState(() => _currentEnd--)
                    : null,
                onNext: _currentEnd < group.numEnds
                    ? () => setState(() => _currentEnd++)
                    : null,
              ),
              const Divider(height: 1),
              _ParticipantTabs(
                participants: participants,
                activeIndex: _activeIndex,
                temp: _temp,
                onSelect: (i) => setState(() {
                  _activeIndex = i;
                  _activeArrowIndex = 0;
                }),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(ManahSpacing.base),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${active.labelOr('Saya')} — Rambahan $_currentEnd',
                        style: ManahTextStyles.h3.copyWith(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      if (active.isGuest)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Tamu · tidak menambah statistik pribadi siapa pun',
                            textAlign: TextAlign.center,
                            style: ManahTextStyles.bodyS
                                .copyWith(color: ManahColors.mediumGrey),
                          ),
                        ),
                      const SizedBox(height: ManahSpacing.base),
                      _ArrowSlots(
                        scores: activeScores,
                        activeArrowIndex: _activeArrowIndex,
                        onTap: (i) => setState(() => _activeArrowIndex = i),
                      ),
                      const SizedBox(height: ManahSpacing.lg),
                      _BoardNumpad(
                        onKey: _onKeyTapped,
                        onBackspace: _onBackspace,
                      ),
                      const SizedBox(height: ManahSpacing.lg),
                      FilledButton.icon(
                        onPressed: _isSaving
                            ? null
                            : () => _saveEnd(participants, group.arrowsPerEnd),
                        icon: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.save),
                        label: Text(_isSaving
                            ? 'Menyimpan…'
                            : 'Simpan Rambahan $_currentEnd'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── Numpad interaction (highest→lowest reading order, task 5.4) ─────────

  void _onKeyTapped(int value, {required bool isX, required bool isMiss}) {
    final async = ref.read(hostBoardControllerProvider(widget.groupId));
    final state = async.value;
    if (state == null) return;
    final participants = state.participants;
    final active = participants[_activeIndex];
    final scores = _temp[active.id]!;

    setState(() {
      scores[_activeArrowIndex]
        ..value = value
        ..isX = isX
        ..isMiss = isMiss;

      // Advance to next arrow, then to the next participant (mirror the paper
      // sweep: finish an archer, move to the next).
      if (_activeArrowIndex < scores.length - 1) {
        _activeArrowIndex++;
      } else if (_activeIndex < participants.length - 1) {
        _activeIndex++;
        _activeArrowIndex = 0;
      }
    });
  }

  void _onBackspace() {
    final async = ref.read(hostBoardControllerProvider(widget.groupId));
    final state = async.value;
    if (state == null) return;
    final participants = state.participants;
    final active = participants[_activeIndex];
    final scores = _temp[active.id]!;

    setState(() {
      if (scores[_activeArrowIndex].isFilled) {
        scores[_activeArrowIndex] = _ArrowInput();
      } else if (_activeArrowIndex > 0) {
        _activeArrowIndex--;
        scores[_activeArrowIndex] = _ArrowInput();
      } else if (_activeIndex > 0) {
        _activeIndex--;
        _activeArrowIndex = _temp[participants[_activeIndex].id]!.length - 1;
        _temp[participants[_activeIndex].id]![_activeArrowIndex] =
            _ArrowInput();
      }
    });
  }

  // ─── Save the current round across every participant (offline-first) ─────

  Future<void> _saveEnd(
    List<BoardParticipant> participants,
    int arrowsPerEnd,
  ) async {
    // Validate: every participant must have a full end before "Simpan".
    for (final p in participants) {
      final scores = _temp[p.id]!;
      if (scores.any((a) => !a.isFilled)) {
        _snack(
          'Lengkapi skor ${p.labelOr('Saya')} dulu sebelum simpan.',
          ManahColors.warning,
        );
        return;
      }
    }

    setState(() => _isSaving = true);

    final arrowsByParticipantId = <String, List<ArrowScore>>{};
    for (final p in participants) {
      final scores = _temp[p.id]!;
      arrowsByParticipantId[p.id] = [
        for (var i = 0; i < scores.length; i++)
          ArrowScore(
            id: Ids.ulid(),
            arrowIndex: i,
            scoreValue: scores[i].isMiss ? 0 : (scores[i].value ?? 0),
            isX: scores[i].isX,
            isMiss: scores[i].isMiss,
          ),
      ];
    }

    try {
      await ref
          .read(hostBoardControllerProvider(widget.groupId).notifier)
          .saveEnd(_currentEnd, arrowsByParticipantId);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
    if (!mounted) return;

    // The save itself never fails on a dead network (it lands locally); only
    // the background sync may still be pending. Report it without alarm (5.5).
    final pending = ref
            .read(hostBoardControllerProvider(widget.groupId))
            .value
            ?.pendingSyncCount ??
        0;
    _snack(
      pending > 0
          ? 'Rambahan $_currentEnd tersimpan (lokal) — akan tersinkron otomatis.'
          : 'Rambahan $_currentEnd tersimpan & tersinkron.',
      pending > 0 ? ManahColors.brand : ManahColors.success,
    );

    // Advance to the next round, ready for the next whistle.
    final numEnds = ref
            .read(hostBoardControllerProvider(widget.groupId))
            .value
            ?.group
            .numEnds ??
        _currentEnd;
    if (_currentEnd < numEnds) {
      setState(() {
        _currentEnd++;
        _activeIndex = 0;
        _activeArrowIndex = 0;
      });
    }
  }

  // ─── Minimal guest add (Sprint 05) — full quick-add sheet is Sprint 06 ───

  Future<void> _promptAddGuest() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Pemanah'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Nama pemanah',
            hintText: 'mis. Andi',
          ),
          onSubmitted: (v) => Navigator.of(context).pop(v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (name == null || name.isEmpty || !mounted) return;
    await ref
        .read(hostBoardControllerProvider(widget.groupId).notifier)
        .addGuest(name);
  }

  void _snack(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}

class _EndSelector extends StatelessWidget {
  const _EndSelector({
    required this.currentEnd,
    required this.numEnds,
    required this.onPrev,
    required this.onNext,
  });

  final int currentEnd;
  final int numEnds;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: ManahSpacing.base, vertical: ManahSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Rambahan (End)',
              style:
                  ManahTextStyles.bodyM.copyWith(fontWeight: FontWeight.bold)),
          Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.chevron_left), onPressed: onPrev),
              Text('$currentEnd / $numEnds', style: ManahTextStyles.h3),
              IconButton(
                  icon: const Icon(Icons.chevron_right), onPressed: onNext),
            ],
          ),
        ],
      ),
    );
  }
}

class _ParticipantTabs extends StatelessWidget {
  const _ParticipantTabs({
    required this.participants,
    required this.activeIndex,
    required this.temp,
    required this.onSelect,
  });

  final List<BoardParticipant> participants;
  final int activeIndex;
  final Map<String, List<_ArrowInput>> temp;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
          horizontal: ManahSpacing.sm, vertical: ManahSpacing.sm),
      child: Row(
        children: [
          for (var i = 0; i < participants.length; i++)
            _ParticipantChip(
              participant: participants[i],
              isActive: i == activeIndex,
              endSubtotal: _subtotal(temp[participants[i].id]),
              onTap: () => onSelect(i),
            ),
        ],
      ),
    );
  }

  int _subtotal(List<_ArrowInput>? scores) {
    if (scores == null) return 0;
    return scores.fold(0, (sum, a) => sum + (a.isFilled ? (a.value ?? 0) : 0));
  }
}

class _ParticipantChip extends StatelessWidget {
  const _ParticipantChip({
    required this.participant,
    required this.isActive,
    required this.endSubtotal,
    required this.onTap,
  });

  final BoardParticipant participant;
  final bool isActive;
  final int endSubtotal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = participant.labelOr('Saya');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        selected: isActive,
        selectedColor: ManahColors.brand,
        onSelected: (_) => onTap(),
        label: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (participant.isGuest)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(Icons.person_outline,
                        size: 13,
                        color:
                            isActive ? Colors.white70 : ManahColors.mediumGrey),
                  ),
                Text(
                  name,
                  style: ManahTextStyles.bodyM.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? Colors.white
                        : theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
            Text(
              'Total ${participant.totalScore} · end $endSubtotal',
              style: ManahTextStyles.bodyS.copyWith(
                fontSize: 10,
                color: isActive ? Colors.white70 : ManahColors.brand,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArrowSlots extends StatelessWidget {
  const _ArrowSlots({
    required this.scores,
    required this.activeArrowIndex,
    required this.onTap,
  });

  final List<_ArrowInput> scores;
  final int activeArrowIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: ManahSpacing.sm,
      runSpacing: ManahSpacing.sm,
      children: [
        for (var i = 0; i < scores.length; i++)
          GestureDetector(
            onTap: () => onTap(i),
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: i == activeArrowIndex
                    ? ManahColors.brand.withValues(alpha: 0.1)
                    : (isDark ? Colors.grey[900] : Colors.grey[100]),
                border: Border.all(
                  color: i == activeArrowIndex
                      ? ManahColors.brand
                      : (scores[i].isFilled
                          ? ManahColors.success
                          : (isDark ? Colors.grey[800]! : Colors.grey[300]!)),
                  width: i == activeArrowIndex ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(ManahRadius.md),
              ),
              child: Text(
                scores[i].display,
                style: ManahTextStyles.number.copyWith(
                  fontSize: 20,
                  color: scores[i].isFilled
                      ? ManahColors.forScore(
                          scores[i].value ?? 0,
                          isX: scores[i].isX,
                          isMiss: scores[i].isMiss,
                        )
                      : null,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Numpad in archery reading order — highest to lowest, then X and M (task 5.4
/// — never 1→10). Matches the wood-board convention so the host's eyes don't
/// have to re-learn anything.
class _BoardNumpad extends StatelessWidget {
  const _BoardNumpad({required this.onKey, required this.onBackspace});

  final void Function(int value, {required bool isX, required bool isMiss})
      onKey;
  final VoidCallback onBackspace;

  static const List<({String label, int value, bool isX, bool isMiss})> _keys =
      [
    (label: '10', value: 10, isX: false, isMiss: false),
    (label: '9', value: 9, isX: false, isMiss: false),
    (label: '8', value: 8, isX: false, isMiss: false),
    (label: '7', value: 7, isX: false, isMiss: false),
    (label: '6', value: 6, isX: false, isMiss: false),
    (label: '5', value: 5, isX: false, isMiss: false),
    (label: '4', value: 4, isX: false, isMiss: false),
    (label: '3', value: 3, isX: false, isMiss: false),
    (label: '2', value: 2, isX: false, isMiss: false),
    (label: '1', value: 1, isX: false, isMiss: false),
    (label: 'X', value: 10, isX: true, isMiss: false),
    (label: 'M', value: 0, isX: false, isMiss: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
            crossAxisSpacing: ManahSpacing.sm,
            mainAxisSpacing: ManahSpacing.sm,
          ),
          itemCount: _keys.length,
          itemBuilder: (context, i) {
            final key = _keys[i];
            return OutlinedButton(
              onPressed: () =>
                  onKey(key.value, isX: key.isX, isMiss: key.isMiss),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: ManahColors.brand),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ManahRadius.md)),
              ),
              child: Text(key.label,
                  style: ManahTextStyles.h2.copyWith(color: ManahColors.brand)),
            );
          },
        ),
        const SizedBox(height: ManahSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onBackspace,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ManahRadius.md)),
            ),
            icon: const Icon(Icons.backspace_outlined, color: Colors.redAccent),
            label:
                const Text('Hapus', style: TextStyle(color: Colors.redAccent)),
          ),
        ),
      ],
    );
  }
}

/// Header chip showing whether the board is fully synced or holding local-only
/// rows — non-blocking, tappable to retry (task 5.5).
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

class _EmptyRoster extends StatelessWidget {
  const _EmptyRoster({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.groups_outlined, size: 64, color: theme.disabledColor),
            const SizedBox(height: ManahSpacing.base),
            Text('Belum ada pemanah di papan',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: ManahSpacing.sm),
            Text(
              'Tambahkan pemanah untuk mulai mencatat rambahan.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.textTheme.bodySmall?.color),
            ),
            const SizedBox(height: ManahSpacing.lg),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Tambah Pemanah'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoardError extends StatelessWidget {
  const _BoardError({required this.message});

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
            Text('Gagal memuat papan.\n$message', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
