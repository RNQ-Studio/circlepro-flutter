import 'dart:ui' show FontFeature;

import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/manah_tokens.dart';
import '../../scoring/domain/scoring_entities.dart';
import '../../scoring/domain/scoring_enums.dart';
import '../../scoring/presentation/scoring_providers.dart';
import '../../scoring/presentation/scoring_routes.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState is AuthAuthenticated;
    final sessionsAsync = ref.watch(sessionsListProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(sessionsListProvider);
            await ref.read(sessionsListProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              ManahSpacing.base,
              ManahSpacing.sm,
              ManahSpacing.base,
              ManahSpacing.xl,
            ),
            children: [
              _HomeTopBar(isAuthenticated: isAuthenticated),
              const SizedBox(height: ManahSpacing.xl),
              Text(
                'Scoring individu',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: ManahSpacing.xs),
              Text(
                'Catat setiap anak panah, bahkan saat offline.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: ManahSpacing.lg),
              sessionsAsync.when(
                loading: _HomeLoading.new,
                error: (_, __) => _HomeError(
                  onRetry: () => ref.invalidate(sessionsListProvider),
                ),
                data: (sessions) => _HomeScoringContent(sessions: sessions),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar({required this.isAuthenticated});

  final bool isAuthenticated;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/logo_border_white.png',
              height: ManahSpacing.xl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Text(
                'ManahPro',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        if (isAuthenticated)
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Pengaturan',
          )
        else
          TextButton(
            onPressed: () => context.push('/login'),
            child: const Text('Masuk'),
          ),
      ],
    );
  }
}

class _HomeScoringContent extends StatelessWidget {
  const _HomeScoringContent({required this.sessions});

  final List<ScoringSessionEntity> sessions;

  @override
  Widget build(BuildContext context) {
    final activeSession = _firstWhereOrNull(
      sessions,
      (session) => session.status == ScoringSessionStatus.inProgress,
    );
    final latestCompletedSession = _firstWhereOrNull(
      sessions,
      (session) => session.status == ScoringSessionStatus.completed,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PrimaryScoringSurface(session: activeSession),
        const SizedBox(height: ManahSpacing.lg),
        const _ScoringLinks(),
        if (latestCompletedSession != null) ...[
          const SizedBox(height: ManahSpacing.xl),
          Text(
            'Sesi terakhir',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: ManahSpacing.md),
          _LatestCompletedSession(session: latestCompletedSession),
        ],
      ],
    );
  }
}

class _PrimaryScoringSurface extends StatelessWidget {
  const _PrimaryScoringSurface({required this.session});

  final ScoringSessionEntity? session;

