import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/manah_tokens.dart';
import '../../../scoring/domain/scoring_enums.dart';
import '../profile_providers.dart';

/// Edit the athlete profile (task 2.3). Sends only the changed fields.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _fullName = TextEditingController();
  final _username = TextEditingController();
  final _bio = TextEditingController();
  final _province = TextEditingController();
  final _city = TextEditingController();
  String? _gender;
  BowClass? _bowClass;
  DateTime? _birthDate;
  bool _saving = false;
  bool _seeded = false;

  @override
  void dispose() {
    _fullName.dispose();
    _username.dispose();
    _bio.dispose();
    _province.dispose();
    _city.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(myProfileProvider.notifier).save({
        'full_name': _fullName.text.trim(),
        if (_username.text.trim().isNotEmpty) 'username': _username.text.trim(),
        'bio': _bio.text.trim(),
        'province': _province.text.trim(),
        'city': _city.text.trim(),
        if (_gender != null) 'gender': _gender,
        if (_bowClass != null) 'primary_bow_class': _bowClass!.value,
        if (_birthDate != null) 'birth_date': _birthDate!.toIso8601String().split('T').first,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil tersimpan')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Seed the form from the current profile once.
    final profile = ref.watch(myProfileProvider).value;
    if (!_seeded && profile != null) {
      _seeded = true;
      _fullName.text = profile.fullName ?? '';
      _username.text = profile.username ?? '';
      _bio.text = profile.bio ?? '';
      _province.text = profile.province ?? '';
      _city.text = profile.city ?? '';
      _gender = profile.gender;
      _bowClass = profile.primaryBowClass;
      _birthDate = profile.birthDate != null ? DateTime.tryParse(profile.birthDate!) : null;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: ListView(
        padding: const EdgeInsets.all(ManahSpacing.base),
        children: [
          TextField(controller: _fullName, decoration: const InputDecoration(labelText: 'Nama Lengkap')),
          const SizedBox(height: ManahSpacing.md),
          TextField(controller: _username, decoration: const InputDecoration(labelText: 'Username')),
          const SizedBox(height: ManahSpacing.md),
          TextField(
            controller: _bio,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Bio'),
          ),
          const SizedBox(height: ManahSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _gender,
            decoration: const InputDecoration(labelText: 'Gender'),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Laki-laki')),
              DropdownMenuItem(value: 'female', child: Text('Perempuan')),
            ],
            onChanged: (v) => setState(() => _gender = v),
          ),
          const SizedBox(height: ManahSpacing.md),
          DropdownButtonFormField<BowClass>(
            initialValue: _bowClass,
            decoration: const InputDecoration(labelText: 'Busur Utama'),
            items: BowClass.values.map((e) => DropdownMenuItem(value: e, child: Text(e.label))).toList(),
            onChanged: (v) => setState(() => _bowClass = v),
          ),
          const SizedBox(height: ManahSpacing.md),
          Row(
            children: [
              Expanded(child: TextField(controller: _province, decoration: const InputDecoration(labelText: 'Provinsi'))),
              const SizedBox(width: ManahSpacing.md),
              Expanded(child: TextField(controller: _city, decoration: const InputDecoration(labelText: 'Kota'))),
            ],
          ),
          const SizedBox(height: ManahSpacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Tanggal Lahir'),
            subtitle: Text(_birthDate == null ? 'Belum diatur' : _birthDate!.toIso8601String().split('T').first),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _birthDate ?? DateTime(2000),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _birthDate = picked);
            },
          ),
          const SizedBox(height: ManahSpacing.lg),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
