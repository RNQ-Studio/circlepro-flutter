import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../events_providers.dart';

class NationalLeaderboardScreen extends ConsumerWidget {
  const NationalLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filters = ref.watch(nationalLeaderboardFiltersStateProvider);
    final leaderboardAsync = ref.watch(nationalLeaderboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peringkat Nasional'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterBar(context, ref, filters, isDark),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(nationalLeaderboardProvider);
                await ref.read(nationalLeaderboardProvider.future);
              },
              child: leaderboardAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => _buildErrorState(ref, error.toString()),
                data: (ratings) {
                  if (ratings.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(ManahSpacing.base),
                    itemCount: ratings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: ManahSpacing.base),
                    itemBuilder: (context, index) {
                      final rating = ratings[index];
                      final rank = index + 1;
                      return _buildLeaderboardCard(context, rating, rank, isDark);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(
    BuildContext context,
    WidgetRef ref,
    NationalLeaderboardFilters filters,
    bool isDark,
  ) {
    return Container(
      color: isDark ? ManahColors.darkSurface : Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: ManahSpacing.base,
        vertical: ManahSpacing.sm,
      ),
      child: Column(
        children: [
          // Bow Class Selector (Tabs style)
          Row(
            children: [
              _buildSegmentTab(
                label: 'Recurve',
                isSelected: filters.bowClass == 'recurve',
                onTap: () => ref
                    .read(nationalLeaderboardFiltersStateProvider.notifier)
                    .updateBowClass('recurve'),
              ),
              const SizedBox(width: 8),
              _buildSegmentTab(
                label: 'Compound',
                isSelected: filters.bowClass == 'compound',
                onTap: () => ref
                    .read(nationalLeaderboardFiltersStateProvider.notifier)
                    .updateBowClass('compound'),
              ),
              const SizedBox(width: 8),
              _buildSegmentTab(
                label: 'Barebow',
                isSelected: filters.bowClass == 'barebow',
                onTap: () => ref
                    .read(nationalLeaderboardFiltersStateProvider.notifier)
                    .updateBowClass('barebow'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Gender, Age, Distance filters row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Gender Filter
                _buildDropdownFilter<String>(
                  value: filters.gender,
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Putra')),
                    DropdownMenuItem(value: 'female', child: Text('Putri')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      ref
                          .read(nationalLeaderboardFiltersStateProvider.notifier)
                          .updateGender(val);
                    }
                  },
                ),
                const SizedBox(width: 8),
                // Age Group Filter
                _buildDropdownFilter<String>(
                  value: filters.ageGroup,
                  items: const [
                    DropdownMenuItem(value: 'tk', child: Text('TK')),
                    DropdownMenuItem(value: 'sd_123', child: Text('SD 1-3')),
                    DropdownMenuItem(value: 'sd_456', child: Text('SD 4-6')),
                    DropdownMenuItem(value: 'smp', child: Text('SMP')),
                    DropdownMenuItem(value: 'sma', child: Text('SMA')),
                    DropdownMenuItem(value: 'dewasa', child: Text('Umum (Dewasa)')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      ref
                          .read(nationalLeaderboardFiltersStateProvider.notifier)
                          .updateAgeGroup(val);
                    }
                  },
                ),
                const SizedBox(width: 8),
                // Distance Filter
                _buildDropdownFilter<String>(
                  value: filters.distanceCategory,
                  items: const [
                    DropdownMenuItem(value: '18m', child: Text('18m')),
                    DropdownMenuItem(value: '30m', child: Text('30m')),
                    DropdownMenuItem(value: '40m', child: Text('40m')),
                    DropdownMenuItem(value: '50m', child: Text('50m')),
                    DropdownMenuItem(value: '70m', child: Text('70m')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      ref
                          .read(nationalLeaderboardFiltersStateProvider.notifier)
                          .updateDistanceCategory(val);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Province and City filter text fields
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Provinsi (opsional)',
                      hintStyle: const TextStyle(fontSize: 12),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ManahBorderRadius.button),
                      ),
                    ),
                    controller: TextEditingController(text: filters.province)
                      ..selection = TextSelection.collapsed(
                        offset: filters.province?.length ?? 0,
                      ),
                    onSubmitted: (val) {
                      ref
                          .read(nationalLeaderboardFiltersStateProvider.notifier)
                          .updateProvince(val.trim().isEmpty ? null : val.trim());
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Kota/Kab (opsional)',
                      hintStyle: const TextStyle(fontSize: 12),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ManahBorderRadius.button),
                      ),
                    ),
                    controller: TextEditingController(text: filters.city)
                      ..selection = TextSelection.collapsed(offset: filters.city?.length ?? 0),
                    onSubmitted: (val) {
                      ref
                          .read(nationalLeaderboardFiltersStateProvider.notifier)
                          .updateCity(val.trim().isEmpty ? null : val.trim());
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? ManahColors.brand : Colors.transparent,
            borderRadius: BorderRadius.circular(ManahBorderRadius.button),
            border: Border.all(
              color: isSelected ? ManahColors.brand : ManahColors.mediumGrey.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : ManahColors.mediumGrey,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownFilter<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ManahBorderRadius.button),
        border: Border.all(color: ManahColors.mediumGrey.withValues(alpha: 0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 12,
            color: ManahColors.nearBlack,
            fontWeight: FontWeight.w600,
          ),
          icon: const Icon(Icons.arrow_drop_down, size: 20),
        ),
      ),
    );
  }

  Widget _buildLeaderboardCard(
    BuildContext context,
    dynamic rating,
    int rank,
    bool isDark,
  ) {
    Color rankColor = ManahColors.mediumGrey;
    Widget rankIcon = Text(
      '#$rank',
      style: ManahTextStyles.h3.copyWith(color: rankColor),
    );

    if (rank == 1) {
      rankColor = ManahColors.rankGold;
      rankIcon = const Icon(Icons.emoji_events, color: ManahColors.rankGold, size: 28);
    } else if (rank == 2) {
      rankColor = ManahColors.rankSilver;
      rankIcon = const Icon(Icons.emoji_events, color: ManahColors.rankSilver, size: 28);
    } else if (rank == 3) {
      rankColor = ManahColors.rankBronze;
      rankIcon = const Icon(Icons.emoji_events, color: ManahColors.rankBronze, size: 28);
    }

    Color bandColor = ManahColors.rankIron;
    if (rating.color == 'gold') {
      bandColor = ManahColors.rankGold;
    } else if (rating.color == 'diamond' || rating.color == 'blue') {
      bandColor = ManahColors.rankDiamond;
    } else if (rating.color == 'silver') {
      bandColor = ManahColors.rankSilver;
    } else if (rating.color == 'bronze') {
      bandColor = ManahColors.rankBronze;
    }

    return Card(
      elevation: 2,
      color: isDark ? ManahColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManahBorderRadius.card),
        side: BorderSide(
          color: rank <= 3
              ? rankColor.withValues(alpha: 0.5)
              : (isDark ? Colors.grey[850]! : Colors.grey[200]!),
          width: rank <= 3 ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(ManahBorderRadius.card),
        onTap: () {
          context.push('/profiles/${rating.userId}/ratings/${rating.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(ManahSpacing.base),
          child: Row(
            children: [
              // Rank number or trophy icon
              SizedBox(
                width: 36,
                child: Center(child: rankIcon),
              ),
              const SizedBox(width: 8),
              // User Avatar
              CircleAvatar(
                radius: 22,
                backgroundColor: ManahColors.brand.withValues(alpha: 0.1),
                backgroundImage: rating.avatarUrl != null
                    ? NetworkImage(rating.avatarUrl!)
                    : null,
                child: rating.avatarUrl == null
                    ? Text(
                        (rating.userName ?? rating.username ?? 'A')
                            .substring(0, 1)
                            .toUpperCase(),
                        style: const TextStyle(
                          color: ManahColors.brand,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Name, Title and Location details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating.userName ?? rating.username ?? 'Archer',
                      style: ManahTextStyles.h4,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        // Rating band/title badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: bandColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: bandColor.withValues(alpha: 0.3), width: 0.5),
                          ),
                          child: Text(
                            rating.title,
                            style: ManahTextStyles.badge.copyWith(
                              color: isDark ? Colors.white70 : Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Last event count
                        Text(
                          '${rating.eventsCount} Event',
                          style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Display Rating circular box
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ManahColors.brand,
                      ManahColors.brand.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: ManahColors.brand.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      rating.displayRating.round().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      rating.status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
              Icons.emoji_events_outlined,
              size: 72,
              color: ManahColors.mediumGrey,
            ),
            const SizedBox(height: ManahSpacing.base),
            Text(
              'Belum ada peringkat untuk kategori ini.',
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
            Text('Gagal memuat peringkat', style: ManahTextStyles.h3),
            const SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: ManahSpacing.md),
            ElevatedButton(
              onPressed: () => ref.refresh(nationalLeaderboardProvider),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