  @override
  Widget build(BuildContext context) {
    final activeSession = session;
    if (activeSession != null) {
      return _ActiveScoringSurface(session: activeSession);
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(ManahRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.adjust_rounded,
              color: colorScheme.primary,
              size: ManahSpacing.xl,
            ),
            const SizedBox(height: ManahSpacing.base),
            Text(
              'Mulai scoring individu',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: ManahSpacing.xs),
            Text(
              'Atur busur, jarak, dan target untuk memulai sesi.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: ManahSpacing.md),
            Row(
              children: [
                Icon(
                  Icons.offline_bolt_outlined,
                  size: ManahSpacing.base,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: ManahSpacing.sm),
                Expanded(
                  child: Text(
                    'Siap dipakai offline',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: ManahSpacing.base),
            FilledButton.icon(
              onPressed: () => context.push(ScoringRoutes.setup),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Mulai scoring'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveScoringSurface extends StatelessWidget {
  const _ActiveScoringSurface({required this.session});

  final ScoringSessionEntity session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = session.plannedArrows == 0
        ? 0.0
        : session.arrowsShot / session.plannedArrows;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(ManahRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.adjust_rounded,
              color: colorScheme.onPrimaryContainer,
              size: ManahSpacing.xl,
            ),
            const SizedBox(height: ManahSpacing.base),
            Text(
              'Lanjutkan scoring',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: ManahSpacing.xs),
            Text(
              '${session.bowClass.label} · '
              '${session.distanceCategory.label}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: ManahSpacing.base),
            Text(
              '${session.arrowsShot} dari ${session.plannedArrows} panah',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontFeatures: const [FontFeature.tabularFigures()],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: ManahSpacing.sm),
            LinearProgressIndicator(
              value: progress.clamp(0, 1),
              backgroundColor: colorScheme.surface.withValues(alpha: 0.5),
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(ManahRadius.full),
            ),
            const SizedBox(height: ManahSpacing.base),
            FilledButton.icon(
              onPressed: () => context.push(ScoringRoutes.input(session.id)),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Lanjutkan scoring'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LatestCompletedSession extends StatelessWidget {
  const _LatestCompletedSession({required this.session});

  final ScoringSessionEntity session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final syncLabel = session.isSynced ? 'Tersinkron' : 'Menunggu sinkronisasi';

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(ManahRadius.lg),
      child: InkWell(
        key: const ValueKey('latest-completed-session'),
        onTap: () => context.push(ScoringRoutes.summary(session.id)),
        borderRadius: BorderRadius.circular(ManahRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(ManahSpacing.base),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${session.bowClass.label} · '
                      '${session.distanceCategory.label}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: ManahSpacing.xs),
                    Text(
                      _formatSessionDate(session.startedAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: ManahSpacing.sm),
                    Row(
                      children: [
                        Icon(
                          session.isSynced
                              ? Icons.cloud_done_outlined
                              : Icons.cloud_upload_outlined,
                          size: ManahSpacing.base,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: ManahSpacing.sm),
                        Expanded(
                          child: Text(
                            syncLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: ManahSpacing.base),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${session.totalScore}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '/ ${session.maxPossibleScore}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoringLinks extends StatelessWidget {
  const _ScoringLinks();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ScoringLinkRow(
          icon: Icons.history_rounded,
          label: 'Riwayat',
          description: 'Lihat semua sesi scoring individu',
          onTap: () => context.push(ScoringRoutes.history),
        ),
        const Divider(height: 1),
        _ScoringLinkRow(
          icon: Icons.insights_outlined,
          label: 'Statistik',
          description: 'Pantau rata-rata dan perkembangan skor',
          onTap: () => context.push(ScoringRoutes.dashboard),
        ),
      ],
    );
  }
}

class _ScoringLinkRow extends StatelessWidget {
  const _ScoringLinkRow({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: ManahSpacing.sm),
            child: Row(
              children: [
                Icon(icon, color: colorScheme.primary),
                const SizedBox(width: ManahSpacing.base),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: ManahSpacing.xs),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: ManahSpacing.sm),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeLoading extends StatelessWidget {
  const _HomeLoading();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Memuat data scoring',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(ManahRadius.lg),
        ),
        child: const Padding(
          padding: EdgeInsets.all(ManahSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SkeletonLine(widthFactor: 0.45),
              SizedBox(height: ManahSpacing.md),
              _SkeletonLine(widthFactor: 0.8),
              SizedBox(height: ManahSpacing.lg),
              _SkeletonLine(widthFactor: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(ManahRadius.sm),
        ),
        child: const SizedBox(height: ManahSpacing.lg),
      ),
    );
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(ManahRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.cloud_off_outlined, color: colorScheme.error),
            const SizedBox(height: ManahSpacing.md),
            Text(
              'Data scoring belum bisa dimuat.',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: ManahSpacing.xs),
            Text(
              'Periksa kembali data lokal lalu coba lagi.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: ManahSpacing.base),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

ScoringSessionEntity? _firstWhereOrNull(
  List<ScoringSessionEntity> sessions,
  bool Function(ScoringSessionEntity) predicate,
) {
  for (final session in sessions) {
    if (predicate(session)) return session;
  }
  return null;
}

String _formatSessionDate(DateTime value) {
  final date = value.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final sessionDay = DateTime(date.year, date.month, date.day);
  final difference = today.difference(sessionDay).inDays;

  if (difference == 0) return 'Hari ini';
  if (difference == 1) return 'Kemarin';
  return '${date.day}/${date.month}/${date.year}';
}
