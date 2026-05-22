import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.opacity = 0.5,
  });

  final bool isLoading;
  final Widget child;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black.withValues(alpha: opacity),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
