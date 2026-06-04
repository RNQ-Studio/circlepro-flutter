import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/api/manah_api.dart';
import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../feed_providers.dart';

/// Compose a feed post (task 2.12, 4.1).
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _body = TextEditingController();
  final _pollQuestionCtrl = TextEditingController();
  final List<TextEditingController> _pollOptionCtrls = [
    TextEditingController(),
    TextEditingController(),
  ];

  bool _saving = false;
  bool _isUploadingMedia = false;
  bool _showPoll = false;

  // Stores maps of {'url': publicUrl, 'type': 'image'|'video', 'localPath': filePath}
  final List<Map<String, String>> _uploadedMedia = [];

  @override
  void dispose() {
    _body.dispose();
    _pollQuestionCtrl.dispose();
    for (final ctrl in _pollOptionCtrls) {
      ctrl.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isEmpty) return;

    setState(() => _isUploadingMedia = true);

    try {
      final dio = ref.read(manahDioProvider);
      for (final file in picked) {
        final fileName = file.path.split('/').last;
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(file.path, filename: fileName),
          'type': 'post_media',
        });

        final response = await dio.post(
          'v1/assets/upload',
          data: formData,
          options: Options(contentType: 'multipart/form-data'),
        );

        final publicUrl = response.data['data']['public_url'] as String;
        setState(() {
          _uploadedMedia.add({
            'url': publicUrl,
            'type': 'image',
            'localPath': file.path,
          });
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah gambar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingMedia = false);
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final file = await picker.pickVideo(source: ImageSource.gallery);
    if (file == null) return;

    setState(() => _isUploadingMedia = true);

    try {
      final dio = ref.read(manahDioProvider);
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
        'type': 'post_media',
      });

      final response = await dio.post(
        'v1/assets/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final publicUrl = response.data['data']['public_url'] as String;
      setState(() {
        _uploadedMedia.add({
          'url': publicUrl,
          'type': 'video',
          'localPath': file.path,
        });
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah video: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingMedia = false);
    }
  }

  void _addPollOption() {
    if (_pollOptionCtrls.length < 5) {
      setState(() {
        _pollOptionCtrls.add(TextEditingController());
      });
    }
  }

  void _removePollOption(int index) {
    if (_pollOptionCtrls.length > 2) {
      setState(() {
        final ctrl = _pollOptionCtrls.removeAt(index);
        ctrl.dispose();
      });
    }
  }

  Future<void> _post() async {
    final bodyText = _body.text.trim();
    final hasMedia = _uploadedMedia.isNotEmpty;
    final hasPoll = _showPoll && _pollQuestionCtrl.text.trim().isNotEmpty;

    if (bodyText.isEmpty && !hasMedia && !hasPoll) return;

    setState(() => _saving = true);
    try {
      final payload = <String, dynamic>{
        'body': bodyText.isNotEmpty ? bodyText : null,
        'visibility': 'public',
      };

      if (hasMedia) {
        payload['media'] = _uploadedMedia.asMap().entries.map((entry) {
          return {
            'url': entry.value['url'],
            'type': entry.value['type'],
            'position': entry.key,
          };
        }).toList();
      }

      if (hasPoll) {
        final options = _pollOptionCtrls
            .map((c) => c.text.trim())
            .where((t) => t.isNotEmpty)
            .toList();

        if (options.length >= 2) {
          payload['poll'] = {
            'question': _pollQuestionCtrl.text.trim(),
            'options': options,
            'expires_at': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
          };
        }
      }

      await ref.read(feedRepositoryProvider).createPost(payload);
      ref.invalidate(feedProvider);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memposting: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: ManahColors.darkGrey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Buat Postingan',
          style: TextStyle(color: ManahColors.darkGrey, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ElevatedButton(
              onPressed: (_saving || _isUploadingMedia) ? null : _post,
              style: ElevatedButton.styleFrom(
                backgroundColor: ManahColors.brand,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                elevation: 0,
              ),
              child: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Posting', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isUploadingMedia)
            const LinearProgressIndicator(
              backgroundColor: ManahColors.brandSurface,
              color: ManahColors.brand,
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(ManahSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _body,
                    maxLines: null,
                    autofocus: true,
                    style: const TextStyle(fontSize: 16, color: ManahColors.darkGrey, height: 1.5),
                    decoration: const InputDecoration(
                      hintText: 'Apa yang ingin kamu bagikan?',
                      hintStyle: TextStyle(color: ManahColors.mediumGrey),
                      border: InputBorder.none,
                      filled: false,
                    ),
                  ),
                  const SizedBox(height: ManahSpacing.base),

                  // Display uploaded media gallery
                  if (_uploadedMedia.isNotEmpty) ...[
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _uploadedMedia.length,
                        itemBuilder: (context, i) {
                          final item = _uploadedMedia[i];
                          final isVideo = item['type'] == 'video';

                          return Container(
                            margin: const EdgeInsets.only(right: ManahSpacing.sm),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(ManahRadius.md),
                              color: theme.dividerColor.withValues(alpha: 0.1),
                              image: isVideo
                                  ? null
                                  : DecorationImage(
                                      image: FileImage(File(item['localPath']!)),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                if (isVideo)
                                  const Center(
                                    child: Icon(Icons.play_circle_fill, size: 40, color: ManahColors.brand),
                                  ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _uploadedMedia.removeAt(i);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, size: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: ManahSpacing.base),
                  ],

                  // Poll Builder Card
                  if (_showPoll) ...[
                    Card(
                      elevation: 0,
                      color: ManahColors.brandSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ManahRadius.md),
                        side: BorderSide(color: ManahColors.brand.withValues(alpha: 0.2)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(ManahSpacing.base),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.poll_outlined, color: ManahColors.brand, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Buat Polling',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: ManahColors.brand),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 18, color: ManahColors.brand),
                                  onPressed: () {
                                    setState(() {
                                      _showPoll = false;
                                      _pollQuestionCtrl.clear();
                                      for (final c in _pollOptionCtrls) {
                                        c.clear();
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: ManahSpacing.xs),
                            TextField(
                              controller: _pollQuestionCtrl,
                              decoration: const InputDecoration(
                                hintText: 'Pertanyaan polling...',
                                isDense: true,
                                border: UnderlineInputBorder(),
                                filled: false,
                              ),
                            ),
                            const SizedBox(height: ManahSpacing.base),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _pollOptionCtrls.length,
                              separatorBuilder: (_, __) => const SizedBox(height: ManahSpacing.xs),
                              itemBuilder: (context, idx) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _pollOptionCtrls[idx],
                                        decoration: InputDecoration(
                                          hintText: 'Pilihan ${idx + 1}',
                                          isDense: true,
                                          filled: false,
                                        ),
                                      ),
                                    ),
                                    if (_pollOptionCtrls.length > 2)
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: ManahColors.error, size: 20),
                                        onPressed: () => _removePollOption(idx),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: ManahSpacing.base),
                            if (_pollOptionCtrls.length < 5)
                              TextButton.icon(
                                onPressed: _addPollOption,
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Tambah Pilihan'),
                                style: TextButton.styleFrom(
                                  foregroundColor: ManahColors.brand,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: ManahSpacing.base),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Toolbar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1))),
            ),
            padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.base, vertical: ManahSpacing.xs),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image_outlined, color: ManahColors.brand),
                  onPressed: _pickImages,
                  tooltip: 'Tambah Gambar',
                ),
                IconButton(
                  icon: const Icon(Icons.videocam_outlined, color: ManahColors.brand),
                  onPressed: _pickVideo,
                  tooltip: 'Tambah Video',
                ),
                IconButton(
                  icon: const Icon(Icons.poll_outlined, color: ManahColors.brand),
                  onPressed: () {
                    setState(() => _showPoll = true);
                  },
                  tooltip: 'Buat Polling',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
