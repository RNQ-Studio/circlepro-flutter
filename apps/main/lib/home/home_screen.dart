import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

import 'home_fake_data.dart';
import 'widgets/home_user_header.dart';
import 'widgets/home_menu_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
              child: HomeUserHeader(
                name: kFakeUserName,
                email: kFakeUserEmail,
                gender: kFakeUserGender,
                age: kFakeUserAge,
                city: kFakeUserCity,
                onEditTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit profil belum tersedia')),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: Divider(height: 24)),
            SliverToBoxAdapter(
              child: HomeMenuGrid(
                onMenuTap: (label) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$label — Fitur belum tersedia')),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
