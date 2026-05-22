import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../widgets/section_header.dart';

class NavigationTabScreen extends StatelessWidget {
  const NavigationTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.galleryNavScreenTitle),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: const Icon(Icons.tab, size: 16), text: l10n.galleryTabTabBar),
              Tab(icon: const Icon(Icons.view_quilt, size: 16), text: l10n.galleryTabBottomNav),
              Tab(icon: const Icon(Icons.linear_scale, size: 16), text: l10n.galleryTabStepper),
              Tab(icon: const Icon(Icons.menu, size: 16), text: l10n.galleryTabDrawer),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TabBarDemo(),
            _BottomNavDemo(),
            _StepperDemo(),
            _DrawerDemo(),
          ],
        ),
      ),
    );
  }
}

// ── 1. Tab Bar Demo ────────────────────────────────────────────────────────

class _TabBarDemo extends StatelessWidget {
  const _TabBarDemo();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const SectionHeader(
              title: 'Tab Bar 4 Tab',
              subtitle: 'Dengan konten berbeda per tab'),
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: const TabBar(
              tabs: [
                Tab(text: 'Semua'),
                Tab(text: 'Aktif'),
                Tab(text: 'Selesai'),
                Tab(text: 'Arsip'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: ['Semua', 'Aktif', 'Selesai', 'Arsip'].map((label) {
                final colors = [
                  Colors.blue,
                  Colors.green,
                  Colors.teal,
                  Colors.grey
                ];
                final idx =
                    ['Semua', 'Aktif', 'Selesai', 'Arsip'].indexOf(label);
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: 6,
                  itemBuilder: (_, i) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colors[idx].withValues(alpha:0.2),
                      child: Text('${i + 1}',
                          style: TextStyle(
                              color: colors[idx], fontWeight: FontWeight.bold)),
                    ),
                    title: Text('Item $label ${i + 1}'),
                    subtitle: Text('Deskripsi untuk $label item ${i + 1}'),
                    trailing: Chip(
                      label: Text(label, style: const TextStyle(fontSize: 11)),
                      backgroundColor: colors[idx].withValues(alpha:0.15),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 2. Bottom Nav Demo ─────────────────────────────────────────────────────

class _BottomNavDemo extends StatefulWidget {
  const _BottomNavDemo();

  @override
  State<_BottomNavDemo> createState() => _BottomNavDemoState();
}

class _BottomNavDemoState extends State<_BottomNavDemo> {
  int _selected = 0;

  static const _items = [
    BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home'),
    BottomNavigationBarItem(
        icon: Icon(Icons.explore_outlined),
        activeIcon: Icon(Icons.explore),
        label: 'Explore'),
    BottomNavigationBarItem(
        icon: Icon(Icons.notifications_outlined),
        activeIcon: Icon(Icons.notifications),
        label: 'Notifikasi'),
    BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(
            title: 'Bottom Navigation Preview',
            subtitle: 'Tap item untuk highlight'),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.touch_app_outlined,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        'Tab aktif: ${_items[_selected].label}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                BottomNavigationBar(
                  currentIndex: _selected,
                  onTap: (i) => setState(() => _selected = i),
                  type: BottomNavigationBarType.fixed,
                  elevation: 0,
                  items: _items,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.grey),
                      SizedBox(width: 6),
                      Expanded(
                          child: Text('NavigationBar (Material 3)',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey))),
                    ],
                  ),
                ),
                NavigationBar(
                  selectedIndex: _selected,
                  onDestinationSelected: (i) => setState(() => _selected = i),
                  elevation: 0,
                  destinations: const [
                    NavigationDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: 'Home'),
                    NavigationDestination(
                        icon: Icon(Icons.explore_outlined),
                        selectedIcon: Icon(Icons.explore),
                        label: 'Explore'),
                    NavigationDestination(
                        icon: Icon(Icons.notifications_outlined),
                        selectedIcon: Icon(Icons.notifications),
                        label: 'Notif'),
                    NavigationDestination(
                        icon: Icon(Icons.person_outline),
                        selectedIcon: Icon(Icons.person),
                        label: 'Profil'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── 3. Stepper / Wizard ────────────────────────────────────────────────────

class _StepperDemo extends StatefulWidget {
  const _StepperDemo();

  @override
  State<_StepperDemo> createState() => _StepperDemoState();
}

class _StepperDemoState extends State<_StepperDemo> {
  int _step = 0;
  final _nameCtrl = TextEditingController(text: 'Ahmad Rizki');
  final _emailCtrl = TextEditingController(text: 'ahmad@example.com');
  String _pref = 'Flutter';
  bool _agree = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SectionHeader(
              title: 'Stepper / Wizard 3 Langkah',
              subtitle: 'Data Diri → Preferensi → Konfirmasi'),
          Stepper(
            currentStep: _step,
            physics: const NeverScrollableScrollPhysics(),
            onStepTapped: (i) => setState(() => _step = i),
            controlsBuilder: (context, details) {
              final isLast = _step == 2;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (isLast) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Wizard selesai! Data berhasil disimpan.'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                          setState(() => _step = 0);
                        } else {
                          setState(() => _step++);
                        }
                      },
                      child: Text(isLast ? 'Selesai' : 'Lanjut'),
                    ),
                    const SizedBox(width: 8),
                    if (_step > 0)
                      OutlinedButton(
                        onPressed: () => setState(() => _step--),
                        child: const Text('Kembali'),
                      ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: const Text('Data Diri'),
                isActive: _step >= 0,
                state: _step > 0 ? StepState.complete : StepState.indexed,
                content: Column(
                  children: [
                    TextField(
                      controller: _nameCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Nama Lengkap'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text('Preferensi'),
                isActive: _step >= 1,
                state: _step > 1 ? StepState.complete : StepState.indexed,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tech Stack Favorit:'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['Flutter', 'Laravel', 'Next.js'].map((t) {
                        final selected = _pref == t;
                        return ChoiceChip(
                          label: Text(t),
                          selected: selected,
                          onSelected: (_) => setState(() => _pref = t),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text('Konfirmasi'),
                isActive: _step >= 2,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _confirmRow('Nama', _nameCtrl.text),
                    _confirmRow('Email', _emailCtrl.text),
                    _confirmRow('Stack', _pref),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      title:
                          const Text('Saya setuju dengan syarat & ketentuan'),
                      value: _agree,
                      onChanged: (v) => setState(() => _agree = v!),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _confirmRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: Text('$label:',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
            ),
            Text(value, style: const TextStyle(fontSize: 13)),
          ],
        ),
      );
}

// ── 4. Drawer Demo ─────────────────────────────────────────────────────────

class _DrawerDemo extends StatelessWidget {
  const _DrawerDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SectionHeader(
            title: 'Drawer Preview', subtitle: 'Buka Scaffold dengan drawer'),
        const SizedBox(height: 32),
        const Icon(Icons.menu_open, size: 80, color: Colors.grey),
        const SizedBox(height: 16),
        Text(
          'Tap tombol di bawah untuk membuka\nhalaman dengan drawer',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          icon: const Icon(Icons.menu),
          label: const Text('Buka Drawer'),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const _DrawerScaffold()),
          ),
        ),
      ],
    );
  }
}

class _DrawerScaffold extends StatelessWidget {
  const _DrawerScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman dengan Drawer')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Ahmad Rizki'),
              accountEmail: const Text('ahmad@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppColors.primaryDark,
                child: const Text('AR',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              decoration: BoxDecoration(color: AppColors.primary),
            ),
            ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Beranda'),
                onTap: () => Navigator.pop(context)),
            ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profil'),
                onTap: () => Navigator.pop(context)),
            ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifikasi'),
                onTap: () => Navigator.pop(context)),
            ListTile(
                leading: const Icon(Icons.bookmark),
                title: const Text('Tersimpan'),
                onTap: () => Navigator.pop(context)),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Pengaturan'),
                onTap: () => Navigator.pop(context)),
            ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Bantuan'),
                onTap: () => Navigator.pop(context)),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text('Keluar',
                  style: TextStyle(color: AppColors.error)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.swipe_left, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Tap ikon hamburger atau\ngeser dari kiri untuk buka drawer',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
