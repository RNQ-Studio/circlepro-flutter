import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/join_link.dart';
import '../group_scoring_routes.dart';

/// Typed-code fallback (Sprint 09, task 9.5): the safety net when the link or QR
/// can't be used. It funnels to the very same preview, so the typed code is a
/// fallback path, not a separate flow.
class JoinByCodeScreen extends StatefulWidget {
  const JoinByCodeScreen({super.key});

  @override
  State<JoinByCodeScreen> createState() => _JoinByCodeScreenState();
}

class _JoinByCodeScreenState extends State<JoinByCodeScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final code = JoinLink.parseCode(_controller.text);
    if (code == null) {
      setState(() => _error = 'Kode belum lengkap. Minta 6 karakter dari host.');
      return;
    }
    context.push(GroupScoringRoutes.joinPreview(code));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Gabung Sesi')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(ManahSpacing.base),
          children: [
            const SizedBox(height: ManahSpacing.lg),
            const Center(
              child: CircleAvatar(
                radius: 32,
                backgroundColor: ManahColors.brandSurface,
                child: Icon(Icons.tag, color: ManahColors.brand, size: 36),
              ),
            ),
            const SizedBox(height: ManahSpacing.base),
            Text(
              'Masukkan kode gabung',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: ManahSpacing.xs),
            Text(
              'Punya tautan undangan? Cukup ketuk tautannya. Kalau tidak, ketik kodenya di sini.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.textTheme.bodySmall?.color),
            ),
            const SizedBox(height: ManahSpacing.xl),
            TextField(
              controller: _controller,
              autofocus: true,
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.characters,
              maxLength: 12,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 6,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                TextInputFormatter.withFunction(
                  (oldValue, newValue) =>
                      newValue.copyWith(text: newValue.text.toUpperCase()),
                ),
              ],
              decoration: InputDecoration(
                hintText: 'ABC234',
                counterText: '',
                errorText: _error,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: ManahSpacing.base),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Lihat Sesi'),
            ),
            const SizedBox(height: ManahSpacing.sm),
            OutlinedButton.icon(
              onPressed: () => context.push(GroupScoringRoutes.scan),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Pindai QR'),
            ),
          ],
        ),
      ),
    );
  }
}
