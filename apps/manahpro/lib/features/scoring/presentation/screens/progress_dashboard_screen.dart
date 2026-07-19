import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/manah_navigation_button.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        leading: const ManahNavigationButton.back(),
        title: const Text('Statistik'),
      ),
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
              // Row 1: Hero Cards (Primary Stats)
              Row(
                children: [
                  _StatCard(
                    label: 'AVG / PANAH',
                    value: stats.overallAvgPerArrow?.toStringAsFixed(2) ?? '–',
                    icon: Icons.insights,
                    accentColor: ManahColors.brand,
                    isHero: true,
                  ),
                  _StatCard(
                    label: 'STREAK',
                    value: stats.currentStreakDays > 0
                        ? '${stats.currentStreakDays} Hari'
                        : '0 Hari',
                    icon: Icons.whatshot,
                    accentColor: ManahColors.error,
                    borderColor: stats.currentStreakDays > 0
                        ? ManahColors.error.withValues(alpha: 0.25)
                        : null,
                    backgroundColor: stats.currentStreakDays > 0
                        ? (isDark
                            ? const Color(0x1AE53935)
                            : const Color(0x0DE53935))
                        : null,
                    isHero: true,
                  ),
                ],
              ),
              const SizedBox(height: ManahSpacing.md),
              // Row 2: Supporting Cards (Secondary Stats)
              Row(
                children: [
                  _StatCard(
                    label: 'TERBAIK',
                    value: '${stats.bestScore ?? '–'}',
                    icon: Icons.emoji_events,
                    accentColor: ManahColors.amberDeep,
                  ),
                  _StatCard(
                    label: 'SESI',
                    value: '${stats.totalSessions}',
                    icon: Icons.history,
                  ),
                  _StatCard(
                    label: 'PANAH',
                    value: '${stats.totalArrows}',
                    icon: Icons.adjust,
                  ),
                ],
              ),
              const SizedBox(height: ManahSpacing.xl),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: ManahSpacing.xs),
                child: Text(
                  'Tren Rata-rata per Panah',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: ManahSpacing.md),
              Container(
                height: 240,
                margin: const EdgeInsets.symmetric(horizontal: ManahSpacing.xs),
                padding: const EdgeInsets.only(
                  top: ManahSpacing.base,
                  right: ManahSpacing.base,
                  bottom: ManahSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(ManahRadius.lg),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: _TrendChart(trend: stats.trend),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.icon,
    this.accentColor,
    this.borderColor,
    this.backgroundColor,
    this.isHero = false,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? accentColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool isHero;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final finalBgColor = backgroundColor ??
        (isHero
            ? (isDark ? ManahColors.darkSurface : Colors.white)
            : (isDark ? ManahColors.darkBg : ManahColors.lightGrey));

    final finalBorderColor = borderColor ??
        (isHero
            ? (isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.05))
            : (isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.02)));

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: ManahSpacing.xs),
        padding: EdgeInsets.symmetric(
          vertical: isHero ? ManahSpacing.base : ManahSpacing.md,
          horizontal: ManahSpacing.md,
        ),
        decoration: BoxDecoration(
          color: finalBgColor,
          borderRadius: BorderRadius.circular(ManahRadius.md),
          border: Border.all(color: finalBorderColor, width: 1.5),
          boxShadow: isHero
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.textTheme.labelSmall?.color
                        ?.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (icon != null)
                  Icon(
                    icon,
                    size: isHero ? 20 : 16,
                    color: accentColor ??
                        (isDark ? Colors.white54 : Colors.black45),
                  ),
              ],
            ),
            const SizedBox(height: ManahSpacing.xs),
            Text(
              value,
              style: (isHero
                      ? theme.textTheme.headlineMedium
                      : theme.textTheme.titleMedium)
                  ?.copyWith(
                fontWeight: FontWeight.bold,
                color: accentColor ??
                    (isDark ? Colors.white : ManahColors.nearBlack),
              ),
            ),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final spots = [
      for (var i = 0; i < trend.length; i++)
        FlSpot(i.toDouble(), trend[i].avgPerArrow),
    ];

    // Find the index of the highest avgPerArrow (peak performance)
    int peakIndex = -1;
    double maxVal = -1.0;
    for (var i = 0; i < trend.length; i++) {
      if (trend[i].avgPerArrow > maxVal) {
        maxVal = trend[i].avgPerArrow;
        peakIndex = i;
      }
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 10,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.dividerColor.withValues(alpha: 0.08),
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 2,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    value.toStringAsFixed(0),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color
                          ?.withValues(alpha: 0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) =>
                isDark ? ManahColors.darkElevated : Colors.white,
            tooltipBorder: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.1),
              width: 1,
            ),
            tooltipPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                if (index < 0 || index >= trend.length) return null;
                final pt = trend[index];

                // Format date as "d MMM" (e.g. "4 Jun")
                final months = [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'Mei',
                  'Jun',
                  'Jul',
                  'Agt',
                  'Sep',
                  'Okt',
                  'Nov',
                  'Des'
                ];
                final dateStr = '${pt.date.day} ${months[pt.date.month - 1]}';

                return LineTooltipItem(
                  '${pt.avgPerArrow.toStringAsFixed(2)} / 10\n$dateStr\nTotal: ${pt.totalScore}',
                  theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : ManahColors.nearBlack,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: ManahColors.brand,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final isPeak = index == peakIndex;
                return FlDotCirclePainter(
                  radius: isPeak ? 5.5 : 3.0,
                  color: isPeak ? ManahColors.error : ManahColors.brand,
                  strokeWidth: isPeak ? 2.0 : 1.5,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ManahColors.brand.withValues(alpha: 0.08),
                  ManahColors.brand.withValues(alpha: 0.00),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
