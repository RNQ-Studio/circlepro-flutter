import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

import 'home_provider.dart';
import 'widgets/home_user_header.dart';
import 'widgets/home_menu_grid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.push(AppRoutes.settings),
                  tooltip: 'Pengaturan',
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: profileAsync.when(
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
                  onEditTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit profil belum tersedia')),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: Divider(height: 24)),
            SliverToBoxAdapter(
              child: HomeMenuGrid(
                onMenuTap: (label) {
                  if (label == 'UI Gallery') {
                    context.push('/ui-gallery');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$label — Fitur belum tersedia')),
                    );
                  }
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 32 + MediaQuery.of(context).padding.bottom,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
