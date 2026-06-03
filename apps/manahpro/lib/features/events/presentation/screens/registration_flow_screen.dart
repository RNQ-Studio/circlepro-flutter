import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/event_division_entity.dart';
import '../../domain/event_enums.dart';
import '../../domain/event_registration_entity.dart';
import '../../identity/presentation/profile_providers.dart';
import '../events_providers.dart';

class RegistrationFlowScreen extends ConsumerStatefulWidget {
  const RegistrationFlowScreen({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  ConsumerState<RegistrationFlowScreen> createState() => _RegistrationFlowScreenState();
}

class _RegistrationFlowScreenState extends ConsumerState<RegistrationFlowScreen> {
  EventDivisionEntity? _selectedDivision;
  bool _isLoading = false;
  EventRegistrationEntity? _successRegistration;

  @override
  Widget build(BuildContext context) {
    final asyncEvent = ref.watch(eventDetailsProvider(widget.eventId));
    final asyncProfile = ref.watch(myProfileProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Handle success view
    if (_successRegistration != null) {
      return _buildSuccessScreen(_successRegistration!, isDark);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran Event'),
        elevation: 0,
      ),
      body: asyncEvent.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: ManahColors.error),
              const SizedBox(height: ManahSpacing.base),
              Text('Gagal memuat detail event', style: ManahTextStyles.h3),
              const SizedBox(height: ManahSpacing.sm),
              ElevatedButton(
                onPressed: () => ref.refresh(eventDetailsProvider(widget.eventId)),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (event) {
          // Pre-select first division if not already selected
          if (_selectedDivision == null && event.divisions.isNotEmpty) {
            _selectedDivision = event.divisions.first;
          }

          return asyncProfile.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Text('Gagal memuat profil: $err'),
            ),
            data: (profile) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: ManahSpacing.base,
                      right: ManahSpacing.base,
                      top: ManahSpacing.base,
                      bottom: 100, // Space for sticky bottom button
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Banner Info card
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ManahBorderRadius.card),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(ManahSpacing.base),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(ManahBorderRadius.small),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    color: isDark ? Colors.grey[900] : Colors.grey[200],
                                    child: event.bannerUrl != null
                                        ? Image.network(event.bannerUrl!, fit: BoxFit.cover)
                                        : const Icon(Icons.event, size: 40, color: ManahColors.mediumGrey),
                                  ),
                                ),
                                const SizedBox(width: ManahSpacing.base),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: ManahSpacing.xs,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ManahColors.brandSurface,
                                          borderRadius: BorderRadius.circular(ManahBorderRadius.badge),
                                        ),
                                        child: Text(
                                          event.tier.label,
                                          style: ManahTextStyles.badge.copyWith(color: ManahColors.brand),
                                        ),
                                      ),
                                      const SizedBox(height: ManahSpacing.xs),
                                      Text(
                                        event.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: ManahTextStyles.h3,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        event.venueName ?? 'Lokasi tidak ditentukan',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: ManahSpacing.lg),

                        // Section 1: Choose Division
                        Text('Pilih Divisi Perlombaan', style: ManahTextStyles.h3),
                        const SizedBox(height: ManahSpacing.xs),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: event.divisions.length,
                          separatorBuilder: (_, __) => const SizedBox(height: ManahSpacing.sm),
                          itemBuilder: (context, index) {
                            final div = event.divisions[index];
                            final isSelected = _selectedDivision?.id == div.id;
                            final isFull = div.capacity != null && div.numParticipants >= div.capacity!;

                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? ManahColors.brand
                                      : (isDark ? Colors.grey[850]! : Colors.grey[300]!),
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(ManahBorderRadius.card),
                                color: isSelected
                                    ? ManahColors.brand.withValues(alpha: 0.05)
                                    : (isDark ? ManahColors.darkSurface : Colors.white),
                              ),
                              child: ListTile(
                                enabled: !isFull,
                                onTap: () {
                                  setState(() {
                                    _selectedDivision = div;
                                  });
                                },
                                title: Text(
                                  '${div.bowClass.label} - ${div.ageGroup.label} (${div.gender.label})',
                                  style: ManahTextStyles.h4.copyWith(
                                    color: isFull ? ManahColors.mediumGrey : null,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Jarak: ${div.distanceM}m | ${div.numArrows} Anak Panah'),
                                    const SizedBox(height: 2),
                                    Text(
                                      isFull
                                          ? 'Kuota Penuh'
                                          : 'Kuota terisi: ${div.numParticipants}/${div.capacity ?? "∞"}',
                                      style: TextStyle(
                                        color: isFull ? ManahColors.error : ManahColors.mediumGrey,
                                        fontWeight: isFull ? FontWeight.bold : null,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Radio<EventDivisionEntity>(
                                  value: div,
                                  groupValue: _selectedDivision,
                                  activeColor: ManahColors.brand,
                                  onChanged: isFull
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _selectedDivision = value;
                                          });
                                        },
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: ManahSpacing.lg),

                        // Section 2: Athlete Data Confirmation
                        Text('Konfirmasi Data Atlet', style: ManahTextStyles.h3),
                        const SizedBox(height: ManahSpacing.xs),
                        Card(
                          elevation: 1,
                          color: isDark ? ManahColors.darkSurface : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ManahBorderRadius.card),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(ManahSpacing.base),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow('Nama Atlet', profile.displayName),
                                const Divider(),
                                _buildDetailRow('Jenis Kelamin', profile.gender == 'female' ? 'Putri' : 'Putra'),
                                const Divider(),
                                _buildDetailRow('Asal Daerah', '${profile.city ?? "-"}, ${profile.province ?? "-"}'),
                                const Divider(),
                                _buildDetailRow(
                                  'Status Akun',
                                  'Aktif (Terverifikasi)',
                                  valueColor: ManahColors.success,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: ManahSpacing.base),
                        Container(
                          padding: const EdgeInsets.all(ManahSpacing.sm),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.amber.withValues(alpha: 0.1) : Colors.amber[50],
                            border: Border.all(color: Colors.amber[600]!),
                            borderRadius: BorderRadius.circular(ManahBorderRadius.small),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.payment, color: Colors.amber[800]),
                              const SizedBox(width: ManahSpacing.sm),
                              Expanded(
                                child: Text(
                                  'Catatan: Integrasi payment gateway ditangguhkan. Pendaftaran Anda akan langsung dikonfirmasi (GRATIS).',
                                  style: ManahTextStyles.bodyS.copyWith(
                                    color: isDark ? Colors.amber[200] : Colors.amber[900],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sticky Bottom CTA bar
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(ManahSpacing.base),
                      decoration: BoxDecoration(
                        color: isDark ? ManahColors.darkBg : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -3),
                          ),
                        ],
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
                                    'Total Pembayaran',
                                    style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                                  ),
                                  Text(
                                    'Gratis',
                                    style: ManahTextStyles.h2.copyWith(color: ManahColors.success),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: ManahSpacing.base),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _selectedDivision == null || _isLoading
                                    ? null
                                    : () => _handleRegistration(_selectedDivision!),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ManahColors.brand,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: ManahSpacing.base),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(ManahBorderRadius.button),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor: AlwaysStoppedAnimation(Colors.white),
                                        ),
                                      )
                                    : const Text('Daftar Sekarang'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: ManahTextStyles.bodyM.copyWith(color: ManahColors.mediumGrey)),
          Text(
            value,
            style: ManahTextStyles.bodyM.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegistration(EventDivisionEntity division) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final repo = ref.read(eventsRepositoryProvider);
      final result = await repo.registerForEvent(widget.eventId, division.id);

      // Invalidate events list and details to refresh counts
      ref.invalidate(eventDetailsProvider(widget.eventId));
      ref.invalidate(myEventsProvider);
      ref.invalidate(myTicketsProvider);

      setState(() {
        _isLoading = false;
        _successRegistration = result;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pendaftaran gagal: ${e.toString()}'),
          backgroundColor: ManahColors.error,
        ),
      );
    }
  }

  Widget _buildSuccessScreen(EventRegistrationEntity reg, bool isDark) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(ManahSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Animated checkmark
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: ManahColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ManahColors.success,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 56,
                    color: ManahColors.success,
                  ),
                ),
              ),
              const SizedBox(height: ManahSpacing.xl),
              Text(
                'Pendaftaran Berhasil!',
                textAlign: TextAlign.center,
                style: ManahTextStyles.h1.copyWith(color: ManahColors.success),
              ),
              const SizedBox(height: ManahSpacing.sm),
              Text(
                'Anda telah terdaftar secara resmi di event ini.',
                textAlign: TextAlign.center,
                style: ManahTextStyles.bodyM.copyWith(color: ManahColors.mediumGrey),
              ),
              const SizedBox(height: ManahSpacing.xl),

              // Mock Ticket graphic
              Container(
                padding: const EdgeInsets.all(ManahSpacing.base),
                decoration: BoxDecoration(
                  color: isDark ? ManahColors.darkSurface : Colors.grey[100],
                  border: Border.all(
                    color: isDark ? Colors.grey[850]! : Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(ManahBorderRadius.card),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reg.event?.title ?? 'Detail Event',
                      style: ManahTextStyles.h3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: ManahSpacing.xs),
                    Text(
                      'Divisi: ${reg.division?.bowClass.label} - ${reg.division?.ageGroup.label}',
                      style: ManahTextStyles.bodyM.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: ManahSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nomor BIB',
                              style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                            ),
                            Text(
                              reg.bibNumber ?? '-',
                              style: ManahTextStyles.h3.copyWith(color: ManahColors.brand),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Status',
                              style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: ManahColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                reg.status.label,
                                style: ManahTextStyles.badge.copyWith(color: ManahColors.success),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  context.pop(); // Pop back
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ManahColors.brand,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: ManahSpacing.base),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ManahBorderRadius.button),
                  ),
                ),
                child: const Text('Kembali ke Event'),
              ),
              const SizedBox(height: ManahSpacing.base),
            ],
          ),
        ),
      ),
    );
  }
}
