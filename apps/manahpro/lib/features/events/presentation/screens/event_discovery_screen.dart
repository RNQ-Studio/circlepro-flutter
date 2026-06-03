import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/event_enums.dart';
import '../events_providers.dart';
import '../events_routes.dart';
import '../widgets/event_card.dart';

class EventDiscoveryScreen extends ConsumerStatefulWidget {
  const EventDiscoveryScreen({super.key});

  @override
  ConsumerState<EventDiscoveryScreen> createState() => _EventDiscoveryScreenState();
}

class _EventDiscoveryScreenState extends ConsumerState<EventDiscoveryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(eventFiltersStateProvider);
    final asyncEvents = ref.watch(eventsListProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Penjelajahan Event'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_library_books_outlined),
            tooltip: 'Event Saya',
            onPressed: () => context.push(EventsRoutes.my),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(EventsRoutes.create),
        icon: const Icon(Icons.add),
        label: const Text('Buat Event'),
        backgroundColor: ManahColors.brand,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              ManahSpacing.base,
              ManahSpacing.sm,
              ManahSpacing.base,
              ManahSpacing.sm,
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari event...',
                    prefixIcon: const Icon(Icons.search, color: ManahColors.mediumGrey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: ManahColors.mediumGrey),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(eventFiltersStateProvider.notifier).updateSearch(null);
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ManahRadius.md),
                      borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.black12,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ManahRadius.md),
                      borderSide: const BorderSide(color: ManahColors.brand, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: ManahSpacing.sm),
                    filled: true,
                    fillColor: isDark ? ManahColors.darkSurface : Colors.white,
                  ),
                  onChanged: (val) {
                    ref.read(eventFiltersStateProvider.notifier).updateSearch(val.isEmpty ? null : val);
                  },
                ),
                const SizedBox(height: ManahSpacing.sm),
                // Horizontal filters
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Tier filter chip
                      _FilterChipWidget(
                        label: filters.tier != null ? 'Tier: ${filters.tier}' : 'Semua Tier',
                        isActive: filters.tier != null,
                        onTap: () => _showTierSelector(context),
                      ),
                      const SizedBox(width: ManahSpacing.sm),
                      // Format filter chip
                      _FilterChipWidget(
                        label: filters.format != null
                            ? EventFormat.fromValue(filters.format).label
                            : 'Semua Format',
                        isActive: filters.format != null,
                        onTap: () => _showFormatSelector(context),
                      ),
                      const SizedBox(width: ManahSpacing.sm),
                      // Status filter chip
                      _FilterChipWidget(
                        label: filters.status != null
                            ? EventStatus.fromValue(filters.status).label
                            : 'Semua Status',
                        isActive: filters.status != null,
                        onTap: () => _showStatusSelector(context),
                      ),
                      const SizedBox(width: ManahSpacing.sm),
                      // Location filter chip
                      _FilterChipWidget(
                        label: filters.city ?? 'Semua Lokasi',
                        isActive: filters.city != null,
                        onTap: () => _showCitySelector(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Event list
          Expanded(
            child: asyncEvents.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(ManahSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: ManahColors.error),
                      const SizedBox(height: ManahSpacing.sm),
                      Text(
                        'Gagal memuat daftar event',
                        style: ManahTextStyles.h3,
                      ),
                      const SizedBox(height: ManahSpacing.xs),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: ManahTextStyles.bodyM.copyWith(color: ManahColors.mediumGrey),
                      ),
                      const SizedBox(height: ManahSpacing.md),
                      ElevatedButton(
                        onPressed: () => ref.refresh(eventsListProvider),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (events) {
                if (events.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(ManahSpacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.emoji_events_outlined,
                            size: 72,
                            color: ManahColors.mediumGrey,
                          ),
                          const SizedBox(height: ManahSpacing.base),
                          Text(
                            'Tidak ada event ditemukan',
                            style: ManahTextStyles.h3,
                          ),
                          const SizedBox(height: ManahSpacing.sm),
                          Text(
                            'Coba bersihkan filter pencarian atau ubah kriteria untuk menemukan event menarik.',
                            textAlign: TextAlign.center,
                            style: ManahTextStyles.bodyM.copyWith(
                              color: ManahColors.mediumGrey,
                            ),
                          ),
                          const SizedBox(height: ManahSpacing.lg),
                          TextButton.icon(
                            onPressed: () {
                              _searchController.clear();
                              ref.read(eventFiltersStateProvider.notifier).reset();
                            },
                            icon: const Icon(Icons.restart_alt),
                            label: const Text('Reset Filter'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(eventsListProvider);
                    await ref.read(eventsListProvider.future);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ManahSpacing.base,
                      vertical: ManahSpacing.base,
                    ),
                    itemCount: events.length,
                    separatorBuilder: (_, __) => const SizedBox(height: ManahSpacing.base),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return EventCard(
                        event: event,
                        onTap: () => context.push(EventsRoutes.detail(event.id)),
                      );
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

  void _showTierSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final currentTier = ref.read(eventFiltersStateProvider).tier;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: const Text('Pilih Tier Event'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              ListTile(
                title: const Text('Semua Tier'),
                selected: currentTier == null,
                onTap: () {
                  ref.read(eventFiltersStateProvider.notifier).updateTier(null);
                  Navigator.pop(context);
                },
              ),
              ...EventTier.values.map(
                (tier) => ListTile(
                  title: Text(tier.label),
                  selected: currentTier == tier.value,
                  onTap: () {
                    ref.read(eventFiltersStateProvider.notifier).updateTier(tier.value);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFormatSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final currentFormat = ref.read(eventFiltersStateProvider).format;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: const Text('Pilih Format Event'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              ListTile(
                title: const Text('Semua Format'),
                selected: currentFormat == null,
                onTap: () {
                  ref.read(eventFiltersStateProvider.notifier).updateFormat(null);
                  Navigator.pop(context);
                },
              ),
              ...EventFormat.values.map(
                (format) => ListTile(
                  title: Text(format.label),
                  selected: currentFormat == format.value,
                  onTap: () {
                    ref.read(eventFiltersStateProvider.notifier).updateFormat(format.value);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStatusSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final currentStatus = ref.read(eventFiltersStateProvider).status;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: const Text('Pilih Status Event'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              ListTile(
                title: const Text('Semua Status'),
                selected: currentStatus == null,
                onTap: () {
                  ref.read(eventFiltersStateProvider.notifier).updateStatus(null);
                  Navigator.pop(context);
                },
              ),
              ...EventStatus.values.map(
                (status) => ListTile(
                  title: Text(status.label),
                  selected: currentStatus == status.value,
                  onTap: () {
                    ref.read(eventFiltersStateProvider.notifier).updateStatus(status.value);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCitySelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final currentCity = ref.read(eventFiltersStateProvider).city;
        final majorCities = ['Jakarta', 'Bandung', 'Surabaya', 'Yogyakarta', 'Solo', 'Semarang', 'Medan', 'Makassar'];

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: const Text('Pilih Kota'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              ListTile(
                title: const Text('Semua Lokasi'),
                selected: currentCity == null,
                onTap: () {
                  ref.read(eventFiltersStateProvider.notifier).updateCity(null);
                  Navigator.pop(context);
                },
              ),
              ...majorCities.map(
                (city) => ListTile(
                  title: Text(city),
                  selected: currentCity == city,
                  onTap: () {
                    ref.read(eventFiltersStateProvider.notifier).updateCity(city);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChipWidget extends StatelessWidget {
  const _FilterChipWidget({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(label),
      selected: isActive,
      onPressed: onTap,
      selectedColor: ManahColors.brandSurface,
      labelStyle: TextStyle(
        color: isActive ? ManahColors.brand : Colors.black87,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: ManahColors.brand,
    );
  }
}
