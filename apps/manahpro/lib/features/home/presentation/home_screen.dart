import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/manah_tokens.dart';
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
                data: (_) => const _HomeScoringContent(),
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
  const _HomeScoringContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StartScoringSurface(),
        SizedBox(height: ManahSpacing.lg),
        _ScoringLinks(),
      ],
    );
  }
}

class _StartScoringSurface extends StatelessWidget {
  const _StartScoringSurface();

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
