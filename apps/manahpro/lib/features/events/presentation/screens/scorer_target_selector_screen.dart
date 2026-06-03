import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../events_providers.dart';

class ScorerTargetSelectorScreen extends ConsumerStatefulWidget {
  const ScorerTargetSelectorScreen({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  ConsumerState<ScorerTargetSelectorScreen> createState() => _ScorerTargetSelectorScreenState();
}

class _ScorerTargetSelectorScreenState extends ConsumerState<ScorerTargetSelectorScreen> {
  String? _selectedDivisionId;

  @override
  Widget build(BuildContext context) {
    final asyncEvent = ref.watch(eventDetailsProvider(widget.eventId));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Skor - Pilih Target'),
        elevation: 0,
      ),
      body: asyncEvent.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat event: $err')),
        data: (event) {
          if (event.divisions.isEmpty) {
            return const Center(child: Text('Event ini tidak memiliki divisi.'));
          }

          if (_selectedDivisionId == null || !event.divisions.any((d) => d.id == _selectedDivisionId)) {
            _selectedDivisionId = event.divisions.first.id;
          }

          return Padding(
            padding: const EdgeInsets.all(ManahSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Pilih Divisi Pertandingan',
                  style: ManahTextStyles.h3,
                ),
                const SizedBox(height: ManahSpacing.sm),
                DropdownButtonFormField<String>(
                  value: _selectedDivisionId,
                  decoration: const InputDecoration(
                    labelText: 'Divisi',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: event.divisions.map((d) {
                    return DropdownMenuItem<String>(
                      value: d.id,
                      child: Text(
                        d.displayName,
                        style: ManahTextStyles.bodyM.copyWith(fontWeight: FontWeight.w600),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedDivisionId = val;
                    });
                  },
                ),
                const SizedBox(height: ManahSpacing.lg),
                Text(
                  '2. Pilih Nomor Bantalan Target',
                  style: ManahTextStyles.h3,
                ),
                const SizedBox(height: ManahSpacing.xs),
                Text(
                  'Pilih bantalan target tempat Anda bertugas sebagai juri skor.',
                  style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                ),
                const SizedBox(height: ManahSpacing.base),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: ManahSpacing.sm,
                      mainAxisSpacing: ManahSpacing.sm,
                      childAspectRatio: 1,
                    ),
                    itemCount: 20, // Display targets 1 to 20
                    itemBuilder: (context, index) {
                      final targetNumber = index + 1;

                      return Card(
                        elevation: 0,
                        color: isDark ? ManahColors.darkSurface : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ManahBorderRadius.card),
                          side: BorderSide(
                            color: isDark ? Colors.grey[850]! : Colors.grey[300]!,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(ManahBorderRadius.card),
                          onTap: () {
                            context.push(
                              '/events/${widget.eventId}/scorer/$_selectedDivisionId/$targetNumber',
                            );
                          },
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$targetNumber',
                                  style: ManahTextStyles.number.copyWith(
                                    fontSize: 24,
                                    color: ManahColors.brand,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Target',
                                  style: ManahTextStyles.bodyS.copyWith(
                                    fontSize: 10,
                                    color: ManahColors.mediumGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
