import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/club_entity.dart';
import '../clubs_providers.dart';

/// Club detail + membership (tasks 2.8/2.9): info, join/leave, member list.
class ClubDetailScreen extends ConsumerStatefulWidget {
  const ClubDetailScreen({super.key, required this.clubId});

  final String clubId;

  @override
  ConsumerState<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends ConsumerState<ClubDetailScreen> {
  bool _busy = false;

  Future<void> _toggleMembership(ClubEntity club) async {
    setState(() => _busy = true);
    try {
      final repo = ref.read(clubsRepositoryProvider);
      if (club.isMember) {
        await repo.leave(club.id);
      } else {
        await repo.join(club.id);
      }
      ref.invalidate(clubDetailProvider(widget.clubId));
      ref.invalidate(clubMembersProvider(widget.clubId));
      ref.invalidate(myClubsProvider);
      ref.invalidate(clubDirectoryProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(clubDetailProvider(widget.clubId));

    return Scaffold(
      appBar: AppBar(title: const Text('Klub')),
      body: SafeArea(
        top: false,
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Gagal memuat: $e')),
          data: (club) => ListView(
            padding: const EdgeInsets.all(ManahSpacing.base),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: ManahColors.brandSurface,
                    backgroundImage: club.logoUrl != null ? NetworkImage(club.logoUrl!) : null,
                    child: club.logoUrl == null ? const Icon(Icons.groups, color: ManahColors.brand) : null,
                  ),
                  const SizedBox(width: ManahSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(club.name, style: Theme.of(context).textTheme.headlineSmall),
                        if (club.location.isNotEmpty)
                          Text(club.location, style: Theme.of(context).textTheme.bodyMedium),
                        Text('${club.memberCount} anggota', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
              if (club.description != null && club.description!.isNotEmpty) ...[
                const SizedBox(height: ManahSpacing.base),
                Text(club.description!),
              ],
              const SizedBox(height: ManahSpacing.lg),
              FilledButton.icon(
                onPressed: _busy ? null : () => _toggleMembership(club),
                style: club.isMember
                    ? FilledButton.styleFrom(backgroundColor: ManahColors.mediumGrey)
                    : null,
                icon: Icon(club.isMember ? Icons.check : Icons.add),
                label: Text(club.isMember ? 'Keluar dari Klub' : 'Gabung Klub'),
              ),
              const SizedBox(height: ManahSpacing.lg),
              Text('Anggota', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: ManahSpacing.sm),
              _MembersList(clubId: widget.clubId),
            ],
          ),
        ),
      ),
    );
  }
}

class _MembersList extends ConsumerWidget {
  const _MembersList({required this.clubId});
  final String clubId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(clubMembersProvider(clubId));
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(ManahSpacing.base),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('Gagal memuat anggota: $e'),
      data: (members) => Column(
        children: members
            .map((m) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: ManahColors.brandSurface,
                    backgroundImage: m.avatarUrl != null ? NetworkImage(m.avatarUrl!) : null,
                    child: m.avatarUrl == null ? const Icon(Icons.person, color: ManahColors.brand, size: 20) : null,
                  ),
                  title: Text(m.fullName ?? m.username ?? 'Anggota'),
                  trailing: _RoleChip(role: m.role),
                ))
            .toList(),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.role});
  final String role;

  @override
  Widget build(BuildContext context) {
    final isStaff = role == 'owner' || role == 'admin' || role == 'coach';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isStaff ? ManahColors.brandSurface : Theme.of(context).dividerColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(ManahRadius.full),
      ),
      child: Text(role, style: TextStyle(fontSize: 11, color: isStaff ? ManahColors.brand : null)),
    );
  }
}
