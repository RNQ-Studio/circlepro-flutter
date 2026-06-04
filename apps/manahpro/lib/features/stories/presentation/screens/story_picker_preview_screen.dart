import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../stories_provider.dart';

class StoryPickerPreviewScreen extends ConsumerStatefulWidget {
  const StoryPickerPreviewScreen({
    super.key,
    required this.filePath,
  });

  final String filePath;

  @override
  ConsumerState<StoryPickerPreviewScreen> createState() => _StoryPickerPreviewScreenState();
}

class _StoryPickerPreviewScreenState extends ConsumerState<StoryPickerPreviewScreen> {
  VideoPlayerController? _videoController;
  final _captionController = TextEditingController();
  bool _isVideo = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _checkFileType();
  }

  void _checkFileType() {
    final lower = widget.filePath.toLowerCase();
    if (lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.mkv') ||
        lower.endsWith('.3gp')) {
      _isVideo = true;
      _initVideo();
    }
  }

  void _initVideo() {
    _videoController = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _videoController?.play();
          _videoController?.setLooping(true);
        }
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _upload() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final caption = _captionController.text.trim();
      await ref.read(storiesProvider.notifier).addStory(
        widget.filePath,
        caption: caption.isNotEmpty ? caption : null,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cerita berhasil ditambahkan!')),
        );
        Navigator.pop(context); // Pop preview
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan cerita: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isUploading,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Media Preview
            Positioned.fill(
              child: Center(
                child: _isVideo
                    ? (_videoController != null && _videoController!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          )
                        : const CircularProgressIndicator(color: Colors.white))
                    : Image.file(
                        File(widget.filePath),
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            // Top Header: Back Button
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: _isUploading ? null : () => Navigator.pop(context),
              ),
            ),

            // Bottom Actions: Caption Input & Upload Button
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 24,
              left: 24,
              right: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextField(
                      controller: _captionController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2,
                      minLines: 1,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: 'Tambahkan keterangan (caption)...',
                        hintStyle: TextStyle(color: Colors.white60, fontSize: 14),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 4,
                    ),
                    onPressed: _isUploading ? null : _upload,
                    icon: const Icon(Icons.send_rounded),
                    label: const Text(
                      'Bagikan ke Cerita Anda',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Upload Overlay
            if (_isUploading)
              Container(
                color: Colors.black.withOpacity(0.6),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Mengunggah cerita...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
