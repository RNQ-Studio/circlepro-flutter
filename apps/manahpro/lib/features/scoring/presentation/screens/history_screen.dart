import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/manah_navigation_button.dart';
import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/scoring_entities.dart';
import '../../domain/scoring_enums.dart';
import '../scoring_providers.dart';
import '../scoring_routes.dart';

/// Session history (task 1.8): list by date with a bow-class filter, local-first.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  BowClass? _filter;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(sessionsListProvider);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        leading: const ManahNavigationButton.back(),
        title: const Text('Riwayat'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat: $e')),
        data: (sessions) {
          final filtered = _filter == null
              ? sessions
              : sessions.where((s) => s.bowClass == _filter).toList();

          return Column(
            children: [
              _FilterBar(
                sessions: sessions,
                selected: _filter,
                onSelected: (b) => setState(() => _filter = b),
              ),
              if (filtered.isEmpty)
                const Expanded(
                  child: Center(child: Text('Belum ada sesi scoring.')),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => ref.invalidate(sessionsListProvider),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(ManahSpacing.base),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: ManahSpacing.sm),
                      itemBuilder: (context, i) =>
                          _SessionCard(session: filtered[i]),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar(
      {required this.sessions,
      required this.selected,
      required this.onSelected});

  final List<ScoringSessionEntity> sessions;
  final BowClass? selected;
  final ValueChanged<BowClass?> onSelected;

  @override
  Widget build(BuildContext context) {
    final classes = sessions.map((s) => s.bowClass).toSet().toList();
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: ManahSpacing.base, vertical: ManahSpacing.sm),
        children: [
          ChoiceChip(
            label: const Text('Semua'),
            selected: selected == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final c in classes) ...[
            const SizedBox(width: ManahSpacing.sm),
            ChoiceChip(
              label: Text(c.label),
              selected: selected == c,
              onSelected: (_) => onSelected(c),
            ),
          ],
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session});
  final ScoringSessionEntity session;

  String get _date {
    final d = session.startedAt.toLocal();
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '${d.day}/${d.month}/${d.year} · $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inProgress = session.status == ScoringSessionStatus.inProgress;

    return Card(
      child: ListTile(
        onTap: () {
          if (inProgress) {
            context.push(ScoringRoutes.input(session.id));
          } else {
            context.push(ScoringRoutes.summary(session.id));
          }
        },
        title: Row(
          children: [
            Text(
                '${session.bowClass.label} · ${session.distanceCategory.label}'),
            if (session.isPersonalBest) ...[
              const SizedBox(width: ManahSpacing.sm),
              const Text('🎯', style: TextStyle(fontSize: 14)),
            ],
          ],
        ),
        subtitle: Row(
          children: [
            Text(_date),
            if (!inProgress) ...[
              const SizedBox(width: ManahSpacing.xs),
              Icon(
                session.isSynced
                    ? Icons.cloud_done_outlined
                    : Icons.cloud_upload_outlined,
                size: 14,
                color: session.isSynced
                    ? ManahColors.success
                    : ManahColors.mediumGrey,
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              inProgress ? 'Berlangsung' : '${session.totalScore}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: inProgress ? ManahColors.warning : null,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (!inProgress)
              Text('/ ${session.maxPossibleScore}',
                  style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
