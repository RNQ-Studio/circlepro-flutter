import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../shared/widgets/manah_navigation_button.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/scoring_entities.dart';
import '../scoring_providers.dart';
import '../widgets/scorecard.dart';

/// Preview, save and share the scorecard image (task 1.12 — viral loop).
/// Captures the [Scorecard] widget via a RepaintBoundary to PNG, then either
/// saves it to the app documents dir or opens the OS share sheet.
class ScorecardPreviewScreen extends ConsumerStatefulWidget {
  const ScorecardPreviewScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<ScorecardPreviewScreen> createState() =>
      _ScorecardPreviewScreenState();
}

class _ScorecardPreviewScreenState
    extends ConsumerState<ScorecardPreviewScreen> {
  final GlobalKey _boundaryKey = GlobalKey();
  bool _busy = false;

  /// Render the scorecard boundary to a PNG file in [dir].
  Future<File> _capture(Directory dir) async {
    final boundary = _boundaryKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('${dir.path}/scorecard_${widget.sessionId}.png');
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    return file;
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() => _run(() async {
        final file = await _capture(await getApplicationDocumentsDirectory());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tersimpan: ${file.path}')),
          );
        }
      });

  Future<void> _share() => _run(() async {
        final file = await _capture(await getTemporaryDirectory());
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path, mimeType: 'image/png')],
            text: 'Skor latihan panahanku di ManahPro 🎯',
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(scoringRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        leading: const ManahNavigationButton.back(),
        title: const Text('Scorecard'),
      ),
      body: FutureBuilder<ScoringSessionEntity?>(
        future: repo.getSession(widget.sessionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final session = snapshot.data;
          if (session == null) {
            return const Center(child: Text('Sesi tidak ditemukan'));
          }
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(ManahSpacing.base),
                    child: RepaintBoundary(
                      key: _boundaryKey,
                      child: Scorecard(session: session),
                    ),
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(ManahSpacing.base),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _busy ? null : _save,
                          icon: const Icon(Icons.download),
                          label: const Text('Simpan'),
                        ),
                      ),
                      const SizedBox(width: ManahSpacing.md),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _busy ? null : _share,
                          icon: _busy
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.share),
                          label: const Text('Bagikan'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
