import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/feed/presentation/feed_providers.dart';
import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/scoring_entities.dart';
import '../scoring_providers.dart';
import '../scoring_routes.dart';
import '../widgets/personal_best_banner.dart';

/// Post-session summary: total, averages, per-end chart, PB celebration and a
/// shareable scorecard. ui-ux-design-guide.md §6.
class SessionSummaryScreen extends ConsumerWidget {
  const SessionSummaryScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(scoringRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Sesi'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
      ),
      body: FutureBuilder<ScoringSessionEntity?>(
        future: repo.getSession(sessionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final session = snapshot.data;
          if (session == null) {
            return const Center(child: Text('Sesi tidak ditemukan'));
          }
          return _SummaryBody(session: session);
        },
      ),
    );
  }
}

class _SummaryBody extends StatelessWidget {
  const _SummaryBody({required this.session});

  final ScoringSessionEntity session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.all(ManahSpacing.base),
        children: [
          if (session.isPersonalBest) ...[
            const PersonalBestBanner(),
            const SizedBox(height: ManahSpacing.base),
          ],
          Card(
            color: ManahColors.brand,
            child: Padding(
              padding: const EdgeInsets.all(ManahSpacing.lg),
              child: Column(
                children: [
                  Text('TOTAL SKOR', style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70)),
                  const SizedBox(height: ManahSpacing.xs),
                  Text(
                    '${session.totalScore}',
                    style: theme.textTheme.displayLarge?.copyWith(color: Colors.white),
                  ),
                  Text(
                    'dari ${session.maxPossibleScore}',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: ManahSpacing.base),
          Row(
            children: [
              _StatTile(label: 'Avg/Panah', value: session.avgPerArrow?.toStringAsFixed(2) ?? '–'),
              _StatTile(label: 'Panah', value: '${session.arrowsShot}'),
            ],
          ),
          const SizedBox(height: ManahSpacing.sm),
          Row(
            children: [
              _StatTile(label: 'X', value: '${session.xCount}', accent: ManahColors.amberDeep),
              _StatTile(label: '10', value: '${session.tenCount}', accent: ManahColors.amberDeep),
              _StatTile(label: 'Miss', value: '${session.missCount}', accent: ManahColors.error),
            ],
          ),
          const SizedBox(height: ManahSpacing.lg),
          Text('Skor per Ronde', style: theme.textTheme.titleMedium),
          const SizedBox(height: ManahSpacing.sm),
          _EndBars(session: session),
          const SizedBox(height: ManahSpacing.xl),
          OutlinedButton.icon(
            onPressed: () => context.push(ScoringRoutes.scorecard(session.id)),
            icon: const Icon(Icons.share_outlined),
            label: const Text('Bagikan Scorecard'),
          ),
          const SizedBox(height: ManahSpacing.sm),
          _ShareToFeedButton(session: session),
          const SizedBox(height: ManahSpacing.sm),
          FilledButton(
            onPressed: () => context.go('/'),
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, this.accent});

  final String label;
  final String value;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: ManahSpacing.xs),
        padding: const EdgeInsets.symmetric(vertical: ManahSpacing.md),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(ManahRadius.md),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(color: accent)),
            Text(label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _EndBars extends StatelessWidget {
  const _EndBars({required this.session});

  final ScoringSessionEntity session;

  @override
  Widget build(BuildContext context) {
    final maxEnd = session.arrowsPerEnd * 10;
    return Column(
      children: session.ends.map((end) {
        final ratio = maxEnd == 0 ? 0.0 : end.endTotal / maxEnd;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: ManahSpacing.xs),
          child: Row(
            children: [
              SizedBox(width: 32, child: Text('R${end.endNumber}', style: Theme.of(context).textTheme.bodySmall)),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ManahRadius.sm),
                  child: LinearProgressIndicator(
                    value: ratio.clamp(0.0, 1.0),
                    minHeight: 18,
                    backgroundColor: ManahColors.brandSurface,
                    valueColor: const AlwaysStoppedAnimation(ManahColors.brandLight),
                  ),
                ),
              ),
              const SizedBox(width: ManahSpacing.sm),
              SizedBox(
                width: 32,
                child: Text(
                  '${end.endTotal}',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// "Share to community feed" — auto-posts the session (task 2.13b).
class _ShareToFeedButton extends ConsumerStatefulWidget {
  const _ShareToFeedButton({required this.session});

  final ScoringSessionEntity session;

  @override
  ConsumerState<_ShareToFeedButton> createState() => _ShareToFeedButtonState();
}

class _ShareToFeedButtonState extends ConsumerState<_ShareToFeedButton> {
  bool _busy = false;
  bool _shared = false;

  Future<void> _share() async {
    setState(() => _busy = true);
    try {
      final s = widget.session;
      await ref.read(feedRepositoryProvider).createPost({
        'body': 'Skor latihan ${s.bowClass.label} ${s.distanceCategory.label}: '
            '${s.totalScore}/${s.maxPossibleScore} 🎯',
        'shared_type': 'scoring_session',
        'shared_id': s.id,
        'visibility': 'public',
      });
      if (mounted) {
        setState(() => _shared = true);
        ref.invalidate(feedProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dibagikan ke komunitas')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal membagikan: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: (_busy || _shared) ? null : _share,
      icon: _busy
          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(_shared ? Icons.check : Icons.forum_outlined),
      label: Text(_shared ? 'Sudah dibagikan' : 'Bagikan ke Feed'),
    );
  }
}
