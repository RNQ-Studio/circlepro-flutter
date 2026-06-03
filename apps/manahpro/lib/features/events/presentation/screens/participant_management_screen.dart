import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/event_enums.dart';
import '../../domain/event_registration_entity.dart';
import '../events_providers.dart';

class ParticipantManagementScreen extends ConsumerStatefulWidget {
  const ParticipantManagementScreen({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  ConsumerState<ParticipantManagementScreen> createState() => _ParticipantManagementScreenState();
}

class _ParticipantManagementScreenState extends ConsumerState<ParticipantManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncParticipants = ref.watch(eventParticipantsProvider(widget.eventId));
    final asyncEvent = ref.watch(eventDetailsProvider(widget.eventId));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kelola Peserta'),
            asyncEvent.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (event) => Text(
                event.title,
                style: ManahTextStyles.bodyS.copyWith(
                  color: ManahColors.mediumGrey,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: ManahColors.brand,
          unselectedLabelColor: ManahColors.mediumGrey,
          indicatorColor: ManahColors.brand,
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Dikonfirmasi'),
            Tab(text: 'Hadir'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.all(ManahSpacing.base),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama atlet atau BIB...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ManahBorderRadius.button),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Participants list
          Expanded(
            child: asyncParticipants.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Text('Gagal memuat peserta: $err'),
              ),
              data: (participants) {
                // Apply search filter
                final filtered = participants.where((p) {
                  final name = p.userName?.toLowerCase() ?? '';
                  final bib = p.bibNumber?.toLowerCase() ?? '';
                  return name.contains(_searchQuery) || bib.contains(_searchQuery);
                }).toList();

                // Split by tabs
                final all = filtered;
                final confirmed = filtered.where((p) => p.status == RegistrationStatus.confirmed).toList();
                final checkedIn = filtered.where((p) => p.status == RegistrationStatus.checkedIn).toList();

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildParticipantsList(all, isDark),
                    _buildParticipantsList(confirmed, isDark),
                    _buildParticipantsList(checkedIn, isDark),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openScannerMock(context),
        label: const Text('Pindai Tiket (Scan)'),
        icon: const Icon(Icons.qr_code_scanner),
        backgroundColor: ManahColors.brand,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildParticipantsList(List<EventRegistrationEntity> list, bool isDark) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(ManahSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.people_outline,
                size: 64,
                color: ManahColors.mediumGrey,
              ),
              const SizedBox(height: ManahSpacing.sm),
              Text(
                'Belum ada peserta terdaftar',
                style: ManahTextStyles.h3.copyWith(color: ManahColors.mediumGrey),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(eventParticipantsProvider(widget.eventId));
        await ref.read(eventParticipantsProvider(widget.eventId).future);
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(ManahSpacing.base),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: ManahSpacing.sm),
        itemBuilder: (context, index) {
          final registration = list[index];
          final division = registration.division;

          Color statusColor = ManahColors.warning;
          if (registration.status == RegistrationStatus.confirmed) {
            statusColor = ManahColors.brand;
          } else if (registration.status == RegistrationStatus.checkedIn) {
            statusColor = ManahColors.success;
          } else if (registration.status == RegistrationStatus.cancelled) {
            statusColor = ManahColors.error;
          }

          return Card(
            elevation: 1,
            color: isDark ? ManahColors.darkSurface : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ManahBorderRadius.card),
            ),
            child: Padding(
              padding: const EdgeInsets.all(ManahSpacing.base),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: ManahColors.brand.withValues(alpha: 0.1),
                    child: registration.userAvatarUrl != null
                        ? ClipOval(child: Image.network(registration.userAvatarUrl!, fit: BoxFit.cover))
                        : Text(
                            registration.userName?.substring(0, 1).toUpperCase() ?? 'A',
                            style: const TextStyle(
                              color: ManahColors.brand,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                  ),
                  const SizedBox(width: ManahSpacing.base),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          registration.userName ?? 'Pemanah',
                          style: ManahTextStyles.h4,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'BIB: ${registration.bibNumber ?? "-"}',
                          style: ManahTextStyles.bodyS.copyWith(
                            color: ManahColors.brand,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${division?.bowClass.label} - ${division?.ageGroup.label}',
                          style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: ManahSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          registration.status.label,
                          style: ManahTextStyles.badge.copyWith(color: statusColor),
                        ),
                      ),
                      const SizedBox(height: ManahSpacing.sm),
                      if (registration.status == RegistrationStatus.confirmed)
                        ElevatedButton(
                          onPressed: () => _handleCheckIn(registration),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ManahColors.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            minimumSize: const Size(60, 28),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text('Check-in', style: TextStyle(fontSize: 12)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleCheckIn(EventRegistrationEntity registration) async {
    try {
      final repo = ref.read(eventsRepositoryProvider);
      await repo.checkInParticipant(registration.id);
      ref.invalidate(eventParticipantsProvider(widget.eventId));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Check-in berhasil untuk ${registration.userName}.'),
          backgroundColor: ManahColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal melakukan check-in: ${e.toString()}'),
          backgroundColor: ManahColors.error,
        ),
      );
    }
  }

  /// Opens a mock camera QR scanner sheet.
  void _openScannerMock(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _MockScannerSheet(
          eventId: widget.eventId,
          onSuccessCheckIn: () {
            ref.invalidate(eventParticipantsProvider(widget.eventId));
          },
        );
      },
    );
  }
}

class _MockScannerSheet extends ConsumerStatefulWidget {
  const _MockScannerSheet({
    required this.eventId,
    required this.onSuccessCheckIn,
  });

  final String eventId;
  final VoidCallback onSuccessCheckIn;

  @override
  ConsumerState<_MockScannerSheet> createState() => _MockScannerSheetState();
}

class _MockScannerSheetState extends ConsumerState<_MockScannerSheet> {
  bool _isScanning = true;
  bool _isSuccess = false;
  EventRegistrationEntity? _detectedRegistration;
  double _greenLinePosition = 0.0;
  late Timer _lineTimer;
  late Timer _detectTimer;

  @override
  void initState() {
    super.initState();

    // Animate green scanning line
    _lineTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (mounted) {
        setState(() {
          _greenLinePosition = (_greenLinePosition + 0.02) % 1.0;
        });
      }
    });

    // Detect random participant after 2 seconds
    _detectTimer = Timer(const Duration(seconds: 2), _simulateScanDetection);
  }

  @override
  void dispose() {
    _lineTimer.cancel();
    _detectTimer.cancel();
    super.dispose();
  }

  Future<void> _simulateScanDetection() async {
    if (!mounted) return;

    try {
      final participants = await ref.read(eventParticipantsProvider(widget.eventId).future);

      // Find any confirmed participant to check in
      final target = participants.firstWhere(
        (p) => p.status == RegistrationStatus.confirmed,
        orElse: () => throw Exception('Tidak ada peserta terdaftar dengan status Dikonfirmasi (menunggu check-in).'),
      );

      // Call API
      final updated = await ref.read(eventsRepositoryProvider).checkInParticipant(target.id);

      widget.onSuccessCheckIn();

      setState(() {
        _isScanning = false;
        _isSuccess = true;
        _detectedRegistration = updated;
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
        _isSuccess = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().contains('tidak ditemukan') || e.toString().contains('status Dikonfirmasi')
              ? 'Tidak ada tiket valid yang dapat dipindai.'
              : 'Error check-in: ${e.toString()}'),
          backgroundColor: ManahColors.error,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: isDark ? ManahColors.darkBg : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(ManahSpacing.xl),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: ManahSpacing.lg),

          if (_isScanning) ...[
            Text('Memindai Tiket', style: ManahTextStyles.h2),
            const SizedBox(height: 4),
            Text(
              'Arahkan kamera ke QR Code tiket peserta',
              style: ManahTextStyles.bodyM.copyWith(color: ManahColors.mediumGrey),
            ),
            const Spacer(),

            // Visual Camera Frame Scanner Overlay
            Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: Stack(
                  children: [
                    // Outer border corner guides
                    _buildScannerFrameGuides(),

                    // Camera background simulation (dark/translucent overlay)
                    Positioned.fill(
                      child: Container(
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.qr_code_2,
                          color: Colors.white12,
                          size: 150,
                        ),
                      ),
                    ),

                    // Green scanning laser line
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 20),
                      top: 15 + (_greenLinePosition * 220),
                      left: 15,
                      right: 15,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent[400],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.greenAccent[400]!.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),
            Text(
              'Mensimulasikan deteksi kamera...',
              style: ManahTextStyles.bodyS.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: ManahSpacing.lg),
          ] else if (_isSuccess && _detectedRegistration != null) ...[
            const Spacer(),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ManahColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: ManahColors.success, width: 3),
              ),
              child: const Icon(Icons.check, size: 48, color: ManahColors.success),
            ),
            const SizedBox(height: ManahSpacing.lg),
            Text('Check-in Sukses!', style: ManahTextStyles.h2.copyWith(color: ManahColors.success)),
            const SizedBox(height: ManahSpacing.base),

