import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../theme/manah_tokens.dart';
import '../../domain/group_leaderboard.dart';
import '../../domain/join_link.dart';
import '../group_scoring_providers.dart';
import '../widgets/group_result_card.dart';

/// Preview & share the **group result card** (Sprint 07, tasks 7.4 + 7.5).
///
/// Captures the [GroupResultCard] via a RepaintBoundary to PNG (same recipe as
/// the individual `ScorecardPreviewScreen`), then opens the OS share sheet —
/// the WhatsApp-able artefact that starts the circle. The accompanying text
/// carries the join code and leaves a **slot for the invite deep link**, which
/// Phase 1/2 (Sprint 09/14) will turn from placeholder into a tap-to-claim URL.
class GroupResultCardScreen extends ConsumerStatefulWidget {
  const GroupResultCardScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<GroupResultCardScreen> createState() =>
      _GroupResultCardScreenState();
}

class _GroupResultCardScreenState extends ConsumerState<GroupResultCardScreen> {
  final GlobalKey _boundaryKey = GlobalKey();
  bool _busy = false;

  Future<File> _capture(Directory dir) async {
    final boundary = _boundaryKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('${dir.path}/group_result_${widget.groupId}.png');
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

  Future<void> _share(String joinCode, String title) => _run(() async {
        final file = await _capture(await getTemporaryDirectory());
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path, mimeType: 'image/png')],
            // Link-first invite (Sprint 09): the HTTPS link opens the preview
            // from WhatsApp; the typed code rides along as a fallback. Sprint 14
            // upgrades this into a tap-to-claim URL.
            text: 'Hasil "$title" di ManahPro 🎯\n'
                'Ikut latihan bareng — ketuk tautan:\n'
                '${JoinLink.buildShareUrl(joinCode)}\n\n'
                'Atau masukkan kode gabung: $joinCode',
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(hostBoardControllerProvider(widget.groupId));

    return Scaffold(
      appBar: AppBar(title: const Text('Kartu Hasil')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat: $e')),
        data: (state) {
          final leaderboard = buildGroupLeaderboard(
            participants: state.participants,
            numEnds: state.group.numEnds,
            arrowsPerEnd: state.group.arrowsPerEnd,
          );
          final title = state.group.title?.isNotEmpty == true
              ? state.group.title!
              : 'Latihan Bersama';
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(ManahSpacing.base),
                    child: RepaintBoundary(
                      key: _boundaryKey,
                      child: GroupResultCard(
                        group: state.group,
                        leaderboard: leaderboard,
                      ),
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
                          onPressed: _busy
                              ? null
                              : () => _share(state.group.joinCode, title),
                          icon: _busy
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
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
