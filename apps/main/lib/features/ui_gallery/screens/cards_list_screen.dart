import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../widgets/section_header.dart';
import '../data/dummy_data.dart';

class CardsListScreen extends StatefulWidget {
  const CardsListScreen({super.key});

  @override
  State<CardsListScreen> createState() => _CardsListScreenState();
}

class _CardsListScreenState extends State<CardsListScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.galleryCardsScreenTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.galleryTabCards),
              Tab(text: l10n.galleryTabLists),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _CardsTab(),
            _ListsTabWrapper(),
          ],
        ),
      ),
    );
  }
}

// ── Section A: Cards ───────────────────────────────────────────────────────

class _CardsTab extends StatelessWidget {
  const _CardsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SectionHeader(title: '1. Basic Card', subtitle: 'Elevasi, border radius, header image'),
        _buildBasicCard(context),
        const SectionHeader(title: '2. Horizontal Card', subtitle: 'Gambar di kiri, konten di kanan'),
        _buildHorizontalCard(context),
        const SectionHeader(title: '3. Stats Cards', subtitle: 'Tiga variant warna'),
        _buildStatsCards(context),
        const SectionHeader(title: '4. Profile Card', subtitle: 'Avatar, sosmed, tombol aksi'),
        _buildProfileCard(context),
        const SectionHeader(title: '5. Expandable Card (FAQ)', subtitle: 'Tap untuk expand/collapse'),
        _buildExpandableCards(context),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildBasicCard(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 16 / 7,
              child: Container(
                color: AppColors.primaryLight,
                child: const Center(
                  child: Icon(Icons.image_outlined, color: Colors.white70, size: 40),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Judul Konten Card', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text('Ini adalah deskripsi singkat dari konten card yang ditampilkan di sini.',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: () {}, child: const Text('Baca Selengkapnya')),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildHorizontalCard(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: AppColors.secondary.withOpacity(0.3),
                child: const Icon(Icons.article_outlined, size: 36, color: AppColors.secondary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Judul Artikel Berita', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text('Subtitle atau ringkasan singkat dari artikel ini',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('5 menit yang lalu · Flutter Dev',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildStatsCards(BuildContext context) {
    final stats = [
      ('Total Pengguna', '12,450', Icons.people_outline, Colors.blue),
      ('Pendapatan', 'Rp 45jt', Icons.monetization_on_outlined, Colors.green),
      ('Transaksi', '1,234', Icons.receipt_long_outlined, Colors.purple),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: stats.map((s) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Card(
              color: s.$4.withOpacity(0.12),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: s.$4.withOpacity(0.3))),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(s.$3, color: s.$4, size: 20),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      child: Text(s.$2,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold, color: s.$4)),
                    ),
                    const SizedBox(height: 4),
                    Text(s.$1,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.primary.withOpacity(0.15),
              child: const Icon(Icons.person, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Text('Ahmad Rizki', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text('Senior Flutter Developer', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icons.language, Icons.mail_outline, Icons.link]
                  .map((ic) => IconButton(
                        icon: Icon(ic, color: AppColors.primary),
                        onPressed: () {},
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: () {}, child: const Text('Ikuti')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(onPressed: () {}, child: const Text('Pesan')),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildExpandableCards(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: List.generate(DummyData.faqs.length, (i) => ExpansionTile(
          shape: const Border(),
          title: Text(DummyData.faqs[i], style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(DummyData.faqAnswers[i], style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        )),
      ),
    ),
  );
}

// Wrapper to pass state from parent
class _ListsTabWrapper extends StatefulWidget {
  const _ListsTabWrapper();

  @override
  State<_ListsTabWrapper> createState() => _ListsTabWrapperState();
}

class _ListsTabWrapperState extends State<_ListsTabWrapper> {
  late List<String> _dismissItems;
  late List<String> _reorderItems;

  @override
  void initState() {
    super.initState();
    _dismissItems = DummyData.names.take(8).toList();
    _reorderItems = DummyData.techStacks.take(6).toList();
  }

  void _undoDismiss(int index, String item) {
    setState(() => _dismissItems.insert(index, item));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SectionHeader(title: '1. ListTile Standard', subtitle: 'Avatar, title, subtitle, trailing icon'),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('Ahmad Rizki'),
            subtitle: const Text('Senior Flutter Developer'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {},
          ),
        ),
        const SectionHeader(title: '2. ListTile dengan Switch', subtitle: 'Toggle di trailing'),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: _SwitchListItems(),
        ),
        const SectionHeader(title: '3. ListTile dengan Checkbox', subtitle: 'Checkbox di leading'),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: _CheckboxListItems(),
        ),
        const SectionHeader(title: '4. Dismissible List', subtitle: 'Geser kanan = selesai, kiri = hapus'),
        ..._dismissItems.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Dismissible(
              key: ValueKey('$item-$i'),
              background: Container(
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Row(
                  children: [
                    Icon(Icons.check, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Selesai', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              secondaryBackground: Container(
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.delete, color: Colors.white),
                  ],
                ),
              ),
              onDismissed: (direction) {
                final removedItem = _dismissItems[i];
                final removedIndex = i;
                setState(() => _dismissItems.removeAt(i));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(direction == DismissDirection.startToEnd
                      ? '$removedItem ditandai selesai'
                      : '$removedItem dihapus'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () => _undoDismiss(removedIndex, removedItem),
                  ),
                ));
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.15),
                    child: Text(item[0], style: const TextStyle(color: AppColors.primary)),
                  ),
                  title: Text(item),
                  subtitle: Text(DummyData.roles[i % DummyData.roles.length]),
                ),
              ),
            ),
          );
        }),
        const SectionHeader(title: '5. Reorderable List', subtitle: 'Drag handle untuk ubah urutan'),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _reorderItems.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final item = _reorderItems.removeAt(oldIndex);
                _reorderItems.insert(newIndex, item);
              });
            },
            itemBuilder: (context, index) => ListTile(
              key: ValueKey(_reorderItems[index]),
              leading: const Icon(Icons.code),
              title: Text(_reorderItems[index]),
              trailing: const Icon(Icons.drag_handle),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SwitchListItems extends StatefulWidget {
  @override
  State<_SwitchListItems> createState() => _SwitchListItemsState();
}

class _SwitchListItemsState extends State<_SwitchListItems> {
  final List<bool> _values = [true, false, true];
  final List<String> _labels = ['Notifikasi Push', 'Email Marketing', 'Dark Mode'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_labels.length, (i) => SwitchListTile(
        title: Text(_labels[i]),
        value: _values[i],
        onChanged: (v) => setState(() => _values[i] = v),
      )),
    );
  }
}

class _CheckboxListItems extends StatefulWidget {
  @override
  State<_CheckboxListItems> createState() => _CheckboxListItemsState();
}

class _CheckboxListItemsState extends State<_CheckboxListItems> {
  final List<bool> _values = [true, false, true, false];
  final List<String> _labels = ['Flutter SDK', 'Android Studio', 'VS Code', 'Xcode'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_labels.length, (i) => CheckboxListTile(
        title: Text(_labels[i]),
        value: _values[i],
        onChanged: (v) => setState(() => _values[i] = v!),
      )),
    );
  }
}
