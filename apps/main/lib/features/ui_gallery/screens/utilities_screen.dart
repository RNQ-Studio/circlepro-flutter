import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core/core.dart';
import '../widgets/section_header.dart';
import '../widgets/demo_card.dart';
import '../data/dummy_data.dart';

class UtilitiesScreen extends StatelessWidget {
  const UtilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.galleryUtilitiesScreenTitle)),
      body: ListView(
        children: [
          SectionHeader(title: l10n.gallerySectionChipVariants, subtitle: l10n.gallerySectionChipVariantsDesc),
          const _ChipVariants(),
          SectionHeader(title: l10n.gallerySectionBadge, subtitle: l10n.gallerySectionBadgeDesc),
          const _BadgeDemo(),
          SectionHeader(title: l10n.gallerySectionSearchFilter, subtitle: l10n.gallerySectionSearchFilterDesc),
          const _SearchBarFilter(),
          SectionHeader(title: l10n.gallerySectionTooltip, subtitle: l10n.gallerySectionTooltipDesc),
          const _TooltipShowcase(),
          SectionHeader(title: l10n.gallerySectionClipboard, subtitle: l10n.gallerySectionClipboardDesc),
          const _ClipboardCopy(),
          SectionHeader(title: l10n.gallerySectionImagePicker, subtitle: l10n.gallerySectionImagePickerDesc),
          const _ImagePickerDemo(),
          SectionHeader(title: l10n.gallerySectionColorPicker, subtitle: l10n.gallerySectionColorPickerDesc),
          const _ColorPicker(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── 1. Chip Variants ───────────────────────────────────────────────────────

class _ChipVariants extends StatefulWidget {
  const _ChipVariants();

  @override
  State<_ChipVariants> createState() => _ChipVariantsState();
}

class _ChipVariantsState extends State<_ChipVariants> {
  final List<String> _inputChips = ['Flutter', 'Dart', 'Firebase'];
  final Map<String, bool> _filterChips = {
    'Flutter': true, 'Laravel': false, 'Next.js': true, 'Vue.js': false,
  };
  String _choiceChip = 'Mobile';

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Chip Variants',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input Chips
          Text('Input Chips (tap X untuk hapus)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: _inputChips.map((chip) => Chip(
              label: Text(chip),
              onDeleted: () => setState(() => _inputChips.remove(chip)),
            )).toList(),
          ),
          const Divider(height: 24),

          // Filter Chips
          Text('Filter Chips (toggle on/off)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: _filterChips.entries.map((e) => FilterChip(
              label: Text(e.key),
              selected: e.value,
              onSelected: (v) => setState(() => _filterChips[e.key] = v),
            )).toList(),
          ),
          const Divider(height: 24),

          // Action Chips
          Text('Action Chips (tap = aksi)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.share, size: 16),
                label: const Text('Share'),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share dibagikan!'))),
              ),
              ActionChip(
                avatar: const Icon(Icons.download, size: 16),
                label: const Text('Download'),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mulai mengunduh...'))),
              ),
            ],
          ),
          const Divider(height: 24),

          // Choice Chips
          Text('Choice Chips (single select)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: ['Mobile', 'Web', 'Desktop', 'Embedded'].map((opt) => ChoiceChip(
              label: Text(opt),
              selected: _choiceChip == opt,
              onSelected: (_) => setState(() => _choiceChip = opt),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

// ── 2. Badge & Notification Dot ────────────────────────────────────────────

class _BadgeDemo extends StatefulWidget {
  const _BadgeDemo();

  @override
  State<_BadgeDemo> createState() => _BadgeDemoState();
}

class _BadgeDemoState extends State<_BadgeDemo> {
  int _count = 3;

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Badge',
      subtitle: 'Angka badge beranimasi saat berubah',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Badge(
                label: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                  child: Text('$_count', key: ValueKey(_count)),
                ),
                isLabelVisible: _count > 0,
                child: const Icon(Icons.notifications_outlined, size: 40),
              ),
              const SizedBox(height: 8),
              const Text('Notifikasi', style: TextStyle(fontSize: 12)),
            ],
          ),
          Column(
            children: [
              Badge(
                label: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                  child: Text('$_count', key: ValueKey(_count)),
                ),
                isLabelVisible: _count > 0,
                child: const Icon(Icons.mail_outline, size: 40),
              ),
              const SizedBox(height: 8),
              const Text('Pesan', style: TextStyle(fontSize: 12)),
            ],
          ),
          Column(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text('+1'),
                onPressed: () => setState(() => _count++),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.close, size: 16),
                label: const Text('Reset'),
                onPressed: _count > 0 ? () => setState(() => _count = 0) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── 3. Search Bar + Filter ─────────────────────────────────────────────────

class _SearchBarFilter extends StatefulWidget {
  const _SearchBarFilter();

  @override
  State<_SearchBarFilter> createState() => _SearchBarFilterState();
}

class _SearchBarFilterState extends State<_SearchBarFilter> {
  final _ctrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<String> get _filtered {
    if (_query.isEmpty) return DummyData.searchItems;
    return DummyData.searchItems
        .where((item) => item.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Search Bar',
      subtitle: 'Filter real-time saat mengetik',
      child: Column(
        children: [
          TextField(
            controller: _ctrl,
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: 'Cari komponen...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _ctrl.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          if (_filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Tidak ditemukan', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final item = _filtered[i];
                  final idx = item.toLowerCase().indexOf(_query.toLowerCase());
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.widgets_outlined, size: 18),
                    title: idx < 0 || _query.isEmpty
                        ? Text(item)
                        : RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14),
                              children: [
                                TextSpan(text: item.substring(0, idx)),
                                TextSpan(
                                    text: item.substring(idx, idx + _query.length),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                        backgroundColor: Color(0x20006FEE))),
                                TextSpan(text: item.substring(idx + _query.length)),
                              ],
                            ),
                          ),
                  );
                },
              ),
            ),
          if (_filtered.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('${_filtered.length} hasil ditemukan',
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ),
        ],
      ),
    );
  }
}

