import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../scoring/domain/scoring_entities.dart';
import '../../../scoring/utils/ulid.dart';
import '../../domain/board_participant_entity.dart';
import '../group_scoring_providers.dart';
import '../group_scoring_routes.dart';
import '../widgets/add_participant_sheet.dart';

/// The **host board** (Sprint 05) — the hero flow: one screen, every
/// participant visible, scored *end-by-end following the whistle*. Generalized
/// from `multi_archer_scorer_screen` (events): the round format is dynamic
/// (honours the group's `arrows_per_end`/`num_ends`, so indoor 3-arrow and
/// outdoor 6-arrow are both correct), guests are first-class (keyed by session
/// id, not `user_id`), and every "Simpan Rambahan" lands offline-first in Drift
/// then syncs in the background — never blocking on a dead signal (K2).
class HostBoardScreen extends ConsumerStatefulWidget {
  const HostBoardScreen({
    super.key,
    required this.groupId,
    this.focusParticipantId,
    this.targetButt,
  });

  final String groupId;

  /// When set (Sprint 06, task 6.4), the board opens focused on this
  /// participant's tab — e.g. tapping a roster card on the detail screen.
  final String? focusParticipantId;
  final int? targetButt;

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
  bool _focusApplied = false;

  /// Open the board on a specific participant once (task 6.4), then never
  /// override the host's manual tab choice.
  void _applyFocus(List<BoardParticipant> participants) {
    if (_focusApplied) return;
    _focusApplied = true;
    final fid = widget.focusParticipantId;
    if (fid == null) return;
    final idx = participants.indexWhere((p) => p.id == fid);
    if (idx >= 0) _activeIndex = idx;
  }

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
    final scopedTitle = widget.targetButt == null
        ? 'Papan Skor'
        : 'Bantalan ${widget.targetButt}';

