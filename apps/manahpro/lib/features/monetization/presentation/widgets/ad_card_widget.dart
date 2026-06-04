import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../theme/manah_colors.dart';
import '../../domain/monetization_entities.dart';
import '../monetization_providers.dart';

class AdCardWidget extends ConsumerWidget {
  const AdCardWidget({
    super.key,
    required this.ad,
  });

  final AdEntity ad;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.08 : 0.05),
          width: 1.2,
        ),
      ),
      color: isDark ? ManahColors.darkSurface : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _handleTap(context, ref),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image if present
            if (ad.imageUrl != null && ad.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  ad.imageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: ManahColors.amberSurface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Sponsor',
                          style: TextStyle(
                            color: ManahColors.amberDeep,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (ad.title != null && ad.title!.isNotEmpty)
                        Expanded(
                          child: Text(
                            ad.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isDark ? Colors.white : ManahColors.nearBlack,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (ad.body != null && ad.body!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      ad.body!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white60 : ManahColors.mediumGrey,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, WidgetRef ref) async {
    try {
      final repo = ref.read(monetizationRepositoryProvider);
      final clickUrl = await repo.trackAdClick(ad.id);
      
      final urlString = clickUrl ?? ad.clickUrl;
      if (urlString != null && urlString.isNotEmpty) {
        final uri = Uri.parse(urlString);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (_) {
      if (ad.clickUrl != null && ad.clickUrl!.isNotEmpty) {
        final uri = Uri.parse(ad.clickUrl!);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    }
  }
}
