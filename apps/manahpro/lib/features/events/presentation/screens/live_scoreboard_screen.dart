import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/event_leaderboard_entry.dart';
import '../events_providers.dart';

class LiveScoreboardScreen extends ConsumerStatefulWidget {
  const LiveScoreboardScreen({
    super.key,
    required this.eventId,
    this.initialDivisionId,
  });

  final String eventId;
  final String? initialDivisionId;

  @override
  ConsumerState<LiveScoreboardScreen> createState() => _LiveScoreboardScreenState();
}

class _LiveScoreboardScreenState extends ConsumerState<LiveScoreboardScreen> {
  String? _selectedDivisionId;

  @override
  void initState() {
    super.initState();
    _selectedDivisionId = widget.initialDivisionId;
  }

  @override
  Widget build(BuildContext context) {
    final asyncEvent = ref.watch(eventDetailsProvider(widget.eventId));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Papan Peringkat Langsung'),
        elevation: 0,
      ),
      body: asyncEvent.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat event: $err')),
        data: (event) {
          if (event.divisions.isEmpty) {
            return const Center(child: Text('Event ini tidak memiliki divisi.'));
          }

          // Pre-select first division if none selected
          if (_selectedDivisionId == null || !event.divisions.any((d) => d.id == _selectedDivisionId)) {
            _selectedDivisionId = event.divisions.first.id;
          }

          return Column(
            children: [
              // Division Selector Tabs/Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.base, vertical: ManahSpacing.sm),
                color: isDark ? ManahColors.darkSurface : Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedDivisionId,
                        decoration: const InputDecoration(
                          labelText: 'Pilih Divisi',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: event.divisions.map((d) {
                          return DropdownMenuItem<String>(
                            value: d.id,
                            child: Text(
                              d.displayName,
                              style: ManahTextStyles.bodyM.copyWith(fontWeight: FontWeight.w600),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedDivisionId = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Leaderboard list
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final asyncLeaderboard = ref.watch(eventLeaderboardProvider(
                      eventId: widget.eventId,
                      divisionId: _selectedDivisionId!,
                    ));

                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(eventLeaderboardProvider(
                          eventId: widget.eventId,
                          divisionId: _selectedDivisionId!,
                        ));
                      },
                      child: asyncLeaderboard.when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, size: 48, color: ManahColors.error),
                                const SizedBox(height: ManahSpacing.sm),
                                Text('Gagal memuat leaderboard', style: ManahTextStyles.h3),
                                const SizedBox(height: ManahSpacing.xs),
                                Text(err.toString(), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                        data: (leaderboard) {
                          if (leaderboard.isEmpty) {
                            return const Center(
                              child: SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Text('Belum ada skor yang dimasukkan.'),
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.all(ManahSpacing.base),
                            itemCount: leaderboard.length,
                            itemBuilder: (context, index) {
                              final entry = leaderboard[index];
                              final rank = index + 1;

                              return _buildLeaderboardCard(context, rank, entry, isDark);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLeaderboardCard(BuildContext context, int rank, EventLeaderboardEntry entry, bool isDark) {
    Color? rankBgColor;
    Color rankTextColor = Colors.white;
    IconData? rankIcon;

    if (rank == 1) {
      rankBgColor = ManahColors.rankGold;
      rankIcon = Icons.emoji_events;
    } else if (rank == 2) {
      rankBgColor = ManahColors.rankSilver;
      rankTextColor = Colors.black87;
    } else if (rank == 3) {
      rankBgColor = ManahColors.rankBronze;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: ManahSpacing.sm),
      elevation: rank <= 3 ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManahBorderRadius.card),
        side: BorderSide(
          color: rank == 1
              ? ManahColors.rankGold.withValues(alpha: 0.5)
              : (isDark ? Colors.grey[850]! : Colors.grey[300]!),
          width: rank == 1 ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.base),
        child: Row(
          children: [
            // Rank Badge
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: rankBgColor ?? (isDark ? Colors.grey[800] : Colors.grey[200]),
                shape: BoxShape.circle,
              ),
              child: rankIcon != null
                  ? Icon(rankIcon, color: Colors.white, size: 20)
                  : Text(
                      '$rank',
                      style: ManahTextStyles.h3.copyWith(
                        color: rankBgColor != null ? rankTextColor : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
            ),
            const SizedBox(width: ManahSpacing.base),

            // Archer Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.userName,
                    style: ManahTextStyles.h3.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'BIB: ${entry.bibNumber ?? "-"} | Target: ${entry.targetButt ?? "-"}${entry.targetLetter ?? "-"}',
                    style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                  ),
                ],
              ),
            ),

            // Stats
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry.totalScore}',
                  style: ManahTextStyles.number.copyWith(
                    fontSize: 24,
                    color: rank == 1 ? ManahColors.rankGold : ManahColors.brand,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'X: ${entry.xCount}',
                      style: ManahTextStyles.bodyS.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Avg: ${entry.avgPerArrow.toStringAsFixed(1)}',
                      style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
