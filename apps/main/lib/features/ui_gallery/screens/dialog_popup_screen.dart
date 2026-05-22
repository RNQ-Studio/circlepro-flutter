import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../widgets/section_header.dart';
import '../widgets/demo_card.dart';

class DialogPopupScreen extends StatefulWidget {
  const DialogPopupScreen({super.key});

  @override
  State<DialogPopupScreen> createState() => _DialogPopupScreenState();
}

class _DialogPopupScreenState extends State<DialogPopupScreen> {
  // ── Helper ──────────────────────────────────────────────────────────────
  void _snack(String msg, Color bg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: bg,
      action: SnackBarAction(
        label: 'TUTUP',
        textColor: Colors.white,
        onPressed: () =>
            ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    ));
  }

  // ── 1. Alert Dialog Sederhana ───────────────────────────────────────────
  void _showSimpleAlert() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi'),
        content:
            const Text('Apakah kamu yakin ingin melanjutkan tindakan ini?'),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _snack('Berhasil dilanjutkan!', AppColors.success);
            },
            child: const Text('Ya, Lanjutkan'),
          ),
        ],
      ),
    );
  }

  // ── 2. Alert Dialog dengan Input ─────────────────────────────────────────
  void _showInputAlert() {
    final ctrl = TextEditingController();
    final key = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Masukkan Nama'),
        content: Form(
          key: key,
          child: TextFormField(
            controller: ctrl,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nama Lengkap',
              hintText: 'cth: Ahmad Rizki',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (key.currentState!.validate()) {
                final name = ctrl.text.trim();
                Navigator.pop(ctx);
                _snack('Halo, $name! Data tersimpan.', AppColors.success);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // ── 3. Destructive Dialog ────────────────────────────────────────────────
  void _showDestructiveAlert() {
    showDialog(
      context: context,
      builder: (ctx) => _ShakeDialog(
        onConfirm: () {
          Navigator.pop(ctx);
          _snack('Item berhasil dihapus.', AppColors.error);
        },
        onCancel: () => Navigator.pop(ctx),
      ),
    );
  }

  // ── 4. Bottom Sheet Standard ─────────────────────────────────────────────
  void _showStandardSheet() {
    final items = [
      ('Edit', Icons.edit_outlined),
      ('Share', Icons.share_outlined),
      ('Download', Icons.download_outlined),
      ('Hapus', Icons.delete_outline),
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 8),
          for (final item in items)
            ListTile(
              leading: Icon(item.$2),
              title: Text(item.$1),
              onTap: () {
                Navigator.pop(ctx);
                _snack('${item.$1} dipilih', AppColors.info);
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── 5. Draggable Bottom Sheet ────────────────────────────────────────────
  void _showDraggableSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.35,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (_, controller) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('Daftar Item',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: 20,
                itemBuilder: (_, i) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Text('${i + 1}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontSize: 12)),
                  ),
                  title: Text('Item ${i + 1}'),
                  subtitle: Text('Subtitle untuk item nomor ${i + 1}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 6. Custom Dialog (countdown) ─────────────────────────────────────────
  void _showCustomDialog() {
    showDialog(
      context: context,
      builder: (ctx) =>
          _CountdownDialog(onDismiss: () => Navigator.pop(ctx)),
    );
  }

  // ── 7. Loading Dialog ────────────────────────────────────────────────────
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _LoadingDialog(),
    );
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
        _showCustomDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.galleryDialogScreenTitle)),
      body: ListView(
        children: [
          SectionHeader(
              title: l10n.gallerySectionAlertDialogs, subtitle: l10n.gallerySectionAlertDialogsDesc),
          DemoCard(
            title: '1. Alert Dialog Sederhana',
            subtitle: 'Konfirmasi dengan dua tombol',
            child: _DemoBtn('LIHAT DIALOG', _showSimpleAlert),
          ),
          DemoCard(
            title: '2. Dialog dengan Input',
            subtitle: 'Dialog berisi form input + validasi',
            child: _DemoBtn('LIHAT DIALOG', _showInputAlert),
          ),
          DemoCard(
            title: '3. Destructive Dialog',
            subtitle: 'Hapus item dengan animasi shake',
            child: _DemoBtn('LIHAT DIALOG', _showDestructiveAlert,
                color: AppColors.error),
          ),
          SectionHeader(
              title: l10n.gallerySectionBottomSheets, subtitle: l10n.gallerySectionBottomSheetsDesc),
          DemoCard(
            title: '4. Bottom Sheet Standard',
            subtitle: 'Daftar opsi dengan drag handle',
            child: _DemoBtn('LIHAT SHEET', _showStandardSheet),
          ),
          DemoCard(
            title: '5. Draggable Scrollable Sheet',
            subtitle: 'Bisa di-drag 30%–90% layar',
            child: _DemoBtn('LIHAT SHEET', _showDraggableSheet),
          ),
          SectionHeader(
              title: l10n.gallerySectionCustomDialogs, subtitle: l10n.gallerySectionCustomDialogsDesc),
          DemoCard(
            title: '6. Custom Dialog + Countdown',
            subtitle: 'Dialog sukses, auto-close 3 detik',
            child: _DemoBtn('LIHAT DIALOG', _showCustomDialog),
          ),
          DemoCard(
            title: '7. Loading Dialog',
            subtitle: 'Tidak bisa dismiss, auto-close lalu tampil sukses',
            child: _DemoBtn('LIHAT DIALOG', _showLoadingDialog),
          ),
          SectionHeader(
              title: l10n.gallerySectionSnackbarVariants, subtitle: l10n.gallerySectionSnackbarVariantsDesc),
          DemoCard(
            title: '8. SnackBar Variants',
            subtitle: 'Tap salah satu tombol di bawah',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SnackBtn('Info', Icons.info_outline, AppColors.info,
                    () => _snack('Info: Operasi sedang diproses', AppColors.info)),
                const SizedBox(height: 8),
                _SnackBtn('Sukses', Icons.check_circle_outline,
                    AppColors.success,
                    () => _snack('Sukses: Data berhasil disimpan', AppColors.success)),
                const SizedBox(height: 8),
                _SnackBtn('Warning', Icons.warning_amber_outlined,
                    AppColors.warning,
                    () => _snack('Warning: Stok hampir habis', AppColors.warning)),
                const SizedBox(height: 8),
                _SnackBtn('Error', Icons.error_outline, AppColors.error,
                    () => _snack('Error: Terjadi kesalahan server', AppColors.error)),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Local helper widgets ───────────────────────────────────────────────────

class _DemoBtn extends StatelessWidget {
  const _DemoBtn(this.label, this.onPressed, {this.color});
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: color != null
              ? ElevatedButton.styleFrom(backgroundColor: color)
              : null,
          onPressed: onPressed,
          child: Text(label),
        ),
      );
}

class _SnackBtn extends StatelessWidget {
  const _SnackBtn(this.label, this.icon, this.color, this.onPressed);
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: color, foregroundColor: Colors.white),
        icon: Icon(icon, size: 18),
        label: Text(label),
        onPressed: onPressed,
      );
}

// ── Shake Dialog ───────────────────────────────────────────────────────────

class _ShakeDialog extends StatefulWidget {
  const _ShakeDialog({required this.onConfirm, required this.onCancel});
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  State<_ShakeDialog> createState() => _ShakeDialogState();
}

class _ShakeDialogState extends State<_ShakeDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _shake;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _shake = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _triggerShake() async {
    await _ctrl.forward();
    _ctrl.reset();
    widget.onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shake,
      builder: (_, child) =>
          Transform.translate(offset: Offset(_shake.value, 0), child: child),
      child: AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded,
            color: AppColors.error, size: 52),
        title: const Text('Hapus Item?'),
        content: const Text(
            'Tindakan ini tidak dapat dibatalkan. Item akan dihapus secara permanen dari sistem.'),
        actions: [
          OutlinedButton(
              onPressed: widget.onCancel, child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: _triggerShake,
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

// ── Countdown Dialog ───────────────────────────────────────────────────────

class _CountdownDialog extends StatefulWidget {
  const _CountdownDialog({required this.onDismiss});
  final VoidCallback onDismiss;

  @override
  State<_CountdownDialog> createState() => _CountdownDialogState();
}

class _CountdownDialogState extends State<_CountdownDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  int _seconds = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _seconds--);
      if (_seconds <= 0) {
        t.cancel();
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, __) => CircularProgressIndicator(
                      value: 1 - _ctrl.value,
                      strokeWidth: 5,
                      color: AppColors.success,
                      backgroundColor: Colors.green.shade100,
                    ),
                  ),
                ),
                const Icon(Icons.check_circle,
                    color: AppColors.success, size: 64),
              ],
            ),
            const SizedBox(height: 20),
            Text('Berhasil!',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Operasi selesai dengan sukses.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text('Menutup dalam $_seconds detik...',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey)),
            const SizedBox(height: 16),
            OutlinedButton(
                onPressed: widget.onDismiss, child: const Text('Tutup Sekarang')),
          ],
        ),
      ),
    );
  }
}

// ── Loading Dialog ─────────────────────────────────────────────────────────

class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text('Memproses...',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('Mohon tunggu sebentar',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