            // Card details
            Card(
              elevation: 1,
              color: isDark ? ManahColors.darkSurface : Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(ManahSpacing.base),
                child: Column(
                  children: [
                    Text(
                      _detectedRegistration!.userName ?? 'Pemanah',
                      style: ManahTextStyles.h3,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'BIB: ${_detectedRegistration!.bibNumber ?? "-"}',
                      style: ManahTextStyles.h4.copyWith(color: ManahColors.brand),
                    ),
                    const Divider(),
                    Text(
                      'Divisi: ${_detectedRegistration!.division?.bowClass.label} - ${_detectedRegistration!.division?.ageGroup.label}',
                      style: ManahTextStyles.bodyM,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: ManahColors.brand,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ManahBorderRadius.button),
                ),
              ),
              child: const Text('Tutup'),
            ),
            const SizedBox(height: ManahSpacing.lg),
          ],
        ],
      ),
    );
  }

  Widget _buildScannerFrameGuides() {
    const double borderSize = 25.0;
    const double thickness = 4.0;
    const Color color = ManahColors.brand;

    return Stack(
      children: [
        // Top Left
        Positioned(
          top: 0,
          left: 0,
          child: Container(width: borderSize, height: thickness, color: color),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(width: thickness, height: borderSize, color: color),
        ),

        // Top Right
        Positioned(
          top: 0,
          right: 0,
          child: Container(width: borderSize, height: thickness, color: color),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(width: thickness, height: borderSize, color: color),
        ),

        // Bottom Left
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(width: borderSize, height: thickness, color: color),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(width: thickness, height: borderSize, color: color),
        ),

        // Bottom Right
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(width: borderSize, height: thickness, color: color),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(width: thickness, height: borderSize, color: color),
        ),
      ],
    );
  }
}
