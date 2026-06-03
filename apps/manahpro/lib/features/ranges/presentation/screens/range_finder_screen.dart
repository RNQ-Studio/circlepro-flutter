import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../ranges_providers.dart';
import '../../domain/archery_range_entity.dart';

class RangeFinderScreen extends ConsumerStatefulWidget {
  const RangeFinderScreen({super.key});

  @override
  ConsumerState<RangeFinderScreen> createState() => _RangeFinderScreenState();
}

class _RangeFinderScreenState extends ConsumerState<RangeFinderScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String? _selectedFacility;
  bool _useMyLocation = false;

  // Surabaya mock coordinates
  final double _mockLat = -7.2759;
  final double _mockLng = 112.7756;

  final List<String> _facilities = [
    'toilet',
    'parking',
    'canteen',
    'rental',
    'musholla',
    'indoor',
    'outdoor',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _formatFacilityName(String fac) {
    return fac[0].toUpperCase() + fac.substring(1);
  }

  Future<void> _openMapRoute(ArcheryRangeEntity range) async {
    if (range.latitude == null || range.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Koordinat lapangan tidak tersedia')),
      );
      return;
    }

    final url = 'https://www.google.com/maps/search/?api=1&query=${range.latitude},${range.longitude}';
    try {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka peta Google Maps')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuka rute: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rangesAsync = ref.watch(rangeDirectoryProvider(
      search: _searchQuery,
      facility: _selectedFacility,
      latitude: _useMyLocation ? _mockLat : null,
      longitude: _useMyLocation ? _mockLng : null,
    ));

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Lapangan', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Filter Panel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.base, vertical: ManahSpacing.sm),
            color: theme.cardColor,
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Cari lapangan berdasarkan nama/kota...',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Urutkan berdasarkan terdekat:',
                      style: TextStyle(fontSize: 12, color: ManahColors.darkGrey),
                    ),
                    Switch.adaptive(
                      value: _useMyLocation,
                      activeColor: ManahColors.brand,
                      onChanged: (val) {
                        setState(() => _useMyLocation = val);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: ManahSpacing.xs),
                // Facility chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: ManahSpacing.xs),
                        child: ChoiceChip(
                          label: const Text('Semua Fasilitas', style: TextStyle(fontSize: 12)),
                          selected: _selectedFacility == null,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedFacility = null);
                          },
                        ),
                      ),
                      ..._facilities.map((fac) {
                        return Padding(
                          padding: const EdgeInsets.only(right: ManahSpacing.xs),
                          child: ChoiceChip(
                            label: Text(_formatFacilityName(fac), style: const TextStyle(fontSize: 12)),
                            selected: _selectedFacility == fac,
                            onSelected: (selected) {
                              setState(() => _selectedFacility = selected ? fac : null);
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
          // Ranges Directory List
          Expanded(
            child: rangesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Gagal memuat daftar lapangan: $err')),
              data: (ranges) {
                if (ranges.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(ManahSpacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_outlined, size: 64, color: theme.dividerColor),
                          const SizedBox(height: ManahSpacing.base),
                          Text(
                            'Tidak ada lapangan ditemukan',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: ManahSpacing.xs),
                          const Text(
                            'Silakan ubah filter fasilitas atau kata kunci pencarian Anda.',
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
                    ref.invalidate(rangeDirectoryProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(ManahSpacing.base),
                    itemCount: ranges.length,
                    itemBuilder: (context, index) {
                      final range = ranges[index];
                      return _RangeCard(
                        range: range,
                        onOpenMap: () => _openMapRoute(range),
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
}

class _RangeCard extends StatelessWidget {
  const _RangeCard({required this.range, required this.onOpenMap});

  final ArcheryRangeEntity range;
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.decimalPattern('id');

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner/Image or Premium Static Map mockup
          Stack(
            children: [
              if (range.imageUrl != null && range.imageUrl!.isNotEmpty)
                Image.network(
                  range.imageUrl!,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, _, __) => _buildMockupMapBanner(),
                )
              else
                _buildMockupMapBanner(),
              // Price Badge
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Rp ${currencyFormat.format(range.pricePerHour)}/jam',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Distance Badge
              if (range.distance != null)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ManahColors.brand,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.navigation_outlined, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '${range.distance!.toStringAsFixed(1)} km',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(ManahSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  range.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: ManahSpacing.xs),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: ManahColors.mediumGrey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        range.location.isNotEmpty ? range.location : 'Lokasi tidak diset',
                        style: const TextStyle(fontSize: 12, color: ManahColors.mediumGrey),
                      ),
                    ),
                  ],
                ),
                if (range.description != null && range.description!.isNotEmpty) ...[
                  const SizedBox(height: ManahSpacing.sm),
                  Text(
                    range.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: ManahColors.darkGrey),
                  ),
                ],
                const SizedBox(height: ManahSpacing.sm),
                // Facilities list
                Wrap(
                  spacing: ManahSpacing.xs,
                  runSpacing: ManahSpacing.xs,
                  children: range.facilities.map((fac) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.dividerColor.withValues(alpha: 0.05),
                        border: Border.all(color: theme.dividerColor, width: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        fac.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: ManahColors.darkGrey,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: ManahSpacing.base),
                Row(
                  children: [
                    if (range.phone != null && range.phone!.isNotEmpty) ...[
                      OutlinedButton.icon(
                        onPressed: () => launchUrlString('tel:${range.phone}'),
                        icon: const Icon(Icons.phone, size: 16),
                        label: const Text('Telepon', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      const SizedBox(width: ManahSpacing.sm),
                    ],
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: onOpenMap,
                        icon: const Icon(Icons.directions, size: 16),
                        label: const Text('Rute Peta', style: TextStyle(fontSize: 12)),
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockupMapBanner() {
    return Container(
      height: 140,
      width: double.infinity,
      color: ManahColors.brandSurface,
      child: CustomPaint(
        painter: _MockMapPainter(),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 36, color: ManahColors.brand),
              SizedBox(height: 4),
              Text(
                'Static Map Preview',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: ManahColors.brand,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MockMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ManahColors.brand.withValues(alpha: 0.08)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw mock streets grid
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.3), paint);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.7), paint);
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height), paint);
    canvas.drawLine(Offset(size.width * 0.7, 0), Offset(size.width * 0.7, size.height), paint);

    // Draw diagonal street
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);

    // Draw some mock buildings/parks
    final parkPaint = Paint()
      ..color = Colors.green.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.05, size.height * 0.4, size.width * 0.2, size.height * 0.2),
        const Radius.circular(8),
      ),
      parkPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
