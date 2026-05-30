import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../dashboard_provider.dart';

/// Progress dashboard (task 1.10): trend line of average-per-arrow, key stats
/// and streak. Derived offline-first from local sessions.
class ProgressDashboardScreen extends ConsumerWidget {
  const ProgressDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat: $e')),
        data: (stats) {
          if (stats.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(ManahSpacing.xl),
                child: Text(
                  'Belum ada sesi selesai. Mulai scoring untuk melihat progres.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(ManahSpacing.base),
            children: [
              Row(
                children: [
                  _Stat(label: 'Sesi', value: '${stats.totalSessions}'),
                  _Stat(label: 'Panah', value: '${stats.totalArrows}'),
                  _Stat(label: 'Streak', value: '${stats.currentStreakDays} 🔥'),
                ],
              ),
              const SizedBox(height: ManahSpacing.sm),
              Row(
                children: [
                  _Stat(label: 'Avg/Panah', value: stats.overallAvgPerArrow?.toStringAsFixed(2) ?? '–'),
                  _Stat(label: 'Skor Terbaik', value: '${stats.bestScore ?? '–'}', accent: ManahColors.amberDeep),
                ],
              ),
              const SizedBox(height: ManahSpacing.lg),
              Text('Tren Rata-rata per Panah', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: ManahSpacing.md),
              SizedBox(height: 220, child: _TrendChart(trend: stats.trend)),
            ],
          );
        },
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.accent});
  final String label;
  final String value;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: ManahSpacing.xs),
        padding: const EdgeInsets.symmetric(vertical: ManahSpacing.base),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(ManahRadius.md),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Text(value, style: theme.textTheme.titleLarge?.copyWith(color: accent)),
            const SizedBox(height: 2),
            Text(label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.trend});
  final List<TrendPoint> trend;

  @override
  Widget build(BuildContext context) {
    final spots = [
      for (var i = 0; i < trend.length; i++) FlSpot(i.toDouble(), trend[i].avgPerArrow),
    ];

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 10,
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 2),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: ManahColors.brand,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: ManahColors.brandLight.withValues(alpha: 0.18),
            ),
          ),
        ],
      ),
    );
  }
}