    return Scaffold(
      appBar: AppBar(
        title: Text(scopedTitle),
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
          if (widget.targetButt == null)
            IconButton(
              tooltip: 'Tambah pemain',
              icon: const Icon(Icons.person_add_alt_1),
              onPressed: async.hasValue ? _promptAddPlayers : null,
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
        error: (e, _) => _BoardError(message: '$e'),
        data: (state) {
          final group = state.group;
          final participants = _visibleParticipants(state);
          if (participants.isEmpty) {
            return _EmptyRoster(
              onAdd: widget.targetButt == null ? _promptAddPlayers : null,
              targetButt: widget.targetButt,
            );
          }

          _seedTemp(participants, group.arrowsPerEnd);
          _applyFocus(participants);
          final active = participants[_activeIndex];
          final activeScores = _temp[active.id]!;
          final savedEnds = {
            for (var e = 1; e <= group.numEnds; e++)
              if (boardRoundIsSaved(participants, e)) e,
          };
          final isCorrection = savedEnds.contains(_currentEnd);
          final isSighter = group.isSighterEnd(_currentEnd);

          return Column(
            children: [
              _EndStrip(
                currentEnd: _currentEnd,
                numEnds: group.numEnds,
                sighterEndCount: group.sighterEndCount,
                savedEnds: savedEnds,
                onSelect: (e) => setState(() {
                  _currentEnd = e;
                  _activeArrowIndex = 0;
                }),
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
                      if (isSighter) _SighterBanner(endNumber: _currentEnd),
                      if (isCorrection) const _CorrectionBanner(),
                      Text(
                        '${active.labelOr('Saya')} — '
                        '${isSighter ? 'Rambahan Percobaan' : 'Rambahan'} $_currentEnd',
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
                            : () => _saveEnd(
                                  participants,
                                  group.arrowsPerEnd,
                                  isSighter: isSighter,
                                ),
                        icon: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : Icon(isCorrection ? Icons.edit : Icons.save),
                        label: Text(_isSaving
                            ? 'Menyimpan…'
                            : isCorrection
                                ? 'Simpan Koreksi ${isSighter ? 'Percobaan' : 'Rambahan'} $_currentEnd'
                                : 'Simpan ${isSighter ? 'Percobaan' : 'Rambahan'} $_currentEnd'),
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
    final participants = _visibleParticipants(state);
    if (participants.isEmpty) return;
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
    final participants = _visibleParticipants(state);
    if (participants.isEmpty) return;
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
    int arrowsPerEnd, {
    required bool isSighter,
  }) async {
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

    // A correction re-saves an already-complete past round; the forward flow
    // saves a fresh one. Capture this *before* the write so we know whether to
    // auto-advance (task 6.2: stay put after a correction so the host can show
    // the fixed number; only roll forward when following the whistle).
    final wasCorrection = boardRoundIsSaved(participants, _currentEnd);

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
          .saveEnd(_currentEnd, arrowsByParticipantId, isSighter: isSighter);
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
    final noun = wasCorrection
        ? 'Koreksi ${isSighter ? 'Percobaan' : 'Rambahan'}'
        : (isSighter ? 'Percobaan' : 'Rambahan');
    _snack(
      pending > 0
          ? '$noun $_currentEnd tersimpan (lokal) — akan tersinkron otomatis.'
          : '$noun $_currentEnd tersimpan & tersinkron.',
      pending > 0 ? ManahColors.brand : ManahColors.success,
    );

    // Only roll forward when following the whistle — never after a correction
    // (stay on the fixed round so the host can show it's now right — task 6.2).
    if (wasCorrection) return;
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

  // ─── Quick-add roster (Sprint 06, task 6.1) — multi-name batch sheet ──────

  Future<void> _promptAddPlayers() async {
    final names = await showAddParticipantSheet(context);
    if (names == null || names.isEmpty || !mounted) return;
    await ref
        .read(hostBoardControllerProvider(widget.groupId).notifier)
        .addGuests(names);
    if (!mounted) return;
    _snack(
      names.length == 1
          ? '${names.first} ditambahkan ke papan.'
          : '${names.length} pemain ditambahkan ke papan.',
      ManahColors.success,
    );
  }

  void _snack(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  List<BoardParticipant> _visibleParticipants(HostBoardState state) {
    final targetButt = widget.targetButt;
    if (targetButt == null) return state.participants;
    return state.participants
        .where((participant) => participant.targetButt == targetButt)
        .toList();
  }
}

/// A horizontally-scrollable strip of round chips (task 6.2). Tapping any chip
/// jumps straight to that round — one tap to re-open a past round and fix a
/// number in front of the archer. Saved rounds carry a ✓ so the host can see at
/// a glance which rounds already exist and are safe to correct.
class _EndStrip extends StatelessWidget {
  const _EndStrip({
    required this.currentEnd,
    required this.numEnds,
    required this.sighterEndCount,
    required this.savedEnds,
    required this.onSelect,
  });

  final int currentEnd;
  final int numEnds;
  final int sighterEndCount;
  final Set<int> savedEnds;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: ManahSpacing.base, right: 4),
            child: Icon(Icons.flag_outlined,
                size: 18, color: ManahColors.mediumGrey),
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: ManahSpacing.sm, vertical: ManahSpacing.sm),
              itemCount: numEnds,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                final end = i + 1;
                final isActive = end == currentEnd;
                final isSaved = savedEnds.contains(end);
                final isSighter = sighterEndCount > 0 && end <= sighterEndCount;
                return ChoiceChip(
                  selected: isActive,
                  selectedColor:
                      isSighter ? ManahColors.amberDeep : ManahColors.brand,
                  showCheckmark: false,
                  onSelected: (_) => onSelect(end),
                  avatar: isSaved
                      ? Icon(Icons.check_circle,
                          size: 16,
                          color: isActive ? Colors.white : ManahColors.success)
                      : null,
                  label: Text(
                    isSighter ? 'P$end' : 'R$end',
                    style: ManahTextStyles.bodyM.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown above the slots while viewing an already-saved round, so it is obvious
/// the host is correcting history — not entering a new round (task 6.2).
class _SighterBanner extends StatelessWidget {
  const _SighterBanner({required this.endNumber});

  final int endNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: ManahSpacing.sm),
      padding: const EdgeInsets.symmetric(
          horizontal: ManahSpacing.base, vertical: ManahSpacing.sm),
      decoration: BoxDecoration(
        color: ManahColors.amberDeep.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(ManahRadius.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.flag_circle_outlined,
              size: 20, color: ManahColors.amberDeep),
          const SizedBox(width: ManahSpacing.sm),
          Expanded(
            child: Text(
              'Percobaan $endNumber disimpan untuk catatan, tidak masuk total, PB, atau peringkat.',
              style:
                  ManahTextStyles.bodyS.copyWith(color: ManahColors.amberDeep),
            ),
          ),
        ],
      ),
    );
  }
}

class _CorrectionBanner extends StatelessWidget {
  const _CorrectionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: ManahSpacing.sm),
      padding: const EdgeInsets.symmetric(
          horizontal: ManahSpacing.base, vertical: ManahSpacing.sm),
      decoration: BoxDecoration(
        color: ManahColors.amberDeep.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(ManahRadius.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.edit_note, size: 20, color: ManahColors.amberDeep),
          const SizedBox(width: ManahSpacing.sm),
          Expanded(
            child: Text(
              'Mode koreksi — betulkan angka lalu simpan. Papan langsung benar.',
              style:
                  ManahTextStyles.bodyS.copyWith(color: ManahColors.amberDeep),
            ),
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
  const _EmptyRoster({required this.onAdd, this.targetButt});

  final VoidCallback? onAdd;
  final int? targetButt;

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
              targetButt == null
                  ? 'Tambahkan pemanah untuk mulai mencatat rambahan.'
                  : 'Belum ada peserta yang dipetakan ke bantalan ini.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.textTheme.bodySmall?.color),
            ),
            if (onAdd != null) ...[
              const SizedBox(height: ManahSpacing.lg),
              FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Tambah Pemanah'),
              ),
            ],
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
