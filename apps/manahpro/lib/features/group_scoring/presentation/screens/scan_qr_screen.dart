import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/join_link.dart';
import '../group_scoring_routes.dart';

/// Scan a Latihan Bersama join QR (Sprint 09, task 9.3). A successful read funnels
/// to the very same preview the link / typed-code paths reach.
class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  bool _handled = false;

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    for (final barcode in capture.barcodes) {
      final code = JoinLink.parseCode(barcode.rawValue);
      if (code != null) {
        _handled = true;
        if (mounted) {
          // Replace the scanner so "back" from the preview returns to the entry.
          context.pushReplacement(GroupScoringRoutes.joinPreview(code));
        }
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pindai QR')),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(onDetect: _onDetect),
          // Simple framing reticle + hint.
          IgnorePointer(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(ManahRadius.lg),
              ),
            ),
          ),
          Positioned(
            bottom: ManahSpacing.xxl,
            left: ManahSpacing.xl,
            right: ManahSpacing.xl,
            child: Container(
              padding: const EdgeInsets.all(ManahSpacing.base),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(ManahRadius.md),
              ),
              child: const Text(
                'Arahkan kamera ke QR undangan Latihan Bersama',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            bottom: ManahSpacing.base,
            child: TextButton(
              onPressed: () => context.pushReplacement(
                GroupScoringRoutes.joinByCode,
              ),
              child: const Text(
                'Tidak bisa scan? Masukkan kode',
                style: TextStyle(color: ManahColors.amber),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
