import 'package:flutter/material.dart';

import '../../theme/manah_tokens.dart';

/// A crisp, branded navigation control for ManahPro detail flows.
class ManahNavigationButton extends StatelessWidget {
  const ManahNavigationButton.back({
    super.key,
    this.onPressed,
    this.tooltip = 'Kembali',
  })  : _icon = Icons.chevron_left_rounded,
        _controlKey = const ValueKey('manah-back-button');

  const ManahNavigationButton.close({
    super.key,
    required this.onPressed,
    this.tooltip = 'Tutup',
  })  : _icon = Icons.close,
        _controlKey = const ValueKey('manah-close-button');

  final VoidCallback? onPressed;
  final String tooltip;
  final IconData _icon;
  final Key _controlKey;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: ManahSpacing.sm),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          key: _controlKey,
          tooltip: tooltip,
          onPressed: onPressed ?? () => Navigator.maybePop(context),
          icon: Icon(_icon),
          style: IconButton.styleFrom(
            minimumSize: const Size(48, 48),
            backgroundColor: colors.surfaceContainerHigh,
            foregroundColor: colors.onSurface,
            side: BorderSide(color: colors.outlineVariant),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(ManahRadius.md),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
