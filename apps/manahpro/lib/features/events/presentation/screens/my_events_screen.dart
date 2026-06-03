import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/event_entity.dart';
import '../../domain/event_registration_entity.dart';
import '../events_providers.dart';
import '../events_routes.dart';
import '../widgets/event_card.dart';

class MyEventsScreen extends ConsumerStatefulWidget {
  const MyEventsScreen({super.key});

  @override
  ConsumerState<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends ConsumerState<MyEventsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _roleSegmentIndex = 0; // 0 = Sebagai Atlet, 1 = Sebagai Penyelenggara

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Saya'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(88),
          child: Column(
            children: [
              // Cupertio segmented control toggle role
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.base),
                child: SizedBox(
                  width: double.infinity,
                  child: CupertinoSegmentedControl<int>(
                    groupValue: _roleSegmentIndex,
                    selectedColor: ManahColors.brand,
                    borderColor: ManahColors.brand,
                    unselectedColor: isDark ? ManahColors.darkSurface : Colors.white,
                    pressedColor: ManahColors.brand.withValues(alpha: 0.2),
                    children: const {
                      0: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('Sebagai Atlet', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      1: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('Sebagai Penyelenggara', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    },
                    onValueChanged: (value) {
                      setState(() {
                        _roleSegmentIndex = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TabBar(
                controller: _tabController,
                labelColor: ManahColors.brand,
                unselectedLabelColor: ManahColors.mediumGrey,
                indicatorColor: ManahColors.brand,
                tabs: const [
                  Tab(text: 'Mendatang'),
                  Tab(text: 'Berlangsung'),
                  Tab(text: 'Selesai'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _roleSegmentIndex == 0 ? _buildAthleteView(isDark) : _buildOrganizerView(isDark),
    );
  }

  // ─── ATHLETE MODE: E-Tickets ──────────────────────────────────────────────

  Widget _buildAthleteView(bool isDark) {
    final asyncTickets = ref.watch(myTicketsProvider);

    return asyncTickets.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _buildErrorState(error.toString(), myTicketsProvider),
      data: (tickets) {
        final now = DateTime.now();

        final upcoming = tickets.where((t) => t.event != null && t.event!.startsAt.isAfter(now)).toList();
        final live = tickets.where((t) {
          if (t.event == null) return false;
          final start = t.event!.startsAt;
          final end = t.event!.endsAt ?? t.event!.startsAt.add(const Duration(days: 1));
          return start.isBefore(now) && end.isAfter(now);
        }).toList();
        final completed = tickets.where((t) {
          if (t.event == null) return false;
          final end = t.event!.endsAt ?? t.event!.startsAt.add(const Duration(days: 1));
          return end.isBefore(now);
        }).toList();

        return TabBarView(
          controller: _tabController,
          children: [
            _buildTicketsList(upcoming, 'Belum ada tiket event mendatang.', isDark),
            _buildTicketsList(live, 'Tidak ada event yang sedang berlangsung saat ini.', isDark),
            _buildTicketsList(completed, 'Belum ada riwayat tiket event yang selesai.', isDark),
          ],
        );
      },
    );
  }

  Widget _buildTicketsList(List<EventRegistrationEntity> list, String emptyMessage, bool isDark) {
    if (list.isEmpty) {
      return _buildEmptyState(emptyMessage);
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(myTicketsProvider);
        await ref.read(myTicketsProvider.future);
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(ManahSpacing.base),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: ManahSpacing.base),
        itemBuilder: (context, index) {
          final ticket = list[index];
          final event = ticket.event;

          return Card(
            elevation: 1,
            color: isDark ? ManahColors.darkSurface : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ManahBorderRadius.card),
              side: Border.all(color: isDark ? Colors.grey[850]! : Colors.grey[200]!),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(ManahBorderRadius.card),
              onTap: () => context.push('/tickets/${ticket.id}'),
              child: Padding(
                padding: const EdgeInsets.all(ManahSpacing.base),
                child: Row(
                  children: [
                    // Mock Badge visual matching event format
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: ManahColors.brand.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.qr_code, color: ManahColors.brand),
                    ),
                    const SizedBox(width: ManahSpacing.base),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event?.title ?? 'Detail Event',
                            style: ManahTextStyles.h4,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'BIB: ${ticket.bibNumber ?? "-"} | Divisi: ${ticket.division?.bowClass.label}',
                            style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: ManahColors.brandSurface,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              ticket.status.label,
                              style: ManahTextStyles.badge.copyWith(color: ManahColors.brand),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: ManahSpacing.sm),
                    const Icon(Icons.chevron_right, color: ManahColors.mediumGrey),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── ORGANIZER MODE: Event Creator ────────────────────────────────────────

  Widget _buildOrganizerView(bool isDark) {
    final asyncEvents = ref.watch(myEventsProvider);

    return asyncEvents.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _buildErrorState(error.toString(), myEventsProvider),
      data: (events) {
        final now = DateTime.now();

        final upcoming = events.where((e) => e.startsAt.isAfter(now)).toList();
        final live = events.where((e) {
          final start = e.startsAt;
          final end = e.endsAt ?? e.startsAt.add(const Duration(days: 1));
          return start.isBefore(now) && end.isAfter(now);
        }).toList();
        final completed = events.where((e) {
          final end = e.endsAt ?? e.startsAt.add(const Duration(days: 1));
          return end.isBefore(now);
        }).toList();

        return TabBarView(
          controller: _tabController,
          children: [
            _buildOrganizerEventList(upcoming, 'Belum ada event mendatang yang dibuat.', isDark),
            _buildOrganizerEventList(live, 'Tidak ada event yang sedang berlangsung saat ini.', isDark),
            _buildOrganizerEventList(completed, 'Belum ada riwayat event yang selesai.', isDark),
          ],
        );
      },
    );
  }

  Widget _buildOrganizerEventList(List<EventEntity> list, String emptyMessage, bool isDark) {
    if (list.isEmpty) {
      return _buildEmptyState(emptyMessage);
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(myEventsProvider);
        await ref.read(myEventsProvider.future);
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(ManahSpacing.base),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: ManahSpacing.base),
        itemBuilder: (context, index) {
          final event = list[index];
          return Column(
            children: [
              EventCard(
                event: event,
                onTap: () => context.push(EventsRoutes.detail(event.id)),
              ),
              const SizedBox(height: 4),
              // Action buttons for organizer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => context.push('/events/${event.id}/participants'),
                    icon: const Icon(Icons.people, size: 16),
                    label: const Text('Kelola Peserta', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ManahColors.brand,
                      side: const BorderSide(color: ManahColors.brand),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      minimumSize: const Size(120, 32),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── SHARDS ───────────────────────────────────────────────────────────────

  Widget _buildErrorState(String message, ProviderOrFamily provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: ManahColors.error),
            const SizedBox(height: ManahSpacing.sm),
            Text('Gagal memuat data', style: ManahTextStyles.h3),
            const SizedBox(height: ManahSpacing.xs),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: ManahSpacing.md),
            ElevatedButton(
              onPressed: () => ref.refresh(provider),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event_busy_outlined,
              size: 64,
              color: ManahColors.mediumGrey,
            ),
            const SizedBox(height: ManahSpacing.base),
            Text(
              message,
              textAlign: TextAlign.center,
              style: ManahTextStyles.bodyL.copyWith(
                color: ManahColors.mediumGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
