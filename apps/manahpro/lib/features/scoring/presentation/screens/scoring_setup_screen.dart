import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/scoring_enums.dart';
import '../equipment_notifier.dart';
import '../scoring_providers.dart';
import '../scoring_routes.dart';

/// Scoring setup — choose distance, bow type, target face and round format,
/// then start a session. ui-ux-design-guide.md §6.1/§6.2.
class ScoringSetupScreen extends ConsumerStatefulWidget {
  const ScoringSetupScreen({super.key});

  @override
  ConsumerState<ScoringSetupScreen> createState() => _ScoringSetupScreenState();
}

class _ScoringSetupScreenState extends ConsumerState<ScoringSetupScreen> {
  BowClass _bowClass = BowClass.recurve;
  DistanceCategory _distance = DistanceCategory.d70m;
  ArcheryEnvironment _environment = ArcheryEnvironment.outdoor;
  int _targetFaceCm = 122;
  int _numEnds = 6;
  int _arrowsPerEnd = 6;
  String? _equipmentProfileId;
  bool _starting = false;

  static const _targetFaces = [40, 60, 80, 122];

  Future<void> _start() async {
    setState(() => _starting = true);
    try {
      final session = await ref.read(scoringRepositoryProvider).startSession(
            bowClass: _bowClass,
            distanceCategory: _distance,
            distanceM: _distance.meters,
            numEnds: _numEnds,
            arrowsPerEnd: _arrowsPerEnd,
            environment: _environment,
            targetFaceCm: _targetFaceCm,
            equipmentProfileId: _equipmentProfileId,
          );
      if (!mounted) return;
      context.push(ScoringRoutes.input(session.id));
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  /// Optional equipment picker — only shown when the user has profiles (online).
  Widget _buildEquipmentPicker() {
    final async = ref.watch(equipmentListProvider);
    final profiles = async.value ?? const [];
    if (profiles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Equipment (opsional)'),
        DropdownButtonFormField<String?>(
          initialValue: _equipmentProfileId,
          items: [
            const DropdownMenuItem<String?>(value: null, child: Text('Tanpa equipment')),
            for (final p in profiles)
              DropdownMenuItem<String?>(value: p.id, child: Text(p.name)),
          ],
          onChanged: (v) => setState(() => _equipmentProfileId = v),
        ),
        const SizedBox(height: ManahSpacing.lg),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mulai Scoring')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(ManahSpacing.base),
          children: [
            _SectionLabel('Tipe Busur'),
            _Dropdown<BowClass>(
              value: _bowClass,
              items: BowClass.values,
              labelOf: (e) => e.label,
              onChanged: (v) => setState(() => _bowClass = v),
            ),
            const SizedBox(height: ManahSpacing.lg),
            _buildEquipmentPicker(),
            _SectionLabel('Jarak'),
            _Dropdown<DistanceCategory>(
              value: _distance,
              items: DistanceCategory.values,
              labelOf: (e) => e.label,
              onChanged: (v) => setState(() => _distance = v),
            ),
            const SizedBox(height: ManahSpacing.lg),
            _SectionLabel('Lingkungan'),
            SegmentedButton<ArcheryEnvironment>(
              segments: const [
                ButtonSegment(value: ArcheryEnvironment.outdoor, label: Text('Outdoor')),
                ButtonSegment(value: ArcheryEnvironment.indoor, label: Text('Indoor')),
              ],
              selected: {_environment},
              onSelectionChanged: (s) => setState(() => _environment = s.first),
            ),
            const SizedBox(height: ManahSpacing.lg),
            _SectionLabel('Target Face (cm)'),
            Wrap(
              spacing: ManahSpacing.sm,
              children: _targetFaces
                  .map((cm) => ChoiceChip(
                        label: Text('$cm'),
                        selected: _targetFaceCm == cm,
                        onSelected: (_) => setState(() => _targetFaceCm = cm),
                      ))
                  .toList(),
            ),
            const SizedBox(height: ManahSpacing.lg),
            _Stepper(
              label: 'Jumlah End',
              value: _numEnds,
              min: 1,
              max: 30,
              onChanged: (v) => setState(() => _numEnds = v),
            ),
            const SizedBox(height: ManahSpacing.md),
            _Stepper(
              label: 'Panah / End',
              value: _arrowsPerEnd,
              min: 1,
              max: 12,
              onChanged: (v) => setState(() => _arrowsPerEnd = v),
            ),
            const SizedBox(height: ManahSpacing.xl),
            Card(
              color: ManahColors.brandSurface,
              child: Padding(
                padding: const EdgeInsets.all(ManahSpacing.base),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total panah'),
                    Text(
                      '${_numEnds * _arrowsPerEnd} panah · maks ${_numEnds * _arrowsPerEnd * 10}',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: ManahColors.brand),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: ManahSpacing.lg),
            FilledButton(
              onPressed: _starting ? null : _start,
              child: _starting
                  ? const SizedBox(
                      height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Mulai Scoring'),
            ),
          ],
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

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
  });

  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items
          .map((e) => DropdownMenuItem<T>(value: e, child: Text(labelOf(e))))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
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
        Expanded(child: Text(label, style: Theme.of(context).textTheme.titleSmall)),
        IconButton.filledTonal(
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 44,
          child: Text('$value', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
        ),
        IconButton.filledTonal(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
