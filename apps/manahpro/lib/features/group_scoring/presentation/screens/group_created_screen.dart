import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/group_entities.dart';
import '../group_scoring_providers.dart';
import '../group_scoring_routes.dart';

/// Shows the freshly created group's `join_code` — big, copyable and shareable
/// (task 4.4). The share text is a Phase-0 placeholder; the full deep link /
/// QR distribution arrives in Phase 1 (Sprint 09). A primary action opens the
/// host board (Sprint 05) to start recording right away.
class GroupCreatedScreen extends ConsumerWidget {
  const GroupCreatedScreen({super.key, required this.groupId, this.group});

  final String groupId;
  final ScoringGroupEntity? group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Prefer the group passed via `extra`; otherwise load it (e.g. on refresh).
    final passed = group;
    if (passed != null) {
      return _buildScaffold(context, passed);
    }

    final async = ref.watch(groupDetailProvider(groupId));
    return async.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Sesi tidak ditemukan.')),
      ),
      data: (g) => g == null
          ? Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('Sesi tidak ditemukan.')),
            )
          : _buildScaffold(context, g),
    );
  }

  Widget _buildScaffold(BuildContext context, ScoringGroupEntity g) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sesi Dibuat'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(ManahSpacing.base),
          children: [
            const SizedBox(height: ManahSpacing.lg),
            const Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: ManahColors.brandSurface,
                child: Icon(Icons.check_circle,
                    color: ManahColors.brand, size: 44),
              ),
            ),
            const SizedBox(height: ManahSpacing.base),
            Text(
              g.title?.isNotEmpty == true ? g.title! : 'Latihan Bersama',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: ManahSpacing.xs),
            Text(
              'Bagikan kode ini agar teman bisa bergabung',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.textTheme.bodySmall?.color),
            ),
            const SizedBox(height: ManahSpacing.xl),

            // Big join code card.
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: ManahSpacing.xl,
                horizontal: ManahSpacing.base,
              ),
              decoration: BoxDecoration(
                color: ManahColors.brandSurface,
                borderRadius: BorderRadius.circular(ManahRadius.lg),
                border: Border.all(
                    color: ManahColors.brandLight.withValues(alpha: 0.4)),
              ),
              child: Column(
                children: [
                  Text(
                    'KODE GABUNG',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: ManahColors.brand,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: ManahSpacing.sm),
                  SelectableText(
                    g.joinCode,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                      color: ManahColors.brand,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: ManahSpacing.lg),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _copy(context, g.joinCode),
                    icon: const Icon(Icons.copy),
                    label: const Text('Salin Kode'),
                  ),
                ),
                const SizedBox(width: ManahSpacing.md),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _share(g),
                    icon: const Icon(Icons.share),
                    label: const Text('Bagikan'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: ManahSpacing.lg),

            // Round format summary.
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ManahRadius.md),
                side: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.1)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(ManahSpacing.base),
                child: Column(
                  children: [
                    _SummaryRow(label: 'Jarak', value: '${g.distanceM} m'),
                    _SummaryRow(
                        label: 'Lingkungan', value: g.environment.label),
                    _SummaryRow(
                        label: 'Format',
                        value: '${g.numEnds} ronde × ${g.arrowsPerEnd} panah'),
                    _SummaryRow(
                        label: 'Peserta', value: '${g.participantCount}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: ManahSpacing.lg),

            // Straight into the host board to start recording (Sprint 05).
            FilledButton.icon(
              onPressed: () => context.go(GroupScoringRoutes.board(g.id)),
              icon: const Icon(Icons.sports_score),
              label: const Text('Buka Papan Skor'),
            ),
            const SizedBox(height: ManahSpacing.sm),

            TextButton(
              onPressed: () => context.go(GroupScoringRoutes.list),
              child: const Text('Nanti Saja'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copy(BuildContext context, String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode disalin')),
      );
    }
  }

  Future<void> _share(ScoringGroupEntity g) async {
    final title = g.title?.isNotEmpty == true ? g.title! : 'Latihan Bersama';
    await SharePlus.instance.share(
      ShareParams(
        text: 'Yuk ikut "$title" di ManahPro! 🎯\n'
            'Masukkan kode gabung: ${g.joinCode}\n'
            '(tautan undangan langsung menyusul)',
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ManahSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.textTheme.bodySmall?.color)),
          Text(value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
