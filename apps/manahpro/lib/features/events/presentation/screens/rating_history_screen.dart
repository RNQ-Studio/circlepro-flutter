import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/rating_history_entry.dart';
import '../events_providers.dart';

class RatingHistoryScreen extends ConsumerWidget {
  const RatingHistoryScreen({
    super.key,
    required this.userId,
    required this.ratingId,
  });

  final String userId;
  final String ratingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final historyAsync = ref.watch(ratingHistoryProvider(userId: userId, ratingId: ratingId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Rating'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(ratingHistoryProvider(userId: userId, ratingId: ratingId));
          await ref.read(ratingHistoryProvider(userId: userId, ratingId: ratingId).future);
        },
        child: historyAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _buildErrorState(ref, error.toString()),
          data: (history) {
            if (history.isEmpty) {
              return _buildEmptyState();
            }

            // Chart data: sort chronological (ascending)
            final sortedHistory = List<RatingHistoryEntry>.from(history)
              ..sort((a, b) => a.computedAt.compareTo(b.computedAt));

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: ManahSpacing.base),
                  // Chart Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.base),
                    child: Text('Perkembangan Rating', style: ManahTextStyles.h3),
                  ),
                  const SizedBox(height: 8),
                  _buildChartContainer(sortedHistory, isDark),
                  const SizedBox(height: ManahSpacing.lg),
                  // List Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.base),
                    child: Text('Riwayat Pertandingan', style: ManahTextStyles.h3),
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.base),
                    itemCount: history.length,
                    separatorBuilder: (_, __) => const SizedBox(height: ManahSpacing.base),
                    itemBuilder: (context, index) {
                      final entry = history[index];
                      return _buildHistoryItem(entry, isDark);
                    },
                  ),
                  const SizedBox(height: ManahSpacing.xl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChartContainer(List<RatingHistoryEntry> sorted, bool isDark) {
    if (sorted.isEmpty) return const SizedBox.shrink();

    // Find min and max display ratings to scale Y axis nicely
    double minY = sorted.first.displayAfter;
    double maxY = sorted.first.displayAfter;
    for (final entry in sorted) {
      if (entry.displayAfter < minY) minY = entry.displayAfter;
      if (entry.displayBefore < minY) minY = entry.displayBefore;
      if (entry.displayAfter > maxY) maxY = entry.displayAfter;
      if (entry.displayBefore > maxY) maxY = entry.displayBefore;
    }

    // Add padding to chart bounds
    minY = (minY - 50).clamp(0.0, double.infinity);
    maxY = maxY + 50;

    final spots = <FlSpot>[];
    for (int i = 0; i < sorted.length; i++) {
      spots.add(FlSpot(i.toDouble(), sorted[i].displayAfter));
    }

    return Container(
      height: 240,
      margin: const EdgeInsets.symmetric(horizontal: ManahSpacing.base),
      padding: const EdgeInsets.fromLTRB(8, 20, 24, 10),
      decoration: BoxDecoration(
        color: isDark ? ManahColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ManahBorderRadius.card),
        border: Border.all(color: isDark ? Colors.grey[850]! : Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (sorted.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 100,
            getDrawingHorizontalLine: (value) => FlLine(
              color: isDark ? Colors.white10 : Colors.black12,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= sorted.length) return const SizedBox.shrink();
                  // Show date label on first, middle, last indices to prevent overlap
                  if (sorted.length > 3 &&
                      index != 0 &&
                      index != sorted.length ~/ 2 &&
                      index != sorted.length - 1) {
                    return const SizedBox.shrink();
                  }
                  final date = sorted[index].computedAt;
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      DateFormat('dd/MM').format(date),
                      style: TextStyle(
                        color: ManahColors.mediumGrey,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      value.round().toString(),
                      style: const TextStyle(
                        color: ManahColors.mediumGrey,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: ManahColors.brand,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2.5,
                  strokeColor: ManahColors.brand,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    ManahColors.brand.withValues(alpha: 0.3),
                    ManahColors.brand.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(RatingHistoryEntry entry, bool isDark) {
    final isDecay = entry.eventId == null;
    final change = entry.displayChange;
    final isPositive = change > 0;
    final changeText = isPositive ? '+${change.round()}' : change.round().toString();
    final changeColor = change == 0
        ? ManahColors.mediumGrey
        : (isPositive ? ManahColors.success : ManahColors.error);

    return Card(
      elevation: 1,
      color: isDark ? ManahColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManahBorderRadius.card),
        side: BorderSide(color: isDark ? Colors.grey[850]! : Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.base),
        child: Row(
          children: [
            // Left block: rating change pill
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: changeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ManahBorderRadius.button),
              ),
              child: Center(
                child: Text(
                  changeText,
                  style: TextStyle(
                    color: changeColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: ManahSpacing.base),
            // Middle: Match name, division and Glicko details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDecay ? 'Inactivity Decay' : (entry.eventName ?? 'Kejuaraan Archer'),
                    style: ManahTextStyles.h4,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isDecay
                        ? 'Pengurangan aktivitas bulanan'
                        : '${entry.divisionName ?? "Umum"} | NPS: ${entry.nps?.round() ?? "-"}',
                    style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                  ),
                  if (!isDecay) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Poin: ${entry.scoreAchieved ?? "-"} | Pos: ${entry.placement ?? "-"}/${entry.numParticipants ?? "-"}',
                      style: ManahTextStyles.bodyS.copyWith(
                        color: ManahColors.brand,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Right: display rating progression
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  entry.displayAfter.round().toString(),
                  style: ManahTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${entry.displayBefore.round()} ➔ ${entry.displayAfter.round()}',
                  style: TextStyle(
                    fontSize: 8,
                    color: ManahColors.mediumGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd/MM/yy').format(entry.computedAt),
                  style: TextStyle(
                    fontSize: 8,
                    color: ManahColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history_toggle_off,
              size: 72,
              color: ManahColors.mediumGrey,
            ),
            const SizedBox(height: ManahSpacing.base),
            Text(
              'Belum ada riwayat perubahan rating.',
              textAlign: TextAlign.center,
              style: ManahTextStyles.bodyL.copyWith(color: ManahColors.mediumGrey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: ManahColors.error),
            const SizedBox(height: ManahSpacing.sm),
            Text('Gagal memuat riwayat', style: ManahTextStyles.h3),
            const SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: ManahSpacing.md),
            ElevatedButton(
              onPressed: () => ref.refresh(ratingHistoryProvider(userId: userId, ratingId: ratingId)),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
