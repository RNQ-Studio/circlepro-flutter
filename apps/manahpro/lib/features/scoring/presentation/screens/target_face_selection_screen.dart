import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/scoring_entities.dart';
import '../scoring_providers.dart';
import 'scoring_setup_screen.dart';

class TargetFaceSelectionScreen extends ConsumerStatefulWidget {
  const TargetFaceSelectionScreen({
    super.key,
    this.currentSelection,
  });

  final TargetFaceEntity? currentSelection;

  @override
  ConsumerState<TargetFaceSelectionScreen> createState() => _TargetFaceSelectionScreenState();
}

class _TargetFaceSelectionScreenState extends ConsumerState<TargetFaceSelectionScreen> {
  String _selectedFilter = 'SEMUA';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final targetFacesAsync = ref.watch(targetFacesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Target Face'),
      ),
      body: SafeArea(
        child: targetFacesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Gagal memuat target face: $err')),
          data: (targets) {
            if (targets.isEmpty) {
              return const Center(child: Text('Tidak ada target face tersedia'));
            }

            // Categories: SEMUA, TRADISIONAL, MODERN
            final List<String> categories = ['SEMUA', 'TRADISIONAL', 'MODERN'];

            bool isModern(TargetFaceEntity target) {
              final code = target.code;
              final orgSlug = target.organizationSlug?.toLowerCase();
              if (orgSlug == 'perpani') return true;
              if (code.startsWith('fita_') || code == 'las_vegas_3spot') return true;
              return false;
            }

            // Sort targets by usedCount descending, then filter by category
            final sortedTargets = List<TargetFaceEntity>.from(targets)
              ..sort((a, b) => b.usedCount.compareTo(a.usedCount));

            final filteredTargets = sortedTargets.where((t) {
              if (_selectedFilter == 'SEMUA') return true;
              if (_selectedFilter == 'MODERN') return isModern(t);
              if (_selectedFilter == 'TRADISIONAL') return !isModern(t);
              return true;
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Filter chips bar
                Container(
                  height: 58,
                  padding: const EdgeInsets.symmetric(vertical: ManahSpacing.xs),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.base),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final filter = categories[index];
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: ManahSpacing.xs),
                        child: FilterChip(
                          label: Text(
                            filter,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: ManahColors.brand,
                          checkmarkColor: Colors.white,
                          backgroundColor: theme.cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ManahRadius.full),
                            side: BorderSide(
                              color: isSelected
                                  ? ManahColors.brand
                                  : theme.dividerColor.withValues(alpha: 0.1),
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedFilter = filter);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                
                // Targets grid
                Expanded(
                  child: filteredTargets.isEmpty
                      ? const Center(child: Text('Tidak ada target face dalam kategori ini'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(ManahSpacing.base),
                          itemCount: filteredTargets.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: ManahSpacing.sm,
                            mainAxisSpacing: ManahSpacing.sm,
                            childAspectRatio: 1.05,
                          ),
                          itemBuilder: (context, idx) {
                            final target = filteredTargets[idx];
                            final isSelected = widget.currentSelection?.id == target.id;
                            
                            return InkWell(
                              onTap: () => context.pop(target),
                              borderRadius: BorderRadius.circular(ManahRadius.md),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? ManahColors.brandSurface
                                      : theme.cardColor,
                                  borderRadius: BorderRadius.circular(ManahRadius.md),
                                  border: Border.all(
                                    color: isSelected
                                        ? ManahColors.brand
                                        : theme.dividerColor.withValues(alpha: 0.1),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(ManahSpacing.sm),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: TargetFacePreview(
                                            code: target.code,
                                            imagePath: target.imagePath,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: ManahSpacing.xs),
                                      Text(
                                        target.name,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                                          color: isSelected ? ManahColors.brand : null,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        target.usedCount > 0
                                            ? '${NumberFormat.decimalPattern('id').format(target.usedCount)}x digunakan'
                                            : '0x digunakan',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                                          fontSize: 10,
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
            );
          },
        ),
      ),
    );
  }
}
