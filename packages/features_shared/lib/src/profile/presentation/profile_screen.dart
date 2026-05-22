import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_provider.dart';
import 'profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.errorGeneral)),
        data: (profile) => profile == null
            ? Center(child: Text(l10n.errorGeneral))
            : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      child: Text(
                        profile.name.isNotEmpty
                            ? profile.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(l10n.name),
                    subtitle: Text(profile.name),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: Text(l10n.email),
                    subtitle: Text(profile.email),
                  ),
                  const Divider(height: 32),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(l10n.logout),
                    onTap: () =>
                        ref.read(authNotifierProvider.notifier).logout(),
                  ),
                ],
              ),
      ),
    );
  }
}
