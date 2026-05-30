import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/manah_tokens.dart';
import '../feed_providers.dart';

/// Compose a feed post (task 2.12).
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _body = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    if (_body.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref.read(feedRepositoryProvider).createPost({
        'body': _body.text.trim(),
        'visibility': 'public',
      });
      ref.invalidate(feedProvider);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memposting: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posting Baru'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _post,
            child: const Text('Kirim'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(ManahSpacing.base),
        child: TextField(
          controller: _body,
          maxLines: null,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Apa yang ingin kamu bagikan?',
            border: InputBorder.none,
            filled: false,
          ),
        ),
      ),
    );
  }
}