// ── 4. Tooltip ─────────────────────────────────────────────────────────────

class _TooltipShowcase extends StatelessWidget {
  const _TooltipShowcase();

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Tooltips',
      subtitle: 'Long press ikon untuk lihat tooltip',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Tooltip(
            message: 'Tambah item baru ke dalam daftar',
            preferBelow: false,
            child: IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 36, color: AppColors.primary),
              onPressed: () {},
            ),
          ),
          Tooltip(
            message: 'Edit konten yang sudah ada',
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(color: Colors.white, fontSize: 12),
            child: IconButton(
              icon: const Icon(Icons.edit_outlined, size: 36, color: AppColors.secondary),
              onPressed: () {},
            ),
          ),
          Tooltip(
            message: 'Hapus item ini secara permanen',
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(color: Colors.white, fontSize: 12),
            child: IconButton(
              icon: const Icon(Icons.delete_outline, size: 36, color: AppColors.error),
              onPressed: () {},
            ),
          ),
          Tooltip(
            message: 'Bagikan ke platform lain',
            child: IconButton(
              icon: const Icon(Icons.share_outlined, size: 36, color: Colors.teal),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

// ── 5. Copy to Clipboard ───────────────────────────────────────────────────

class _ClipboardCopy extends StatefulWidget {
  const _ClipboardCopy();

  @override
  State<_ClipboardCopy> createState() => _ClipboardCopyState();
}

class _ClipboardCopyState extends State<_ClipboardCopy> {
  int? _copiedIndex;

  void _copy(int index, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    setState(() => _copiedIndex = index);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berhasil disalin: ${DummyData.tokenLabels[index]}'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copiedIndex = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Copy to Clipboard',
      child: Column(
        children: List.generate(DummyData.tokens.length, (i) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DummyData.tokenLabels[i],
                        style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 2),
                    Text(
                      DummyData.tokens[i],
                      style: const TextStyle(
                          fontFamily: 'monospace', fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: IconButton(
                  key: ValueKey(_copiedIndex == i),
                  icon: Icon(
                    _copiedIndex == i ? Icons.check : Icons.copy_outlined,
                    size: 18,
                    color: _copiedIndex == i ? AppColors.success : Colors.grey,
                  ),
                  onPressed: () => _copy(i, DummyData.tokens[i]),
                  tooltip: 'Salin',
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

// ── 6. Image Picker Placeholder ────────────────────────────────────────────

class _ImagePickerDemo extends StatefulWidget {
  const _ImagePickerDemo();

  @override
  State<_ImagePickerDemo> createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<_ImagePickerDemo> {
  bool _hasImage = false;

  void _showPickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
                color: Colors.grey[400], borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Kamera'),
            onTap: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur ini memerlukan permission device')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Galeri'),
            onTap: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur ini memerlukan permission device')));
            },
          ),
          if (_hasImage)
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.error),
              title: const Text('Hapus Foto', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(ctx);
                setState(() => _hasImage = false);
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Image Picker Placeholder',
      subtitle: 'Tap area untuk pilih gambar',
      child: GestureDetector(
        onTap: _showPickerSheet,
        child: Container(
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primary.withOpacity(0.5),
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.primary.withOpacity(0.04),
          ),
          child: _hasImage
              ? Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: AppColors.success, size: 40),
                      SizedBox(height: 8),
                      Text('Foto dipilih', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                      Text('Tap untuk ubah', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined, size: 40, color: AppColors.primary),
                    SizedBox(height: 8),
                    Text('Tap untuk pilih foto', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
                    SizedBox(height: 4),
                    Text('JPG, PNG, maks. 5MB', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
        ),
      ),
    );
  }
}

// ── 7. Color Picker ────────────────────────────────────────────────────────

class _ColorPicker extends StatefulWidget {
  const _ColorPicker();

  @override
  State<_ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<_ColorPicker> {
  static const _palette = [
    Color(0xFF2563EB), Color(0xFF7C3AED), Color(0xFF059669),
    Color(0xFFDC2626), Color(0xFFD97706), Color(0xFF0891B2),
    Color(0xFFDB2777), Color(0xFF7C3AED), Color(0xFF0D9488),
    Color(0xFF9333EA),
  ];

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Color Picker',
      subtitle: 'Tap kotak warna untuk memilih',
      child: Column(
        children: [
          // Preview
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: _palette[_selected],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.palette, color: Colors.white70, size: 24),
                  Text(
                    '#${_palette[_selected].value.toRadixString(16).substring(2).toUpperCase()}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Palette
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(_palette.length, (i) => GestureDetector(
              onTap: () => setState(() => _selected = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: i == _selected ? 44 : 36,
                height: i == _selected ? 44 : 36,
                decoration: BoxDecoration(
                  color: _palette[i],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: i == _selected ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: i == _selected
                      ? [BoxShadow(color: _palette[i].withOpacity(0.5), blurRadius: 8, spreadRadius: 2)]
                      : [],
                ),
                child: i == _selected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            )),
          ),
        ],
      ),
    );
  }
}
