import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/routes/social_routes.dart';
import '../../../../theme/manah_tokens.dart';
import '../clubs_providers.dart';

/// Create a club (task 2.7) — the creator becomes its owner.
class CreateClubScreen extends ConsumerStatefulWidget {
  const CreateClubScreen({super.key});

  @override
  ConsumerState<CreateClubScreen> createState() => _CreateClubScreenState();
}

class _CreateClubScreenState extends ConsumerState<CreateClubScreen> {
  final _name = TextEditingController();
  final _city = TextEditingController();
  final _province = TextEditingController();
  final _description = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _city.dispose();
    _province.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (_name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final club = await ref.read(clubsRepositoryProvider).createClub({
        'name': _name.text.trim(),
        if (_city.text.trim().isNotEmpty) 'city': _city.text.trim(),
        if (_province.text.trim().isNotEmpty) 'province': _province.text.trim(),
        if (_description.text.trim().isNotEmpty) 'description': _description.text.trim(),
      });
      ref.invalidate(clubDirectoryProvider);
      ref.invalidate(myClubsProvider);
      if (mounted) {
        context.pushReplacement(SocialRoutes.clubDetail(club.id));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal membuat klub: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Klub')),
      body: ListView(
        padding: const EdgeInsets.all(ManahSpacing.base),
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nama Klub')),
          const SizedBox(height: ManahSpacing.md),
          Row(
            children: [
              Expanded(child: TextField(controller: _province, decoration: const InputDecoration(labelText: 'Provinsi'))),
              const SizedBox(width: ManahSpacing.md),
              Expanded(child: TextField(controller: _city, decoration: const InputDecoration(labelText: 'Kota'))),
            ],
          ),
          const SizedBox(height: ManahSpacing.md),
          TextField(
            controller: _description,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Deskripsi (opsional)'),
          ),
          const SizedBox(height: ManahSpacing.lg),
          FilledButton(
            onPressed: _saving ? null : _create,
            child: _saving
                ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Buat Klub'),
          ),
        ],
      ),
    );
  }
}
