import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/event_enums.dart';
import '../../domain/event_registration_entity.dart';
import '../events_providers.dart';

class TicketDetailScreen extends ConsumerWidget {
  const TicketDetailScreen({
    super.key,
    required this.ticketId,
  });

  final String ticketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTickets = ref.watch(myTicketsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Tiket Saya'),
        elevation: 0,
      ),
      body: asyncTickets.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: ManahColors.error),
              const SizedBox(height: ManahSpacing.base),
              Text('Gagal memuat tiket', style: ManahTextStyles.h3),
              const SizedBox(height: ManahSpacing.sm),
              ElevatedButton(
                onPressed: () => ref.refresh(myTicketsProvider),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (tickets) {
          final ticket = tickets.firstWhere(
            (t) => t.id == ticketId,
            orElse: () => throw Exception('Tiket tidak ditemukan'),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(ManahSpacing.base),
            child: Column(
              children: [
                _buildTicketCard(context, ticket, isDark),
                const SizedBox(height: ManahSpacing.lg),
                _buildInstructionsCard(isDark),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, EventRegistrationEntity ticket, bool isDark) {
    final event = ticket.event;
    final division = ticket.division;

    final dateStr = event != null
        ? '${event.startsAt.day}/${event.startsAt.month}/${event.startsAt.year}'
        : '-';

    Color statusColor = ManahColors.warning;
    if (ticket.status == RegistrationStatus.confirmed) {
      statusColor = ManahColors.brand;
    } else if (ticket.status == RegistrationStatus.checkedIn) {
      statusColor = ManahColors.success;
    } else if (ticket.status == RegistrationStatus.cancelled) {
      statusColor = ManahColors.error;
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? ManahColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ManahBorderRadius.card),
        border: Border.all(
          color: isDark ? Colors.grey[850]! : Colors.grey[300]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Event Info section
          Padding(
            padding: const EdgeInsets.all(ManahSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: ManahColors.brandSurface,
                        borderRadius: BorderRadius.circular(ManahBorderRadius.badge),
                      ),
                      child: Text(
                        event?.tier.label ?? '-',
                        style: ManahTextStyles.badge.copyWith(color: ManahColors.brand),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ManahBorderRadius.badge),
                      ),
                      child: Text(
                        ticket.status.label.toUpperCase(),
                        style: ManahTextStyles.badge.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: ManahSpacing.sm),
                Text(
                  event?.title ?? 'Detail Event',
                  style: ManahTextStyles.h2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: ManahColors.mediumGrey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event?.venueName ?? 'Lokasi tidak ditentukan',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 16, color: ManahColors.mediumGrey),
                    const SizedBox(width: 4),
                    Text(
                      dateStr,
                      style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Cut-out divider
          Row(
            children: [
              Container(
                width: 16,
                height: 24,
                decoration: BoxDecoration(
                  color: isDark ? ManahColors.darkBg : ManahColors.lightGrey,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  border: Border.all(
                    color: isDark ? Colors.grey[850]! : Colors.grey[300]!,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: List.generate(
                          (constraints.constrainWidth() / 10).floor(),
                          (index) => SizedBox(
                            width: 5,
                            height: 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[800] : Colors.grey[400],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: 16,
                height: 24,
                decoration: BoxDecoration(
                  color: isDark ? ManahColors.darkBg : ManahColors.lightGrey,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  border: Border.all(
                    color: isDark ? Colors.grey[850]! : Colors.grey[300]!,
                  ),
                ),
              ),
            ],
          ),

          // QR Code and Athlete Info section
          Padding(
            padding: const EdgeInsets.all(ManahSpacing.base),
            child: Column(
              children: [
                Text(
                  ticket.userName ?? 'Nama Pendaftar',
                  style: ManahTextStyles.h3,
                ),
                const SizedBox(height: 2),
                Text(
                  'Divisi: ${division?.bowClass.label} - ${division?.ageGroup.label}',
                  style: ManahTextStyles.bodyM.copyWith(color: ManahColors.mediumGrey),
                ),
                const SizedBox(height: ManahSpacing.base),

                // Barcode / QR Code representation
                Container(
                  padding: const EdgeInsets.all(ManahSpacing.base),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      // Renders visual representation of QR code
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: CustomPaint(
                          painter: QrMockPainter(data: ticket.qrCode ?? ticket.id),
                        ),
                      ),
                      const SizedBox(height: ManahSpacing.sm),
                      Text(
                        ticket.bibNumber ?? '-',
                        style: ManahTextStyles.h3.copyWith(
                          color: Colors.black87,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: ManahSpacing.sm),
                Text(
                  'Tunjukkan QR Code di atas kepada panitia\nuntuk verifikasi kehadiran (Check-in).',
                  textAlign: TextAlign.center,
                  style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard(bool isDark) {
    return Card(
      elevation: 0,
      color: isDark ? ManahColors.darkSurface : Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManahBorderRadius.card),
        side: BorderSide(color: isDark ? Colors.grey[850]! : Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: ManahColors.brand),
                const SizedBox(width: ManahSpacing.sm),
                Text('Petunjuk Kehadiran', style: ManahTextStyles.h4),
              ],
            ),
            const SizedBox(height: ManahSpacing.sm),
            _buildStepRow('1', 'Tiba di venue pertandingan paling lambat 30 menit sebelum event dimulai.'),
            _buildStepRow('2', 'Buka aplikasi ManahPro dan tunjukkan halaman E-Tiket ini kepada panitia di meja registrasi.'),
            _buildStepRow('3', 'Panitia akan memindai QR Code untuk mengonfirmasi kehadiran Anda.'),
            _buildStepRow('4', 'Setelah check-in berhasil, Anda akan menerima nomor dada fisik (BIB) dan dapat memasuki area perlombaan.'),
          ],
        ),
      ),
    );
  }

  Widget _buildStepRow(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: ManahColors.brand,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: ManahSpacing.sm),
          Expanded(
            child: Text(text, style: ManahTextStyles.bodyS),
          ),
        ],
      ),
    );
  }
}

/// Custom painter to draw a realistic looking mock QR code.
class QrMockPainter extends CustomPainter {
  QrMockPainter({required this.data});

  final String data;

  @override
  void paint(Canvas canvas, Size size) {
    final paintBlack = Paint()..color = Colors.black;
    final paintWhite = Paint()..color = Colors.white;

    // Draw background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paintWhite);

    // Grid size (e.g. 21x21 blocks)
    const int gridCount = 21;
    final double cellSize = size.width / gridCount;

    // Seeded random based on QR code data string hash
    final Random random = Random(data.hashCode);

    // Generate grid blocks
    for (int y = 0; y < gridCount; y++) {
      for (int x = 0; x < gridCount; x++) {
        // Draw standard QR Finder Patterns at three corners:
        // Top-Left (0-6, 0-6), Top-Right (14-20, 0-6), Bottom-Left (0-6, 14-20)
        final bool isTopLeft = x < 7 && y < 7;
        final bool isTopRight = x > 13 && y < 7;
        final bool isBottomLeft = x < 7 && y > 13;

        if (isTopLeft || isTopRight || isBottomLeft) {
          // Draw Finder Pattern (7x7 outer square, 5x5 white inner, 3x3 black core)
          final int localX = isTopLeft ? x : (isTopRight ? x - 14 : x);
          final int localY = isTopLeft ? y : (isTopRight ? y : y - 14);

          final bool isOuterBorder = localX == 0 || localX == 6 || localY == 0 || localY == 6;
          final bool isInnerWhite = localX == 1 || localX == 5 || localY == 1 || localY == 5;

          if (isOuterBorder) {
            canvas.drawRect(Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize), paintBlack);
          } else if (isInnerWhite) {
            canvas.drawRect(Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize), paintWhite);
          } else {
            canvas.drawRect(Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize), paintBlack);
          }
        } else {
          // Draw random black/white blocks representing data payload
          if (random.nextBool()) {
            canvas.drawRect(
              Rect.fromLTWH(x * cellSize, y * cellSize, cellSize + 0.5, cellSize + 0.5),
              paintBlack,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
