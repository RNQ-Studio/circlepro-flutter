import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../shared/routes/social_routes.dart';
import '../../../theme/manah_colors.dart';
import '../../scoring/presentation/scoring_routes.dart';
import '../../group_scoring/presentation/group_scoring_routes.dart';
import '../../events/presentation/events_routes.dart';
import '../../gamification/presentation/gamification_providers.dart';
import '../../stories/presentation/widgets/story_header_list_widget.dart';
import 'home_provider.dart';
import 'widgets/home_user_header.dart';
import 'widgets/home_menu_grid.dart';
import 'widgets/home_quote_of_the_day.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState is AuthAuthenticated;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Logo dan Aksi dipaling atas
            SliverToBoxAdapter(
              child: _buildTopBar(context, ref, isAuthenticated),
            ),

            // Welcoming User Banner
            SliverToBoxAdapter(
              child: isAuthenticated
                  ? _buildAuthenticatedHeader(context, ref)
                  : _buildGuestHeader(context),
            ),

            if (isAuthenticated)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: StoryHeaderListWidget(),
                ),
              ),
            
            // Mulai Latihan Quick Card (di-hide dulu)
            // const SliverToBoxAdapter(
            //   child: _QuickStartCard(),
            // ),

            // Feature Menu Grid
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 16.0, bottom: 4.0),
                    child: Text(
                      'Layanan Utama',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  HomeMenuGrid(
                    onMenuTap: (label) {
                      if (label == 'Scoring') {
                        context.push(ScoringRoutes.setup);
                      } else if (label == 'Bersama') {
                        context.push(GroupScoringRoutes.list);
                      } else if (label == 'Statistik') {
                        context.push(ScoringRoutes.dashboard);
                      } else if (label == 'Riwayat') {
                        context.push(ScoringRoutes.history);
                      } else if (label == 'Klub') {
                        context.push(SocialRoutes.clubs);
                      } else if (label == 'Event') {
                        context.push(EventsRoutes.discovery);
                      } else if (label == 'Pelatih') {
                        context.push(SocialRoutes.coaches);
                      } else if (label == 'Lapangan') {
                        context.push(SocialRoutes.ranges);
                      } else if (label == 'Artikel') {
                        context.push(SocialRoutes.articles);
                      }
                    },
                  ),
                ],
              ),
            ),

            // Quote of the Day
            const SliverToBoxAdapter(
              child: HomeQuoteOfTheDay(),
            ),

            // Version Footer
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: _HomeFooter(),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 16 + MediaQuery.of(context).padding.bottom,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticatedHeader(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final statsAsync = ref.watch(gamificationStatsProvider);

    return profileAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(20),
        child: Text('Gagal memuat profil: $e'),
      ),
      data: (profile) {
        final stats = statsAsync.asData?.value;
        return HomeUserHeader(
          profile: profile,
          stats: stats,
          onProfileTap: () => context.push(AppRoutes.profile),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, WidgetRef ref, bool isAuthenticated) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo ManahPro (kecilkan sedikit ke 32, pojok kiri)
          Image.asset(
            'assets/images/logo_border_white.png',
            height: 32,
            fit: BoxFit.contain,
          ),
          // Ikon pengaturan dan logout (hanya tampil jika terautentikasi)
          if (isAuthenticated)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.settings_outlined,
                    color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  onPressed: () => context.push(AppRoutes.settings),
                  tooltip: 'Pengaturan',
                  style: IconButton.styleFrom(
                    backgroundColor: theme.dividerColor.withValues(alpha: isDark ? 0.08 : 0.04),
                    padding: const EdgeInsets.all(6),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.logout_rounded,
                    color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Keluar Akun'),
                        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                            ),
                            child: const Text('Keluar'),
                          ),
                        ],
                      ),
                    ).then((confirmed) {
                      if (confirmed == true) {
                        ref.read(authProvider.notifier).logout();
                      }
                    });
                  },
                  tooltip: 'Keluar',
                  style: IconButton.styleFrom(
                    backgroundColor: theme.dividerColor.withValues(alpha: isDark ? 0.08 : 0.04),
                    padding: const EdgeInsets.all(6),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildGuestHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.08 : 0.05),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.dividerColor.withValues(alpha: 0.1),
            child: Icon(
              Icons.person_rounded,
              size: 20,
              color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.welcome,
                  style: TextStyle(
                    color: theme.textTheme.titleMedium?.color ?? (isDark ? Colors.white : ManahColors.nearBlack),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Masuk untuk mencatat skor & naik level!',
                  style: TextStyle(
                    color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.55),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(60, 32),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              backgroundColor: ManahColors.brand,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () => context.push('/login'),
            child: Text(
              l10n.login,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// Intentionally retained: the "Mulai Latihan" quick card is hidden for now
// (see the commented-out usage above) but kept for an upcoming home revamp.
// ignore: unused_element
class _QuickStartCard extends StatelessWidget {
  const _QuickStartCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF152A4A),
                  const Color(0xFF0D47A1),
                ]
              : [
                  const Color(0xFF1E88E5), // Sky/Ocean Blue
                  ManahColors.brand,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ManahColors.brand.withOpacity(isDark ? 0.2 : 0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Mulai Scoring Latihan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Catat skor anak panah Anda secara instan dan dapatkan analisis prestasinya.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: ManahColors.brand,
                    minimumSize: const Size(120, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => context.push(ScoringRoutes.setup),
                  child: const Text(
                    'Mulai Sekarang',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.track_changes_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeFooter extends StatefulWidget {
  const _HomeFooter();

  @override
  State<_HomeFooter> createState() => _HomeFooterState();
}

class _HomeFooterState extends State<_HomeFooter> {
  String _appName = '';
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _appName = info.appName.isNotEmpty ? info.appName : 'ManahPro';
          _appVersion = '${info.version}+${info.buildNumber}';
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_appName.isEmpty) return const SizedBox.shrink();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'packages/features_shared/assets/logo.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _appName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Versi $_appVersion',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.4),
                ),
          ),
        ],
      ),
    );
  }
}
