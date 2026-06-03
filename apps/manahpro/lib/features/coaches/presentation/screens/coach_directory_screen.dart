import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../coaches_providers.dart';
import '../../domain/coach_profile_entity.dart';

class CoachDirectoryScreen extends ConsumerStatefulWidget {
  const CoachDirectoryScreen({super.key});

  @override
  ConsumerState<CoachDirectoryScreen> createState() => _CoachDirectoryScreenState();
}

class _CoachDirectoryScreenState extends ConsumerState<CoachDirectoryScreen> {
  final _searchCtrl = TextEditingController();
  String? _selectedSpecialty;
  String? _selectedCity;
  String _searchQuery = '';

  final List<String> _specialties = [
    'recurve',
    'compound',
    'barebow_standard',
    'barebow_tradisional',
    'horsebow',
    'jemparingan',
  ];

  final List<String> _cities = [
    'Surabaya',
    'Malang',
    'Jakarta',
    'Bandung',
    'Yogyakarta',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _formatSpecialtyName(String spec) {
    switch (spec) {
      case 'recurve':
        return 'Recurve';
      case 'compound':
        return 'Compound';
      case 'barebow_standard':
        return 'Barebow Standard';
      case 'barebow_tradisional':
        return 'Barebow Tradisional';
      case 'horsebow':
        return 'Horsebow';
      case 'jemparingan':
        return 'Jemparingan';
      default:
        return spec;
    }
  }

  @override
  Widget build(BuildContext context) {
    final coachesAsync = ref.watch(coachDirectoryProvider(
      search: _searchQuery,
      specialty: _selectedSpecialty,
      city: _selectedCity,
    ));

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Direktori Pelatih', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Search & Filter Panel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.base, vertical: ManahSpacing.sm),
            color: theme.cardColor,
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Cari pelatih berdasarkan nama...',
                    prefixIcon: const Icon(Icons.search, color: ManahColors.mediumGrey),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onSubmitted: (val) {
                    setState(() => _searchQuery = val.trim());
                  },
                ),
                const SizedBox(height: ManahSpacing.sm),
                // Specialty Chips List
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: ManahSpacing.xs),
                        child: ChoiceChip(
                          label: const Text('Semua Spesialisasi', style: TextStyle(fontSize: 12)),
                          selected: _selectedSpecialty == null,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedSpecialty = null);
                          },
                        ),
                      ),
                      ..._specialties.map((spec) {
                        return Padding(
                          padding: const EdgeInsets.only(right: ManahSpacing.xs),
                          child: ChoiceChip(
                            label: Text(_formatSpecialtyName(spec), style: const TextStyle(fontSize: 12)),
                            selected: _selectedSpecialty == spec,
                            onSelected: (selected) {
                              setState(() => _selectedSpecialty = selected ? spec : null);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: ManahSpacing.xs),
                // City Chips List
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: ManahSpacing.xs),
                        child: ChoiceChip(
                          label: const Text('Semua Kota', style: TextStyle(fontSize: 12)),
                          selected: _selectedCity == null,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedCity = null);
                          },
                        ),
                      ),
                      ..._cities.map((city) {
                        return Padding(
                          padding: const EdgeInsets.only(right: ManahSpacing.xs),
                          child: ChoiceChip(
                            label: Text(city, style: const TextStyle(fontSize: 12)),
                            selected: _selectedCity == city,
                            onSelected: (selected) {
                              setState(() => _selectedCity = selected ? city : null);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: ManahSpacing.sm),
          // Coaches List
          Expanded(
            child: coachesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Gagal memuat daftar pelatih: $err')),
              data: (coaches) {
                if (coaches.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(ManahSpacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search_outlined, size: 64, color: theme.dividerColor),
                          const SizedBox(height: ManahSpacing.base),
                          Text(
                            'Tidak ada pelatih ditemukan',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: ManahSpacing.xs),
                          const Text(
                            'Coba gunakan kata kunci pencarian atau filter yang berbeda.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: ManahColors.mediumGrey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(coachDirectoryProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(ManahSpacing.base),
                    itemCount: coaches.length,
                    itemBuilder: (context, index) {
                      final coach = coaches[index];
                      return _CoachCard(coach: coach);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CoachCard extends StatelessWidget {
  const _CoachCard({required this.coach});

  final CoachProfileEntity coach;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = coach.user;

    return GestureDetector(
      onTap: () => context.push('/coaches/${coach.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: ManahSpacing.base),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(ManahBorderRadius.card),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(ManahSpacing.base),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: ManahColors.brandSurface,
                backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                    ? Text(
                        user.displayName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ManahColors.brand,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: ManahSpacing.base),
              // Coach Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.displayName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (coach.isVerified) ...[
                          const SizedBox(width: ManahSpacing.xs),
                          const Icon(Icons.verified, color: ManahColors.brand, size: 16),
                        ],
                      ],
                    ),
                    const SizedBox(height: ManahSpacing.xs),
                    // Rating & City
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          coach.averageRating > 0 ? coach.averageRating.toStringAsFixed(1) : 'Baru',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        if (coach.reviewsCount > 0) ...[
                          const SizedBox(width: 4),
                          Text(
                            '(${coach.reviewsCount} ulasan)',
                            style: const TextStyle(color: ManahColors.mediumGrey, fontSize: 12),
                          ),
                        ],
                        const SizedBox(width: ManahSpacing.xs),
                        const Text('•', style: TextStyle(color: ManahColors.mediumGrey)),
                        const SizedBox(width: ManahSpacing.xs),
                        Expanded(
                          child: Text(
                            user.location.isNotEmpty ? user.location : 'Luar Kota',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: ManahColors.mediumGrey, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: ManahSpacing.sm),
                    // Specialties Chips
                    Wrap(
                      spacing: ManahSpacing.xs,
                      runSpacing: ManahSpacing.xs,
                      children: coach.specialties.take(3).map((spec) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: ManahColors.brandSurface,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            spec.replaceAll('_', ' ').toUpperCase(),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: ManahColors.brand,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: ManahSpacing.base),
                    // Experience & Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${coach.experienceYears} Tahun Pengalaman',
                          style: const TextStyle(fontSize: 12, color: ManahColors.darkGrey),
                        ),
                        Text(
                          'Rp ${_formatHourlyRate(coach.hourlyRate)}/jam',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: ManahColors.brand,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatHourlyRate(double rate) {
    if (rate >= 1000) {
      return '${(rate / 1000).toStringAsFixed(0)}K';
    }
    return rate.toStringAsFixed(0);
  }
}
