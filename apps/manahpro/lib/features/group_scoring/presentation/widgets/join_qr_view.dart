import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../domain/join_link.dart';

/// A QR encoding the HTTPS invite link for [code]. Scanning it lands on the same
/// join preview as the link / typed-code paths (Sprint 09, task 9.3) — one
/// poster on the coffee table turns roster filling from O(N)-host into O(1).
class JoinQrView extends StatelessWidget {
  const JoinQrView({super.key, required this.code, this.size = 240});

  final String code;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: QrImageView(
        data: JoinLink.buildShareUrl(code),
        version: QrVersions.auto,
        size: size,
        backgroundColor: Colors.white,
        // Medium EC tolerates print scuffs / glare on a printed poster.
        errorCorrectionLevel: QrErrorCorrectLevel.M,
      ),
    );
  }
}
