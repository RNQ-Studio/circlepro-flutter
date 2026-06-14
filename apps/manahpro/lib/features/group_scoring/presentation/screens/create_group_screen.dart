import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../scoring/domain/scoring_entities.dart';
import '../../../scoring/domain/scoring_enums.dart';
import '../../../scoring/presentation/scoring_providers.dart';
import '../../../scoring/presentation/scoring_routes.dart';
import '../../../scoring/presentation/screens/scoring_setup_screen.dart'
    show TargetFacePreview;
import '../group_scoring_providers.dart';
import '../group_scoring_routes.dart';

/// Create a Latihan Bersama (group scoring) session. Reuses the same round
/// format controls as `scoring_setup_screen` (zero learning curve for hosts —
/// task 4.4) and adds the "saya ikut menembak" toggle. On success the backend
/// returns a unique `join_code`, shown on the next screen.
class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final TextEditingController _titleController = TextEditingController();

  DistanceCategory? _distance = DistanceCategory.d50m;
  ArcheryEnvironment? _environment = ArcheryEnvironment.outdoor;
  TargetFaceEntity? _selectedTargetFace;
  int _numEnds = 6;
  int _arrowsPerEnd = 6;

  bool _hostParticipates = true;
  BowCategory _bowCategory = BowCategory.modern;
  BowClass _bowClass = BowClass.recurve;

  bool _creating = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  bool get _canCreate =>
      !_creating &&
      _distance != null &&
      _environment != null &&
      (!_hostParticipates || _bowClass.category == _bowCategory);

  Future<void> _create() async {
    if (_distance == null || _environment == null) return;
    setState(() => _creating = true);
    try {
      final targetFace = _selectedTargetFace;
      int? targetFaceCm;
      if (targetFace != null && targetFace.code.startsWith('fita_')) {
        targetFaceCm = int.tryParse(targetFace.code.replaceAll('fita_', ''));
      }

      final title = _titleController.text.trim();
      final group = await ref.read(groupScoringRepositoryProvider).createGroup(
            distanceCategory: _distance!,
            distanceM: _distance!.meters,
            numEnds: _numEnds,
            arrowsPerEnd: _arrowsPerEnd,
            environment: _environment!,
            targetFaceCm: targetFaceCm,
            targetFaceId: targetFace?.id,
            title: title.isEmpty ? null : title,
            hostParticipates: _hostParticipates,
            hostBowClass: _hostParticipates ? _bowClass : null,
          );
      if (!mounted) return;
      context.pushReplacement(GroupScoringRoutes.created(group.id),
          extra: group);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Gagal membuat sesi. Periksa koneksi lalu coba lagi.')),
        );
      }
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final targetFacesAsync = ref.watch(targetFacesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Latihan Bersama')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(ManahSpacing.base),
          children: [
            const _SectionLabel('Nama Sesi (opsional)'),
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'mis. Latihan Sore Klub Panah',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: ManahSpacing.lg),

            const _SectionLabel('Jarak'),
            Wrap(
              spacing: ManahSpacing.sm,
              runSpacing: ManahSpacing.sm,
              children: DistanceCategory.values.map((d) {
                return _ChoiceChip(
                  label: d.label,
                  selected: _distance == d,
                  onSelected: (_) => setState(() => _distance = d),
                );
              }).toList(),
            ),
            const SizedBox(height: ManahSpacing.lg),

            const _SectionLabel('Lingkungan'),
            SegmentedButton<ArcheryEnvironment>(
              segments: const [
                ButtonSegment(
                    value: ArcheryEnvironment.outdoor, label: Text('Outdoor')),
                ButtonSegment(
                    value: ArcheryEnvironment.indoor, label: Text('Indoor')),
              ],
              selected: _environment != null
                  ? {_environment!}
                  : const <ArcheryEnvironment>{},
              emptySelectionAllowed: true,
              onSelectionChanged: (s) => setState(() => _environment = s.first),
            ),
            const SizedBox(height: ManahSpacing.lg),

            const _SectionLabel('Target Face (opsional)'),
            _buildTargetFacePicker(theme, targetFacesAsync),
            const SizedBox(height: ManahSpacing.lg),

            _Stepper(
              label: 'Jumlah Ronde',
              value: _numEnds,
              min: 1,
              max: 30,
              onChanged: (v) => setState(() => _numEnds = v),
            ),
            const SizedBox(height: ManahSpacing.md),
            _Stepper(
              label: 'Anak Panah / Ronde',
              value: _arrowsPerEnd,
              min: 1,
              max: 12,
              onChanged: (v) => setState(() => _arrowsPerEnd = v),
            ),
            const SizedBox(height: ManahSpacing.lg),

            // "Saya ikut menembak" — host also joins the roster as an owned row.
            Card(
              color: ManahColors.brandSurface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ManahRadius.md),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _hostParticipates,
                    onChanged: (v) => setState(() => _hostParticipates = v),
                    title: const Text('Saya ikut menembak'),
                    subtitle: const Text(
                        'Tambahkan diri saya ke papan sebagai peserta'),
                    activeThumbColor: ManahColors.brand,
                  ),
                  if (_hostParticipates) ...[
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(ManahSpacing.base),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _SectionLabel('Kategori Busur Saya'),
                          SegmentedButton<BowCategory>(
                            segments: const [
                              ButtonSegment(
                                  value: BowCategory.traditional,
                                  label: Text('Tradisional')),
                              ButtonSegment(
                                  value: BowCategory.modern,
                                  label: Text('Modern')),
                            ],
                            selected: {_bowCategory},
                            onSelectionChanged: (s) => setState(() {
                              _bowCategory = s.first;
                              _bowClass =
                                  BowClass.ofCategory(_bowCategory).first;
                            }),
                          ),
                          const SizedBox(height: ManahSpacing.md),
                          const _SectionLabel('Tipe Busur Saya'),
                          Wrap(
                            spacing: ManahSpacing.sm,
                            runSpacing: ManahSpacing.sm,
                            children:
                                BowClass.ofCategory(_bowCategory).map((bc) {
                              return _ChoiceChip(
                                label: bc.label,
                                selected: _bowClass == bc,
                                onSelected: (_) =>
                                    setState(() => _bowClass = bc),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: ManahSpacing.lg),

            Card(
              color: ManahColors.brandSurface,
              child: Padding(
                padding: const EdgeInsets.all(ManahSpacing.base),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total anak panah'),
                    Text(
                      '${_numEnds * _arrowsPerEnd} anak panah',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: ManahColors.brand),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: ManahSpacing.lg),

            FilledButton(
              onPressed: _canCreate ? _create : null,
              child: _creating
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Buat & Dapatkan Kode'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetFacePicker(
    ThemeData theme,
    AsyncValue<List<TargetFaceEntity>> targetFacesAsync,
  ) {
    final selected = _selectedTargetFace;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManahRadius.md),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: targetFacesAsync.hasValue
            ? () async {
                final result = await context.push<TargetFaceEntity>(
                  ScoringRoutes.targetFaceSelection,
                  extra: selected,
                );
                if (result != null && mounted) {
                  setState(() => _selectedTargetFace = result);
                }
              }
            : null,
        borderRadius: BorderRadius.circular(ManahRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(ManahSpacing.base),
          child: Row(
            children: [
              SizedBox(
                width: 54,
                height: 54,
                child: selected != null
                    ? TargetFacePreview(
                        code: selected.code, imagePath: selected.imagePath)
                    : Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(ManahRadius.md),
                        ),
                        child: Icon(Icons.adjust,
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
              ),
              const SizedBox(width: ManahSpacing.base),
              Expanded(
                child: Text(
                  selected?.name ?? 'Pilih target face',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: ManahSpacing.sm),
        child: Text(text, style: Theme.of(context).textTheme.titleSmall),
      );
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = selected
        ? theme.colorScheme.primary
        : (isDark ? ManahColors.darkSurface : ManahColors.lightGrey);
    final foregroundColor =
        selected ? Colors.white : theme.colorScheme.onSurface;

    return InkWell(
      onTap: () => onSelected(!selected),
      borderRadius: BorderRadius.circular(ManahRadius.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: ManahSpacing.base,
          vertical: ManahSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.dividerColor.withValues(alpha: 0.1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(ManahRadius.sm),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: foregroundColor,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(label, style: Theme.of(context).textTheme.titleSmall)),
        IconButton.filledTonal(
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 44,
          child: Text('$value',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge),
        ),
        IconButton.filledTonal(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
