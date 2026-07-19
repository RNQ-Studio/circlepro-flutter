import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/manah_navigation_button.dart';
import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/scoring_entities.dart';
import '../active_scoring_notifier.dart';
import '../scoring_providers.dart';
import '../scoring_routes.dart';
import '../widgets/arrow_slots.dart';
import '../widgets/score_pad.dart';

/// THE core screen. Fast one-handed score entry, full offline. Each tap
/// persists to local Drift immediately. ui-ux-design-guide.md §6.2.
class ScoreInputScreen extends ConsumerWidget {
  const ScoreInputScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(activeScoringProvider(sessionId));
    final targetFacesAsync = ref.watch(targetFacesListProvider);
    final notifier = ref.read(activeScoringProvider(sessionId).notifier);

    return asyncState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(
          leadingWidth: 64,
          leading: const ManahNavigationButton.back(),
        ),
        body: Center(child: Text('Gagal memuat sesi: $e')),
      ),
      data: (s) {
        final targetFaces = targetFacesAsync.value ?? const [];
        final targetFace = s.session.targetFaceId != null
            ? targetFaces
                .where((t) => t.id == s.session.targetFaceId)
                .firstOrNull
            : null;

        return _ScoreInputView(
          state: s,
          notifier: notifier,
          sessionId: sessionId,
          targetFace: targetFace,
        );
      },
    );
  }
}

class _ScoreInputView extends StatelessWidget {
  const _ScoreInputView({
    required this.state,
    required this.notifier,
    required this.sessionId,
    this.targetFace,
  });

  final ActiveScoringState state;
  final ActiveScoring notifier;
  final String sessionId;
  final TargetFaceEntity? targetFace;

  Future<void> _onScore(ScoreKey key) async {
    // Audible + tactile feedback (dependency-free): a stronger reward cue for
    // X / 10, a light tick otherwise.
    SystemSound.play(SystemSoundType.click);
    if (key.isX || key.value == 10) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.selectionClick();
    }
    // Persistence + auto-advance to the next end are handled in the notifier.
    await notifier.enterScore(
        value: key.value, isX: key.isX, isMiss: key.isMiss);
  }

  Future<void> _finish(BuildContext context) async {
    final finished = await notifier.finish();
    if (finished != null) {
      HapticFeedback.heavyImpact();
      if (context.mounted) {
        context.pushReplacement(ScoringRoutes.summary(sessionId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = state.session;
    final end = state.currentEnd;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        leading: const ManahNavigationButton.back(),
        title: Text(
          '${end.isSighter ? 'Percobaan' : 'Ronde'} ${end.endNumber}/${session.numEnds}',
        ),
        actions: [
          TextButton(
            onPressed: () => _finish(context),
            child: const Text('Selesai'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress across all ends.
            LinearProgressIndicator(
              value: session.plannedArrows == 0
                  ? 0
                  : session.arrowsShot / session.plannedArrows,
              minHeight: 4,
              backgroundColor: ManahColors.brandSurface,
            ),
            // Running totals.
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: ManahSpacing.base,
                vertical: ManahSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TOTAL', style: theme.textTheme.labelSmall),
                      Text(
                        '${session.totalScore} / ${session.maxPossibleScore}',
                        style: theme.textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('AVG / PANAH', style: theme.textTheme.labelSmall),
                      Text(
                        session.avgPerArrow?.toStringAsFixed(2) ?? '–',
                        style: theme.textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Arrow slots for the current end.
            Padding(
              padding: const EdgeInsets.all(ManahSpacing.base),
              child: Column(
                children: [
                  if (end.isSighter) ...[
                    const _SighterNote(),
                    const SizedBox(height: ManahSpacing.sm),
                  ],
                  ArrowSlots(
                    arrows: end.arrows,
                    capacity: session.arrowsPerEnd,
                  ),
                  const SizedBox(height: ManahSpacing.sm),
                  Text(
                    '${end.isSighter ? 'Total Percobaan' : 'Total Ronde'}: ${end.endTotal}',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Score pad.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.sm),
              child: ScorePad(
                onScore: _onScore,
                onUndo: notifier.undo,
                undoEnabled: end.arrows.isNotEmpty,
                targetFace: targetFace,
              ),
            ),
            // End navigation.
            Padding(
              padding: const EdgeInsets.all(ManahSpacing.base),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          state.hasPreviousEnd ? notifier.previousEnd : null,
                      icon: const Icon(Icons.chevron_left),
                      label: const Text('Ronde Sebelumnya'),
                    ),
                  ),
                  const SizedBox(width: ManahSpacing.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: state.hasNextEnd ? notifier.nextEnd : null,
                      icon: const Icon(Icons.chevron_right),
                      label: const Text('Ronde Berikutnya'),
                    ),
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

class _SighterNote extends StatelessWidget {
  const _SighterNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: ManahSpacing.base, vertical: ManahSpacing.sm),
      decoration: BoxDecoration(
        color: ManahColors.amberDeep.withValues(alpha: 0.12),
        borderRadius: const BorderRadius.all(
          Radius.circular(ManahRadius.md),
        ),
      ),
      child: Text(
        'Rambahan percobaan tersimpan, tetapi tidak masuk total atau PB.',
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: ManahColors.amberDeep),
      ),
    );
  }
}
