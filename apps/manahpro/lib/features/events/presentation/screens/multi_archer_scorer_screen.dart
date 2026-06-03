import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../scoring/domain/scoring_entities.dart';
import '../events_providers.dart';

class MultiArcherScorerScreen extends ConsumerStatefulWidget {
  const MultiArcherScorerScreen({
    super.key,
    required this.eventId,
    required this.divisionId,
    required this.targetButt,
  });

  final String eventId;
  final String divisionId;
  final int targetButt;

  @override
  ConsumerState<MultiArcherScorerScreen> createState() => _MultiArcherScorerScreenState();
}

class _MultiArcherScorerScreenState extends ConsumerState<MultiArcherScorerScreen> {
  int _currentEnd = 1;
  int _activeArcherIndex = 0;
  int _activeArrowIndex = 0;
  bool _isSaving = false;

  // Map to hold temp scores being input before saving: user_id -> List of 6 ArrowScore inputs
  final Map<int, List<Map<String, dynamic>>> _tempScores = {};

  @override
  Widget build(BuildContext context) {
    final asyncScorecard = ref.watch(targetScorecardProvider(
      eventId: widget.eventId,
      divisionId: widget.divisionId,
      targetButt: widget.targetButt,
    ));

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Skoring Target ${widget.targetButt}'),
        elevation: 0,
      ),
      body: asyncScorecard.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat kartu skor: $err')),
        data: (archers) {
          if (archers.isEmpty) {
            return const Center(child: Text('Tidak ada pemanah terdaftar di bantalan target ini.'));
          }

          // Initialize temp scores for all archers if not already done
          for (final archer in archers) {
            final userId = archer.userId;
            if (!_tempScores.containsKey(userId)) {
              // Try to populate from existing DB end if it exists
              final existingEnd = archer.scoringSession.ends.firstWhere(
                (e) => e.endNumber == _currentEnd,
                orElse: () => const ScoringEndEntity(id: '', endNumber: 0),
              );

              final list = List.generate(6, (idx) {
                if (existingEnd.endNumber == _currentEnd && idx < existingEnd.arrows.length) {
                  final arr = existingEnd.arrows[idx];
                  return {
                    'score_value': arr.scoreValue,
                    'is_x': arr.isX,
                    'is_miss': arr.isMiss,
                  };
                }
                return {
                  'score_value': -1, // Empty slot
                  'is_x': false,
                  'is_miss': false,
                };
              });
              _tempScores[userId] = list;
            }
          }

          final activeArcher = archers[_activeArcherIndex];
          final activeScores = _tempScores[activeArcher.userId]!;

          return Column(
            children: [
              // End Selector (End 1 to 6 / 12)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.base, vertical: ManahSpacing.sm),
                color: isDark ? ManahColors.darkSurface : Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rambahan (End)',
                      style: ManahTextStyles.bodyM.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: _currentEnd > 1
                              ? () {
                                  setState(() {
                                    _currentEnd--;
                                    _tempScores.clear(); // Reset to reload from DB
                                  });
                                }
                              : null,
                        ),
                        Text(
                          'End $_currentEnd / 12',
                          style: ManahTextStyles.h3,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: _currentEnd < 12
                              ? () {
                                  setState(() {
                                    _currentEnd++;
                                    _tempScores.clear(); // Reset to reload from DB
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Horizontal Archer Tabs (e.g. 5A, 5B)
              Container(
                padding: const EdgeInsets.symmetric(vertical: ManahSpacing.sm),
                color: isDark ? ManahColors.darkSurface : Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(archers.length, (idx) {
                      final archer = archers[idx];
                      final isActive = idx == _activeArcherIndex;
                      final targetLabel = '${archer.targetButt}${archer.targetLetter}';

                      // Calculate subtotal for this end
                      final endScores = _tempScores[archer.userId] ?? [];
                      final endTotal = endScores.fold(0, (sum, val) {
                        final valInt = val['score_value'] as int;
                        return sum + (valInt >= 0 ? valInt : 0);
                      });

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ChoiceChip(
                          label: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                targetLabel,
                                style: ManahTextStyles.h3.copyWith(
                                  color: isActive ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                archer.userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ManahTextStyles.bodyS.copyWith(
                                  color: isActive ? Colors.white70 : ManahColors.mediumGrey,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'End $_currentEnd: $endTotal',
                                style: ManahTextStyles.bodyS.copyWith(
                                  color: isActive ? Colors.white : ManahColors.brand,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          selected: isActive,
                          selectedColor: ManahColors.brand,
                          backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          onSelected: (val) {
                            if (val) {
                              setState(() {
                                _activeArcherIndex = idx;
                                _activeArrowIndex = 0;
                              });
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const Divider(height: 1),

              // Arrow Slots for selected archer
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(ManahSpacing.base),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Skor Anak Panah - ${activeArcher.targetButt}${activeArcher.targetLetter}: ${activeArcher.userName}',
                        style: ManahTextStyles.h3.copyWith(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: ManahSpacing.base),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(6, (idx) {
                          final score = activeScores[idx];
                          final isSelected = idx == _activeArrowIndex;
                          final scoreValue = score['score_value'] as int;
                          final isX = score['is_x'] as bool;
                          final isMiss = score['is_miss'] as bool;

                          String displayVal = '';
                          if (scoreValue >= 0) {
                            if (isMiss) displayVal = 'M';
                            else if (isX) displayVal = 'X';
                            else displayVal = '$scoreValue';
                          }

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _activeArrowIndex = idx;
                              });
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? ManahColors.brand.withValues(alpha: 0.1)
                                    : (isDark ? Colors.grey[900] : Colors.grey[100]),
                                border: Border.all(
                                  color: isSelected
                                      ? ManahColors.brand
                                      : (scoreValue >= 0 ? ManahColors.success : (isDark ? Colors.grey[800]! : Colors.grey[300]!)),
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                displayVal,
                                style: ManahTextStyles.number.copyWith(
                                  fontSize: 20,
                                  color: scoreValue >= 0
                                      ? ManahColors.forScore(scoreValue, isX: isX, isMiss: isMiss)
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const Spacer(),

                      // Numpad Custom
                      _buildNumpad(),
                      const Spacer(),

                      // Save button
                      ElevatedButton(
                        onPressed: _isSaving ? null : _saveScores,
                        child: _isSaving
                            ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white))
                            : const Text('Simpan & Sinkronisasi Rambahan'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNumpad() {
    final List<Map<String, dynamic>> keys = [
      {'label': '10', 'val': 10, 'x': false, 'miss': false},
      {'label': '9', 'val': 9, 'x': false, 'miss': false},
      {'label': '8', 'val': 8, 'x': false, 'miss': false},
      {'label': '7', 'val': 7, 'x': false, 'miss': false},
      {'label': '6', 'val': 6, 'x': false, 'miss': false},
      {'label': '5', 'val': 5, 'x': false, 'miss': false},
      {'label': '4', 'val': 4, 'x': false, 'miss': false},
      {'label': '3', 'val': 3, 'x': false, 'miss': false},
      {'label': '2', 'val': 2, 'x': false, 'miss': false},
      {'label': '1', 'val': 1, 'x': false, 'miss': false},
      {'label': 'X', 'val': 10, 'x': true, 'miss': false},
      {'label': 'M', 'val': 0, 'x': false, 'miss': true},
    ];

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: keys.length,
          itemBuilder: (context, idx) {
            final key = keys[idx];
            final label = key['label'] as String;

            return OutlinedButton(
              onPressed: () => _onKeyTapped(
                key['val'] as int,
                isX: key['x'] as bool,
                isMiss: key['miss'] as bool,
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: ManahColors.brand),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                label,
                style: ManahTextStyles.h2.copyWith(color: ManahColors.brand),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: _onBackspaceTapped,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.redAccent),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.backspace, color: Colors.redAccent),
              SizedBox(width: 8),
              Text('Hapus', style: TextStyle(color: Colors.redAccent)),
            ],
          ),
        ),
      ],
    );
  }

  void _onKeyTapped(int val, {required bool isX, required bool isMiss}) {
    final asyncScorecard = ref.read(targetScorecardProvider(
      eventId: widget.eventId,
      divisionId: widget.divisionId,
      targetButt: widget.targetButt,
    ));

    asyncScorecard.whenData((archers) {
      final activeArcher = archers[_activeArcherIndex];
      final activeScores = _tempScores[activeArcher.userId]!;

      setState(() {
        activeScores[_activeArrowIndex] = {
          'score_value': val,
          'is_x': isX,
          'is_miss': isMiss,
        };

        // Advance to next arrow or next archer
        if (_activeArrowIndex < 5) {
          _activeArrowIndex++;
        } else {
          // Finished all 6 arrows for this archer. Move to next archer if available
          if (_activeArcherIndex < archers.length - 1) {
            _activeArcherIndex++;
            _activeArrowIndex = 0;
          }
        }
      });
    });
  }

  void _onBackspaceTapped() {
    final asyncScorecard = ref.read(targetScorecardProvider(
      eventId: widget.eventId,
      divisionId: widget.divisionId,
      targetButt: widget.targetButt,
    ));

    asyncScorecard.whenData((archers) {
      final activeArcher = archers[_activeArcherIndex];
      final activeScores = _tempScores[activeArcher.userId]!;

      setState(() {
        // Clear active or move back and clear
        if (activeScores[_activeArrowIndex]['score_value'] as int >= 0) {
          activeScores[_activeArrowIndex] = {
            'score_value': -1,
            'is_x': false,
            'is_miss': false,
          };
        } else if (_activeArrowIndex > 0) {
          _activeArrowIndex--;
          activeScores[_activeArrowIndex] = {
            'score_value': -1,
            'is_x': false,
            'is_miss': false,
          };
        } else if (_activeArcherIndex > 0) {
          _activeArcherIndex--;
          _activeArrowIndex = 5;
          final prevScores = _tempScores[archers[_activeArcherIndex].userId]!;
          prevScores[_activeArrowIndex] = {
            'score_value': -1,
            'is_x': false,
            'is_miss': false,
          };
        }
      });
    });
  }

  Future<void> _saveScores() async {
    final asyncScorecard = ref.read(targetScorecardProvider(
      eventId: widget.eventId,
      divisionId: widget.divisionId,
      targetButt: widget.targetButt,
    ));

    await asyncScorecard.whenData((archers) async {
      // Validate all scores are filled
      for (final archer in archers) {
        final list = _tempScores[archer.userId]!;
        if (list.any((a) => (a['score_value'] as int) < 0)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lengkapi skor untuk pemanah ${archer.targetButt}${archer.targetLetter} terlebih dahulu.'),
              backgroundColor: ManahColors.warning,
            ),
          );
          return;
        }
      }

      setState(() {
        _isSaving = true;
      });

      try {
        final payload = archers.map((archer) {
          final arrows = _tempScores[archer.userId]!;
          return {
            'user_id': archer.userId,
            'arrows': arrows,
          };
        }).toList();

        await ref.read(eventsRepositoryProvider).saveTargetEndScores(
              widget.eventId,
              widget.divisionId,
              widget.targetButt,
              _currentEnd,
              payload,
            );

        ref.invalidate(targetScorecardProvider(
          eventId: widget.eventId,
          divisionId: widget.divisionId,
          targetButt: widget.targetButt,
        ));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Skor rambahan $_currentEnd berhasil disinkronisasi.'),
            backgroundColor: ManahColors.success,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan skor: ${e.toString()}'),
            backgroundColor: ManahColors.error,
          ),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    });
  }
}
