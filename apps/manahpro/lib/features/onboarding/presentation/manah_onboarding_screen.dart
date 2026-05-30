import 'package:features_shared/features_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/manah_colors.dart';
import '../../../theme/manah_tokens.dart';

/// ManahPro 3-screen onboarding (task 2.4, ui-ux-design-guide §7). Reuses the
/// shared onboarding-completion state so it only shows on first run.
class ManahOnboardingScreen extends ConsumerStatefulWidget {
  const ManahOnboardingScreen({super.key});

  @override
  ConsumerState<ManahOnboardingScreen> createState() => _ManahOnboardingScreenState();
}

class _ManahOnboardingScreenState extends ConsumerState<ManahOnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = [
    _Page(
      icon: Icons.track_changes,
      color: ManahColors.brand,
      title: 'Selamat datang di ManahPro',
      body: 'Super-app komunitas panahan Indonesia — catat skor, bertanding, dan berkembang.',
    ),
    _Page(
      icon: Icons.edit_note,
      color: ManahColors.amberDeep,
      title: 'Scoring cepat & offline',
      body: 'Catat setiap panah < 3 detik, jalan tanpa internet, dan pantau progresmu otomatis.',
    ),
    _Page(
      icon: Icons.groups,
      color: ManahColors.brand,
      title: 'Komunitas & Kompetisi',
      body: 'Gabung klub, bagikan latihan ke komunitas, dan (segera) naik peringkat nasional.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(onPressed: _complete, child: const Text('Lewati')),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) => _pages[i],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _page == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _page == i ? ManahColors.brand : ManahColors.brand.withValues(alpha: 0.25),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(ManahSpacing.lg),
              child: FilledButton(
                onPressed: isLast
                    ? _complete
                    : () => _controller.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        ),
                child: Text(isLast ? 'Mulai Sekarang' : 'Selanjutnya'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({required this.icon, required this.color, required this.title, required this.body});

  final IconData icon;
  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(ManahSpacing.xl),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(icon, size: 72, color: color),
          ),
          const SizedBox(height: ManahSpacing.xl),
          Text(title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: ManahSpacing.base),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ManahColors.mediumGrey),
          ),
        ],
      ),
    );
  }
}
