import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/manah_navigation_button.dart';
import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/equipment_profile_entity.dart';
import '../../domain/scoring_enums.dart';
import '../equipment_notifier.dart';

/// Bow / equipment profile manager (task 1.11b). Online CRUD against the
/// backend; profiles can be picked when starting a session.
class BowSetupScreen extends ConsumerWidget {
  const BowSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(equipmentListProvider);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        leading: const ManahNavigationButton.back(),
        title: const Text('Setup Busur'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            _ErrorState(onRetry: () => ref.invalidate(equipmentListProvider)),
        data: (profiles) {
          if (profiles.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(ManahSpacing.xl),
                child: Text(
                    'Belum ada profil busur. Tambahkan busur pertamamu.',
                    textAlign: TextAlign.center),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(ManahSpacing.base),
            itemCount: profiles.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: ManahSpacing.sm),
            itemBuilder: (context, i) {
              final p = profiles[i];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: ManahColors.brandSurface,
                    child: Icon(Icons.sports, color: ManahColors.brand),
                  ),
                  title: Row(
                    children: [
                      Flexible(
                          child: Text(p.name, overflow: TextOverflow.ellipsis)),
                      if (p.isDefault) ...[
                        const SizedBox(width: ManahSpacing.sm),
                        const _DefaultChip(),
                      ],
                    ],
                  ),
                  subtitle: Text(
                    [
                      p.bowClass.label,
                      if (p.drawWeightLbs != null) '${p.drawWeightLbs} lbs',
                      if (p.bowModel != null) p.bowModel,
                    ].whereType<String>().join(' · '),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'edit') {
                        _openForm(context, ref, existing: p);
                      }
                      if (v == 'delete') {
                        ref.read(equipmentListProvider.notifier).remove(p.id);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Hapus')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openForm(BuildContext context, WidgetRef ref,
      {EquipmentProfileEntity? existing}) async {
    final result = await showModalBottomSheet<EquipmentProfileEntity>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EquipmentForm(existing: existing),
    );
    if (result != null) {
      await ref.read(equipmentListProvider.notifier).save(result);
    }
  }
}

class _DefaultChip extends StatelessWidget {
  const _DefaultChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: ManahColors.brandSurface,
        borderRadius: BorderRadius.circular(ManahRadius.full),
      ),
      child: const Text('Default',
          style: TextStyle(fontSize: 11, color: ManahColors.brand)),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Gagal memuat (butuh koneksi & login).'),
          const SizedBox(height: ManahSpacing.sm),
          OutlinedButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}

class _EquipmentForm extends StatefulWidget {
  const _EquipmentForm({this.existing});
  final EquipmentProfileEntity? existing;

  @override
  State<_EquipmentForm> createState() => _EquipmentFormState();
}

class _EquipmentFormState extends State<_EquipmentForm> {
  late final TextEditingController _name;
  late final TextEditingController _model;
  late final TextEditingController _drawWeight;
  late final TextEditingController _arrowSpec;
  late BowClass _bowClass;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _model = TextEditingController(text: e?.bowModel ?? '');
    _drawWeight =
        TextEditingController(text: e?.drawWeightLbs?.toString() ?? '');
    _arrowSpec = TextEditingController(text: e?.arrowSpec ?? '');
    _bowClass = e?.bowClass ?? BowClass.recurve;
    _isDefault = e?.isDefault ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _model.dispose();
    _drawWeight.dispose();
    _arrowSpec.dispose();
    super.dispose();
  }

  void _submit() {
    if (_name.text.trim().isEmpty) return;
    Navigator.of(context).pop(
      EquipmentProfileEntity(
        id: widget.existing?.id ?? '',
        name: _name.text.trim(),
        bowClass: _bowClass,
        bowModel: _model.text.trim().isEmpty ? null : _model.text.trim(),
        drawWeightLbs: double.tryParse(_drawWeight.text.trim()),
        arrowSpec:
            _arrowSpec.text.trim().isEmpty ? null : _arrowSpec.text.trim(),
        isDefault: _isDefault,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ManahSpacing.base,
        ManahSpacing.base,
        ManahSpacing.base,
        MediaQuery.of(context).viewInsets.bottom + ManahSpacing.base,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.existing == null ? 'Tambah Busur' : 'Edit Busur',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: ManahSpacing.base),
          TextField(
              controller: _name,
              decoration: const InputDecoration(
                  labelText: 'Nama (mis. Recurve Latihan)')),
          const SizedBox(height: ManahSpacing.md),
          DropdownButtonFormField<BowClass>(
            initialValue: _bowClass,
            decoration: const InputDecoration(labelText: 'Tipe Busur'),
            items: BowClass.values
                .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
                .toList(),
            onChanged: (v) => setState(() => _bowClass = v ?? _bowClass),
          ),
          const SizedBox(height: ManahSpacing.md),
          TextField(
              controller: _model,
              decoration: const InputDecoration(labelText: 'Model (opsional)')),
          const SizedBox(height: ManahSpacing.md),
          TextField(
            controller: _drawWeight,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration:
                const InputDecoration(labelText: 'Draw weight (lbs, opsional)'),
          ),
          const SizedBox(height: ManahSpacing.md),
          TextField(
              controller: _arrowSpec,
              decoration:
                  const InputDecoration(labelText: 'Arrow spec (opsional)')),
          const SizedBox(height: ManahSpacing.sm),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Jadikan default'),
            value: _isDefault,
            onChanged: (v) => setState(() => _isDefault = v),
          ),
          const SizedBox(height: ManahSpacing.sm),
          FilledButton(onPressed: _submit, child: const Text('Simpan')),
        ],
      ),
    );
  }
}
