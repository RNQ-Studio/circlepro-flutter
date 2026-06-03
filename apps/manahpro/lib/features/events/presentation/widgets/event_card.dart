import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/event_entity.dart';
import '../../domain/event_enums.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  final EventEntity event;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final startsStr = DateFormat('dd MMM yyyy', 'id').format(event.startsAt);
    final endsStr = event.endsAt != null
        ? DateFormat('dd MMM yyyy', 'id').format(event.endsAt!)
        : null;
    final dateRangeStr = endsStr != null && endsStr != startsStr
        ? '$startsStr - $endsStr'
        : startsStr;

    // Determine tier color
    Color tierColor;
    Color tierTextColor = Colors.white;
    switch (event.tier) {
      case EventTier.s:
        tierColor = ManahColors.brand;
        break;
      case EventTier.a:
        tierColor = ManahColors.amberDeep;
        break;
      case EventTier.b:
        tierColor = ManahColors.info;
        break;
      case EventTier.c:
        tierColor = ManahColors.success;
        break;
      case EventTier.d:
        tierColor = ManahColors.mediumGrey;
        break;
    }

    final isRegOpen = event.isRegistrationOpen;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManahRadius.md),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner + Overlay Badges
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: event.bannerUrl != null && event.bannerUrl!.isNotEmpty
                      ? Image.network(
                          event.bannerUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholderImage(isDark),
                        )
                      : _buildPlaceholderImage(isDark),
                ),
                // Tier Badge
                Positioned(
                  top: ManahSpacing.sm,
                  left: ManahSpacing.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ManahSpacing.sm,
                      vertical: ManahSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: tierColor,
                      borderRadius: BorderRadius.circular(ManahRadius.sm),
                    ),
                    child: Text(
                      'TIER ${event.tier.value}',
                      style: ManahTextStyles.label.copyWith(
                        color: tierTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Status Badge
                Positioned(
                  top: ManahSpacing.sm,
                  right: ManahSpacing.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ManahSpacing.sm,
                      vertical: ManahSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: isRegOpen
                          ? ManahColors.success
                          : ManahColors.nearBlack.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(ManahRadius.sm),
                    ),
                    child: Text(
                      event.status.label.toUpperCase(),
                      style: ManahTextStyles.label.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Info Body
            Padding(
              padding: const EdgeInsets.all(ManahSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.format.label,
                    style: ManahTextStyles.label.copyWith(
                      color: ManahColors.brandLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: ManahSpacing.xs),
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ManahTextStyles.h3.copyWith(
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: ManahSpacing.sm),
                  // Date
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: ManahColors.mediumGrey,
                      ),
                      const SizedBox(width: ManahSpacing.sm),
                      Expanded(
                        child: Text(
                          dateRangeStr,
                          style: ManahTextStyles.bodyM.copyWith(
                            color: isDark ? Colors.white70 : ManahColors.darkGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ManahSpacing.xs),
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: ManahColors.mediumGrey,
                      ),
                      const SizedBox(width: ManahSpacing.sm),
                      Expanded(
                        child: Text(
                          event.locationLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ManahTextStyles.bodyM.copyWith(
                            color: isDark ? Colors.white70 : ManahColors.darkGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ManahSpacing.md),
                  const Divider(height: 1),
                  const SizedBox(height: ManahSpacing.md),
                  // Capacity & Organization
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          event.organizationName ?? 'Penyelenggara Umum',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ManahTextStyles.bodyS.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ManahColors.mediumGrey,
                          ),
                        ),
                      ),
                      if (event.capacity != null && event.capacity! > 0)
                        _buildCapacityInfo(context)
                      else
                        Text(
                          'Kuota Bebas',
                          style: ManahTextStyles.bodyS.copyWith(
                            color: ManahColors.mediumGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ManahColors.brand.withOpacity(0.8),
            ManahColors.brandLight.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.track_changes,
          size: 48,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCapacityInfo(BuildContext context) {
    // Total registered athletes across all divisions
    final registered = event.divisions.fold<int>(0, (sum, div) => sum + div.numParticipants);
    final total = event.capacity!;
    final isFull = registered >= total;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ManahSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isFull
            ? ManahColors.error.withOpacity(0.1)
            : ManahColors.brandLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ManahRadius.sm),
      ),
      child: Text(
        isFull ? 'PENUH' : 'SISA ${total - registered} SLOT',
        style: ManahTextStyles.bodyS.copyWith(
          color: isFull ? ManahColors.error : ManahColors.brand,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
