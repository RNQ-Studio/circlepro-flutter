import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: isAuthenticated
                  ? _buildAuthenticatedHeader(context, ref)
                  : _buildGuestHeader(context),
            ),
            const SliverToBoxAdapter(child: HomeQuoteOfTheDay()),
            const SliverToBoxAdapter(child: Divider(height: 24)),
            SliverToBoxAdapter(
              child: HomeMenuGrid(
                onMenuTap: (label) {
                  if (label == 'UI Gallery') {
                    context.push('/ui-gallery');
                  } else if (label == 'Kutipan') {
                    context.push(AppRoutes.quotes);
                  } else if (label == 'Profil') {
                    context.push(AppRoutes.profile);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$label — Fitur belum tersedia')),
                    );
                  }
                },
              ),
            ),
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
    return profileAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(20),
        child: Text('Gagal memuat profil: $e'),
      ),
      data: (profile) => HomeUserHeader(
        profile: profile,
        onEditTap: () => context.push(AppRoutes.editProfile),
        onProfileTap: () => context.push(AppRoutes.profile),
        onSettingsTap: () => context.push(AppRoutes.settings),
      ),
    );
  }

  Widget _buildGuestHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline_rounded,
              size: 28,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcome,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Guest',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(72, 36),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () => context.push('/login'),
            child: Text(
              l10n.login,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
          _appName = info.appName.isNotEmpty ? info.appName : 'Starter App';
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
                  width: 24,
                  height: 24,
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
                      .withValues(alpha: 0.4),
                ),
          ),
        ],
      ),
    );
  }
}
