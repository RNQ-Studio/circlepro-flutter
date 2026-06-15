import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../scoring/presentation/widgets/personal_best_banner.dart';
import '../../domain/claim_success_summary.dart';
import '../group_scoring_routes.dart';

/// The claim-success onboarding (Sprint 15.3). When a host approves Pak Budi's
/// "Ini Saya", the approved notification lands here — not on a bare "berhasil",
/// but on an invitation to keep training: his first Personal Best, his average
/// per arrow, a warm welcome. Turns a moved row into the birth of a pendata
/// archer. Copy is club-practice warm, never a competition result (15.4).
class ClaimSuccessScreen extends StatelessWidget {
  const ClaimSuccessScreen({
    super.key,
    required this.groupId,
    required this.sessionId,
    required this.summary,
  });

  final String groupId;
  final String sessionId;
  final ClaimSuccessSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = summary.groupTitle;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(ManahSpacing.base),
          children: [
            const SizedBox(height: ManahSpacing.sm),
            Text('🎯', style: theme.textTheme.displaySmall),
            const SizedBox(height: ManahSpacing.sm),
            Text(
              'Skor ini kini milikmu',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: ManahSpacing.xs),
            Text(
              title != null
                  ? 'Dari $title — tercatat di riwayat latihanmu.'
                  : 'Tercatat di riwayat latihanmu.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: ManahColors.mediumGrey),
            ),
            const SizedBox(height: ManahSpacing.lg),

            if (summary.isPersonalBest) ...[
              PersonalBestBanner(
                title: 'Personal Best Pertamamu!',
                subtitle: summary.totalScore != null
                    ? 'Skor ${summary.totalScore} langsung jadi rekormu. '
                        'Awal yang indah. 🏹'
                    : 'Rekor pertamamu lahir hari ini. 🏹',
              ),
              const SizedBox(height: ManahSpacing.base),
            ],

            if (summary.hasNumbers) ...[
              Row(
                children: [
                  _StatTile(
                    label: 'Total Skor',
                    value: '${summary.totalScore}',
                    accent: ManahColors.brand,
                  ),
                  _StatTile(
                    label: 'Rata-rata/Panah',
                    value: summary.avgPerArrow?.toStringAsFixed(1) ?? '–',
                    accent: ManahColors.brand,
                  ),
                ],
              ),
              const SizedBox(height: ManahSpacing.base),
            ],

            // The warm invitation to keep training — the whole point of 15.3.
            Container(
              padding: const EdgeInsets.all(ManahSpacing.base),
              decoration: BoxDecoration(
                color: ManahColors.brandSurface,
                borderRadius: BorderRadius.circular(ManahRadius.lg),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events_outlined,
                      color: ManahColors.brand),
                  const SizedBox(width: ManahSpacing.md),
                  Expanded(
                    child: Text(
                      _invitation(),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: ManahSpacing.xl),

            FilledButton.icon(
              onPressed: () =>
                  context.go(GroupScoringRoutes.leaderboard(groupId)),
              icon: const Icon(Icons.leaderboard_outlined),
              label: const Text('Lihat Papan Sesi'),
            ),
            const SizedBox(height: ManahSpacing.sm),
            OutlinedButton(
              onPressed: () => context.go('/'),
              child: const Text('Selesai'),
            ),
          ],
        ),
      ),
    );
  }

  String _invitation() {
    if (summary.hasNumbers && summary.avgPerArrow != null) {
      return 'Rata-ratamu ${summary.avgPerArrow!.toStringAsFixed(1)}/panah. '
          'Latih lagi minggu depan — grafikmu baru saja dimulai.';
    }
    return 'Latihan pertamamu tercatat. Sampai jumpa di sesi berikutnya!';
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
            Text(value,
                style: theme.textTheme.headlineSmall?.copyWith(color: accent)),
            Text(label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
