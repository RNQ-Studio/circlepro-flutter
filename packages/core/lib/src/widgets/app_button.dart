import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? icon;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [icon!, const SizedBox(width: 8), Text(label)],
              )
            : Text(label);

    final effectiveWidth = width != null
        ? SizedBox(width: width, child: _build(context, child))
        : _build(context, child);
    return effectiveWidth;
  }

  Widget _build(BuildContext context, Widget child) {
    return switch (variant) {
      AppButtonVariant.primary =>
        ElevatedButton(onPressed: isLoading ? null : onPressed, child: child),
      AppButtonVariant.secondary => FilledButton.tonal(
          onPressed: isLoading ? null : onPressed, child: child),
      AppButtonVariant.outline =>
        OutlinedButton(onPressed: isLoading ? null : onPressed, child: child),
      AppButtonVariant.text =>
        TextButton(onPressed: isLoading ? null : onPressed, child: child),
    };
  }
}
