import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/routes/social_routes.dart';
import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/club_entity.dart';
import '../clubs_providers.dart';

/// Club directory + search (task 2.8), with a "my clubs" toggle.
class ClubsDirectoryScreen extends ConsumerStatefulWidget {
  const ClubsDirectoryScreen({super.key});

  @override
  ConsumerState<ClubsDirectoryScreen> createState() => _ClubsDirectoryScreenState();
}

class _ClubsDirectoryScreenState extends ConsumerState<ClubsDirectoryScreen> {
  final _search = TextEditingController();
  String _query = '';
  bool _mineOnly = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = _mineOnly
        ? ref.watch(myClubsProvider)
        : ref.watch(clubDirectoryProvider(search: _query.isEmpty ? null : _query));

    return Scaffold(
      appBar: AppBar(title: const Text('Klub')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(SocialRoutes.createClub),
        icon: const Icon(Icons.add),
        label: const Text('Buat Klub'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(ManahSpacing.base),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Cari klub / kota',
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.base),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Semua')),
                ButtonSegment(value: true, label: Text('Klub Saya')),
              ],
              selected: {_mineOnly},
              onSelectionChanged: (s) => setState(() => _mineOnly = s.first),
            ),
          ),
          const SizedBox(height: ManahSpacing.sm),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Gagal memuat: $e')),
              data: (clubs) => clubs.isEmpty
                  ? const Center(child: Text('Belum ada klub.'))
                  : RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(clubDirectoryProvider);
                        ref.invalidate(myClubsProvider);
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.all(ManahSpacing.base),
                        itemCount: clubs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: ManahSpacing.sm),
                        itemBuilder: (context, i) => _ClubCard(club: clubs[i]),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubCard extends StatelessWidget {
  const _ClubCard({required this.club});
  final ClubEntity club;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => context.push(SocialRoutes.clubDetail(club.id)),
        leading: CircleAvatar(
          backgroundColor: ManahColors.brandSurface,
          backgroundImage: club.logoUrl != null ? NetworkImage(club.logoUrl!) : null,
          child: club.logoUrl == null ? const Icon(Icons.groups, color: ManahColors.brand) : null,
        ),
        title: Row(
          children: [
            Flexible(child: Text(club.name, overflow: TextOverflow.ellipsis)),
            if (club.isVerified) ...[
              const SizedBox(width: 4),
              const Icon(Icons.verified, size: 16, color: ManahColors.info),
            ],
          ],
        ),
        subtitle: Text(
          [if (club.location.isNotEmpty) club.location, '${club.memberCount} anggota'].join(' · '),
        ),
        trailing: club.isMember ? const Icon(Icons.check_circle, color: ManahColors.success) : null,
      ),
    );
  }
}
