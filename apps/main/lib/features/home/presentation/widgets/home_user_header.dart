import 'package:flutter/material.dart';

import '../../domain/entities/user_profile.dart';

class HomeUserHeader extends StatelessWidget {
  const HomeUserHeader({
    super.key,
    required this.profile,
    required this.onEditTap,
  });

  final UserProfile profile;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.person,
              size: 40,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${profile.name}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(profile.email, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 2),
                Text(
                  '${profile.gender} | Usia ${profile.age} | Domisili di ${profile.city}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEditTap,
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit profil',
          ),
        ],
      ),
    );
  }
}
