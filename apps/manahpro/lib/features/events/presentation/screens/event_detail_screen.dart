import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/event_entity.dart';
import '../../domain/event_registration_entity.dart';
import '../../identity/presentation/profile_providers.dart';
import '../events_providers.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  const EventDetailScreen({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    final asyncEvent = ref.watch(eventDetailsProvider(widget.eventId));
    final asyncProfile = ref.watch(myProfileProvider);
    final asyncTickets = ref.watch(myTicketsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: asyncEvent.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(ManahSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: ManahColors.error),
                  const SizedBox(height: ManahSpacing.sm),
                  Text('Gagal memuat event', style: ManahTextStyles.h3),
                  const SizedBox(height: ManahSpacing.xs),
                  Text(error.toString(), textAlign: TextAlign.center),
                  const SizedBox(height: ManahSpacing.md),
                  ElevatedButton(
                    onPressed: () => ref.refresh(eventDetailsProvider(widget.eventId)),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
        data: (event) {
          final registered = event.divisions.fold<int>(0, (sum, div) => sum + div.numParticipants);
          final capacity = event.capacity ?? 0;
          final isFull = capacity > 0 && registered >= capacity;

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 240,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(
                      left: ManahSpacing.base,
                      bottom: ManahSpacing.base,
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        event.bannerUrl != null && event.bannerUrl!.isNotEmpty
                            ? Image.network(event.bannerUrl!, fit: BoxFit.cover)
                            : Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [ManahColors.brand, ManahColors.brandLight],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.track_changes,
                                  size: 72,
                                  color: Colors.white,
                                ),
                              ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.88)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(ManahSpacing.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: ManahSpacing.sm,
                                vertical: ManahSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: ManahColors.brandLight.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(ManahRadius.sm),
                              ),
                              child: Text(
                                'TIER ${event.tier.value}',
                                style: ManahTextStyles.label.copyWith(
                                  color: ManahColors.brand,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: ManahSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: ManahSpacing.sm,
                                vertical: ManahSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: ManahColors.info.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(ManahRadius.sm),
                              ),
                              child: Text(
                                event.format.label,
                                style: ManahTextStyles.label.copyWith(
                                  color: ManahColors.info,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: ManahSpacing.sm),
                        Text(
                          event.title,
                          style: ManahTextStyles.h2,
                        ),
                        const SizedBox(height: ManahSpacing.md),
                        _buildOrganizerCard(event, isDark),
                        const SizedBox(height: ManahSpacing.base),
                        // Quick details card
                        _buildQuickDetails(event, isDark),
                        if (capacity > 0) ...[
                          const SizedBox(height: ManahSpacing.base),
                          _buildCapacityProgress(registered, capacity, isFull),
                        ],
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverTabHeaderDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: ManahColors.brand,
                      unselectedLabelColor: ManahColors.mediumGrey,
                      indicatorColor: ManahColors.brand,
                      tabs: const [
                        Tab(text: 'Tentang'),
                        Tab(text: 'Divisi'),
                        Tab(text: 'Jadwal & Aturan'),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildAboutTab(event),
                _buildDivisionsTab(event, isDark),
                _buildScheduleTab(event),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: asyncEvent.whenOrNull(
        data: (event) {
          final isRegOpen = event.isRegistrationOpen;
          final registered = event.divisions.fold<int>(0, (sum, div) => sum + div.numParticipants);
          final capacity = event.capacity ?? 0;
          final isFull = capacity > 0 && registered >= capacity;

          // Determine price range
          String priceStr = 'Gratis';
          if (event.divisions.isNotEmpty) {
            final fees = event.divisions.map((d) => d.entryFee).toList();
            final minFee = fees.reduce((a, b) => a < b ? a : b);
            final maxFee = fees.reduce((a, b) => a > b ? a : b);
            final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

            if (minFee == 0 && maxFee == 0) {
              priceStr = 'Gratis';
            } else if (minFee == maxFee) {
              priceStr = formatter.format(minFee);
            } else {
              priceStr = '${formatter.format(minFee)} - ${formatter.format(maxFee)}';
            }
          }

          EventRegistrationEntity? myTicket;
          final tickets = asyncTickets.value ?? const [];
          for (final t in tickets) {
            if (t.event?.id == event.id || event.divisions.any((d) => d.id == t.eventDivisionId)) {
              myTicket = t;
              break;
            }
          }

          final profile = asyncProfile.value;
          final isOrganizer = profile != null && event.createdBy == profile.id;

          return _buildStickyBottom(
            event,
            isRegOpen,
            isFull,
            priceStr,
            isOrganizer: isOrganizer,
            myTicketId: myTicket?.id,
          );
        },
      ),
    );
  }

  Widget _buildOrganizerCard(EventEntity event, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(ManahSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? ManahColors.darkSurface : ManahColors.lightGrey,
        borderRadius: BorderRadius.circular(ManahRadius.md),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ManahColors.brandLight.withOpacity(0.2),
            backgroundImage: event.organizationLogo != null
                ? NetworkImage(event.organizationLogo!)
                : null,
            child: event.organizationLogo == null
                ? const Icon(Icons.business, color: ManahColors.brand)
                : null,
          ),
          const SizedBox(width: ManahSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.organizationName ?? 'Penyelenggara Umum',
                  style: ManahTextStyles.bodyM.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Penyelenggara Event',
                  style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDetails(EventEntity event, bool isDark) {
    final startsStr = DateFormat('EEEE, dd MMM yyyy · HH:mm', 'id').format(event.startsAt);
    return Card(
      elevation: 0,
      color: isDark ? ManahColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
        borderRadius: BorderRadius.circular(ManahRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.base),
        child: Column(
          children: [
            _DetailItemRow(
              icon: Icons.calendar_today_outlined,
              title: 'Waktu Pelaksanaan',
              subtitle: startsStr,
            ),
            const Divider(height: 24),
            _DetailItemRow(
              icon: Icons.location_on_outlined,
              title: 'Lokasi Event',
              subtitle: event.locationLabel,
              desc: event.address,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapacityProgress(int registered, int capacity, bool isFull) {
    final progress = registered / capacity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kapasitas Pendaftaran', style: ManahTextStyles.bodyM.copyWith(fontWeight: FontWeight.bold)),
            Text('$registered / $capacity Peserta', style: ManahTextStyles.bodyM.copyWith(color: ManahColors.brand, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: ManahSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(ManahRadius.sm),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: ManahColors.lightGrey,
            valueColor: AlwaysStoppedAnimation<Color>(
              isFull ? ManahColors.error : ManahColors.brand,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutTab(EventEntity event) {
    return ListView(
      padding: const EdgeInsets.all(ManahSpacing.base),
      children: [
        Text('Deskripsi Event', style: ManahTextStyles.h3),
        const SizedBox(height: ManahSpacing.sm),
        Text(
          event.description ?? 'Tidak ada deskripsi untuk event ini.',
          style: ManahTextStyles.bodyL.copyWith(height: 1.6),
        ),
        const SizedBox(height: ManahSpacing.xl),
      ],
    );
  }

  Widget _buildDivisionsTab(EventEntity event, bool isDark) {
    if (event.divisions.isEmpty) {
      return const Center(child: Text('Tidak ada informasi divisi untuk event ini.'));
    }

    final theme = Theme.of(context);
    final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return ListView.separated(
      padding: const EdgeInsets.all(ManahSpacing.base),
      itemCount: event.divisions.length,
      separatorBuilder: (_, __) => const SizedBox(height: ManahSpacing.base),
      itemBuilder: (context, index) {
        final division = event.divisions[index];
        final isDivFull = division.capacity != null && division.numParticipants >= division.capacity!;

        return Card(
          elevation: 0,
          color: isDark ? ManahColors.darkSurface : ManahColors.lightGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ManahRadius.md),
          ),
          child: Padding(
            padding: const EdgeInsets.all(ManahSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        division.displayName,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.sm, vertical: 2),
                      decoration: BoxDecoration(
                        color: ManahColors.brand.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(ManahRadius.sm),
                      ),
                      child: Text(
                        currencyFormatter.format(division.entryFee),
                        style: ManahTextStyles.bodyS.copyWith(
                          color: ManahColors.brand,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: ManahSpacing.md),
                Row(
                  children: [
                    _IconTextInfo(
                      icon: Icons.track_changes,
                      text: '${division.distanceM} Meter',
                    ),
                    const SizedBox(width: ManahSpacing.base),
                    _IconTextInfo(
                      icon: Icons.grid_3x3,
                      text: '${division.numArrows} Anak Panah',
                    ),
                    const SizedBox(width: ManahSpacing.base),
                    _IconTextInfo(
                      icon: Icons.sports_score,
                      text: 'Max: ${division.maxScore}',
                    ),
                  ],
                ),
                if (division.capacity != null && division.capacity! > 0) ...[
                  const SizedBox(height: ManahSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kuota Divisi: ${division.numParticipants} / ${division.capacity}',
                        style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                      ),
                      if (isDivFull)
                        const Text(
                          'Penuh',
                          style: TextStyle(color: ManahColors.error, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScheduleTab(EventEntity event) {
    return ListView(
      padding: const EdgeInsets.all(ManahSpacing.base),
      children: [
        Text('Aturan & Ketentuan', style: ManahTextStyles.h3),
        const SizedBox(height: ManahSpacing.sm),
        Text(
          event.rules ?? 'Mengikuti peraturan standar PB Perpani.',
          style: ManahTextStyles.bodyL.copyWith(height: 1.6),
        ),
        const SizedBox(height: ManahSpacing.xl),
        Text('Jadwal Pelaksanaan', style: ManahTextStyles.h3),
        const SizedBox(height: ManahSpacing.sm),
        if (event.schedule != null && event.schedule!.isNotEmpty)
          ...event.schedule!.map((item) {
            final title = item['title']?.toString() ?? '';
            final time = item['time']?.toString() ?? '';
            return Padding(
              padding: const EdgeInsets.only(bottom: ManahSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      time,
                      style: ManahTextStyles.bodyM.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ManahColors.brand,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: ManahTextStyles.bodyM,
                    ),
                  ),
                ],
              ),
            );
          })
        else
          const Text('Jadwal detail akan segera diperbarui oleh panitia.'),
        const SizedBox(height: ManahSpacing.xl),
      ],
    );
  }
  Widget _buildStickyBottom(
    EventEntity event,
    bool isRegOpen,
    bool isFull,
    String priceStr, {
    required bool isOrganizer,
    String? myTicketId,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String btnText = 'Daftar Sekarang';
    bool canClick = isRegOpen && !isFull;
    VoidCallback? onClick = () => context.push('/events/${event.id}/register');

    if (isOrganizer) {
      btnText = 'Kelola Peserta';
      canClick = true;
      onClick = () => context.push('/events/${event.id}/participants');
    } else if (myTicketId != null) {
      btnText = 'Lihat E-Tiket';
      canClick = true;
      onClick = () => context.push('/tickets/$myTicketId');
    } else {
      if (!isRegOpen) {
        btnText = 'Pendaftaran Ditutup';
        canClick = false;
        onClick = null;
      } else if (isFull) {
        btnText = 'Kapasitas Penuh';
        canClick = false;
        onClick = null;
      }
    }

    return Container(
      padding: const EdgeInsets.all(ManahSpacing.base),
      decoration: BoxDecoration(
        color: isDark ? ManahColors.darkSurface : Colors.white,
        border: Border(
          top: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Biaya Pendaftaran',
                    style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                  ),
                  Text(
                    priceStr,
                    style: ManahTextStyles.h3.copyWith(
                      color: ManahColors.brand,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: canClick ? onClick : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: ManahColors.brand,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: ManahSpacing.lg,
                  vertical: ManahSpacing.base,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ManahRadius.md),
                ),
              ),
              child: Text(btnText),
            ),
          ],
        ),
      ),
    );
  }}

  void _showRegistrationConfirmation(BuildContext context, EventEntity event) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrasi Event'),
          content: Text(
            'Apakah Anda ingin mendaftar di event "${event.title}"?\n\nRegistrasi lengkap (pembayaran Midtrans/Xendit) akan diproses pada tahap berikutnya.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pendaftaran berhasil direkam (fitur pembayaran menyusul di Phase 3.6).'),
                    backgroundColor: ManahColors.success,
                  ),
                );
              },
              child: const Text('Daftar'),
            ),
          ],
        );
      },
    );
  }
}

class _SliverTabHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabHeaderDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? ManahColors.darkSurface : Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabHeaderDelegate oldDelegate) {
    return false;
  }
}

class _DetailItemRow extends StatelessWidget {
  const _DetailItemRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.desc,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? desc;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: ManahColors.brand, size: 24),
        const SizedBox(width: ManahSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: ManahTextStyles.bodyS.copyWith(
                  color: ManahColors.mediumGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: ManahTextStyles.bodyM.copyWith(fontWeight: FontWeight.w600),
              ),
              if (desc != null && desc!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  desc!,
                  style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _IconTextInfo extends StatelessWidget {
  const _IconTextInfo({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: ManahColors.mediumGrey),
        const SizedBox(width: ManahSpacing.xs),
        Text(
          text,
          style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
        ),
      ],
    );
  }
}
