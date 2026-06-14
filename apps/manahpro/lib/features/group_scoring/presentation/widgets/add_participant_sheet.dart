import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';

/// Quick-add roster sheet (Sprint 06, task 6.1) — the "secepat kertas" promise.
///
/// Type a name → Enter → the field clears and re-focuses for the next name,
/// **without closing the sheet** — eleven names in thirty seconds. Bow class &
/// target face are intentionally absent (K8: never block adding a person on
/// metadata; it can be filled later). On finish it returns every name as a
/// single batch so the caller mints them in one offline-first write + sync.
///
/// Returns the list of names (already trimmed, blanks dropped), or `null` if
/// the host dismissed without adding anyone.
Future<List<String>?> showAddParticipantSheet(BuildContext context) {
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => const _AddParticipantSheet(),
  );
}

class _AddParticipantSheet extends StatefulWidget {
  const _AddParticipantSheet();

  @override
  State<_AddParticipantSheet> createState() => _AddParticipantSheetState();
}

class _AddParticipantSheetState extends State<_AddParticipantSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<String> _names = [];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Commit the field's current text as a name, then clear & re-focus so the
  /// host can keep typing the next one without lifting a finger.
  void _commitCurrent() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _names.add(name);
      _controller.clear();
    });
    // Stay in the field for the next name (the heart of quick-add).
    _focusNode.requestFocus();
  }

  void _removeAt(int index) {
    setState(() => _names.removeAt(index));
    _focusNode.requestFocus();
  }

  void _finish() {
    // Fold in any name still sitting in the field (host tapped "Tambahkan"
    // without pressing Enter first).
    final pending = _controller.text.trim();
    final result = [..._names, if (pending.isNotEmpty) pending];
    Navigator.of(context).pop(result.isEmpty ? null : result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pending = _controller.text.trim();
    final total = _names.length + (pending.isNotEmpty ? 1 : 0);

    return Padding(
      // Lift the sheet above the keyboard so the field is always visible.
      padding: EdgeInsets.only(
        left: ManahSpacing.base,
        right: ManahSpacing.base,
        top: ManahSpacing.sm,
        bottom: MediaQuery.of(context).viewInsets.bottom + ManahSpacing.base,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tambah pemain',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: ManahSpacing.xs),
          Text(
            'Ketik nama lalu tekan Enter — lanjut ke nama berikutnya. '
            'Kelas busur bisa diisi belakangan.',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.textTheme.bodySmall?.color),
          ),
          const SizedBox(height: ManahSpacing.base),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _commitCurrent(),
            inputFormatters: [LengthLimitingTextInputFormatter(40)],
            decoration: InputDecoration(
              labelText: 'Nama pemain',
              hintText: 'mis. Andi',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person_add_alt_1),
              suffixIcon: pending.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Tambahkan nama ini',
                      icon: const Icon(Icons.subdirectory_arrow_left),
                      onPressed: _commitCurrent,
                    ),
            ),
          ),
          if (_names.isNotEmpty) ...[
            const SizedBox(height: ManahSpacing.base),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_names.length} ditambahkan',
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: ManahColors.brand),
              ),
            ),
            const SizedBox(height: ManahSpacing.sm),
            Wrap(
              spacing: ManahSpacing.sm,
              runSpacing: ManahSpacing.xs,
              children: [
                for (var i = 0; i < _names.length; i++)
                  InputChip(
                    label: Text(_names[i]),
                    onDeleted: () => _removeAt(i),
                    backgroundColor: ManahColors.brandSurface,
                  ),
              ],
            ),
          ],
          const SizedBox(height: ManahSpacing.lg),
          FilledButton.icon(
            onPressed: total == 0 ? null : _finish,
            icon: const Icon(Icons.check),
            label: Text(
              total == 0 ? 'Tambahkan pemain' : 'Tambahkan $total pemain',
            ),
          ),
          const SizedBox(height: ManahSpacing.sm),
        ],
      ),
    );
  }
}
