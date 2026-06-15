import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';

/// Celebratory Personal Best banner — scales + fades in once and fires a heavy
/// haptic. Extracted from the session summary (ui-ux-design-guide.md §6) so the
/// same celebration can welcome a freshly-claimed archer (Sprint 15.3, "reuse
/// animasi PB bila tersedia"). [title]/[subtitle] are overridable so the claim
/// success screen can say "Personal Best pertamamu!".
class PersonalBestBanner extends StatefulWidget {
  const PersonalBestBanner({
    super.key,
    this.title = 'Personal Best Baru!',
    this.subtitle = 'Rekor terbaik untuk format ini.',
  });

  final String title;
  final String subtitle;

  @override
  State<PersonalBestBanner> createState() => _PersonalBestBannerState();
}

class _PersonalBestBannerState extends State<PersonalBestBanner> {
  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutBack,
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.scale(scale: 0.85 + 0.15 * t, child: child),
      ),
      child: Container(
        padding: const EdgeInsets.all(ManahSpacing.base),
        decoration: BoxDecoration(
          color: ManahColors.amberSurface,
          borderRadius: BorderRadius.circular(ManahRadius.lg),
          border: Border.all(color: ManahColors.amber),
        ),
        child: Row(
          children: [
            const Text('🎯', style: TextStyle(fontSize: 28)),
            const SizedBox(width: ManahSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: ManahColors.amberDeep),
                  ),
                  Text(widget.subtitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
