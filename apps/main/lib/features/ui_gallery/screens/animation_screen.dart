import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../widgets/section_header.dart';
import '../widgets/demo_card.dart';

class AnimationScreen extends StatelessWidget {
  const AnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.galleryAnimScreenTitle)),
      body: ListView(
        children: [
          SectionHeader(title: l10n.gallerySectionHeroAnim, subtitle: l10n.gallerySectionHeroAnimDesc),
          const _HeroSection(),
          SectionHeader(title: l10n.gallerySectionAnimContainer, subtitle: l10n.gallerySectionAnimContainerDesc),
          const _AnimatedContainerSection(),
          SectionHeader(title: l10n.gallerySectionPageTransition, subtitle: l10n.gallerySectionPageTransitionDesc),
          const _PageTransitionSection(),
          SectionHeader(title: l10n.gallerySectionAnimatedList, subtitle: l10n.gallerySectionAnimatedListDesc),
          const _AnimatedListSection(),
          SectionHeader(title: l10n.gallerySectionAnimatedIcons, subtitle: l10n.gallerySectionAnimatedIconsDesc),
          const _AnimatedIconSection(),
          SectionHeader(title: l10n.gallerySectionStaggered, subtitle: l10n.gallerySectionStaggeredDesc),
          const _StaggeredSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── 1. Hero Animation ──────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  static const _colors = [
    Colors.indigo, Colors.teal, Colors.orange, Colors.pink,
  ];
  static const _labels = ['Indigo', 'Teal', 'Orange', 'Pink'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: List.generate(4, (i) => GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => _HeroDetailScreen(index: i, color: _colors[i], label: _labels[i]),
            ),
          ),
          child: Hero(
            tag: 'hero-$i',
            child: Container(
              decoration: BoxDecoration(
                color: _colors[i],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(_labels[i],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
          ),
        )),
      ),
    );
  }
}

class _HeroDetailScreen extends StatelessWidget {
  const _HeroDetailScreen({required this.index, required this.color, required this.label});
  final int index;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hero: $label'), backgroundColor: color, foregroundColor: Colors.white),
      body: Column(
        children: [
          Hero(
            tag: 'hero-$index',
            child: Container(
              height: 240,
              color: color,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.touch_app, color: Colors.white70, size: 48),
                    const SizedBox(height: 12),
                    Text(label,
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Ini adalah halaman detail dari Hero "$label".\nTekan tombol kembali untuk melihat animasi Hero sebaliknya.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 2. Animated Container ──────────────────────────────────────────────────

class _AnimatedContainerSection extends StatefulWidget {
  const _AnimatedContainerSection();

  @override
  State<_AnimatedContainerSection> createState() => _AnimatedContainerSectionState();
}

class _AnimatedContainerSectionState extends State<_AnimatedContainerSection> {
  bool _large = false;
  bool _blue = true;
  bool _rounded = false;

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Animated Container',
      subtitle: 'Semua transisi smooth',
      child: Column(
        children: [
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: _large ? 200 : 80,
              height: _large ? 120 : 80,
              decoration: BoxDecoration(
                color: _blue ? AppColors.primary : AppColors.secondary,
                borderRadius: BorderRadius.circular(_rounded ? 40 : 8),
              ),
              child: const Center(
                child: Icon(Icons.widgets, color: Colors.white, size: 32),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => setState(() => _large = !_large),
                child: Text(_large ? 'Kecilkan' : 'Besarkan'),
              ),
              OutlinedButton(
                onPressed: () => setState(() => _blue = !_blue),
                child: Text(_blue ? 'Ungu' : 'Biru'),
              ),
              OutlinedButton(
                onPressed: () => setState(() => _rounded = !_rounded),
                child: Text(_rounded ? 'Kotak' : 'Bulat'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── 3. Page Transition ──────────────────────────────────────────────────────

class _PageTransitionSection extends StatelessWidget {
  const _PageTransitionSection();

  void _navigate(BuildContext context, String type) {
    late PageRoute route;
    final page = _TransitionDemoPage(title: '$type Transition');
    switch (type) {
      case 'Fade':
        route = PageRouteBuilder(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        );
      case 'Slide':
        route = PageRouteBuilder(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, anim, __, child) => SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 400),
        );
      default: // Scale
        route = PageRouteBuilder(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, anim, __, child) => ScaleTransition(
            scale: CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: FadeTransition(opacity: anim, child: child),
          ),
          transitionDuration: const Duration(milliseconds: 400),
        );
    }
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Custom Page Transitions',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: ['Fade', 'Slide', 'Scale'].map((type) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: OutlinedButton(
            onPressed: () => _navigate(context, type),
            child: Text('Buka dengan $type'),
          ),
        )).toList(),
      ),
    );
  }
}

class _TransitionDemoPage extends StatelessWidget {
  const _TransitionDemoPage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.animation, size: 80, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Halaman ini muncul dengan $title',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 4. Animated List ───────────────────────────────────────────────────────

class _AnimatedListSection extends StatefulWidget {
  const _AnimatedListSection();

  @override
  State<_AnimatedListSection> createState() => _AnimatedListSectionState();
}

class _AnimatedListSectionState extends State<_AnimatedListSection> {
  final _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = ['Item pertama', 'Item kedua', 'Item ketiga'];
  int _counter = 4;

  void _addItem() {
    final newItem = 'Item ke-$_counter';
    _items.insert(0, newItem);
    _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 350));
    _counter++;
  }

  void _removeItem(int index) {
    final removed = _items[index];
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(removed, animation, index),
      duration: const Duration(milliseconds: 350),
    );
    _items.removeAt(index);
  }

  Widget _buildItem(String item, Animation<double> anim, int index) {
    return SizeTransition(
      sizeFactor: anim,
      child: FadeTransition(
        opacity: anim,
        child: Card(
          margin: const EdgeInsets.only(bottom: 6),
          child: ListTile(
            leading: const Icon(Icons.list),
            title: Text(item),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () => _removeItem(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Animated List',
      subtitle: 'Tambah/hapus dengan animasi slide+fade',
      child: Column(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Tambah Item'),
            onPressed: _addItem,
          ),
          const SizedBox(height: 12),
          AnimatedList(
            key: _listKey,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            initialItemCount: _items.length,
            itemBuilder: (context, index, animation) =>
                _buildItem(_items[index], animation, index),
          ),
        ],
      ),
    );
  }
}

// ── 5. Animated Icons ──────────────────────────────────────────────────────

class _AnimatedIconSection extends StatefulWidget {
  const _AnimatedIconSection();

  @override
  State<_AnimatedIconSection> createState() => _AnimatedIconSectionState();
}

class _AnimatedIconSectionState extends State<_AnimatedIconSection>
    with TickerProviderStateMixin {
  late final AnimationController _playPauseCtrl;
  late final AnimationController _menuCtrl;
  bool _playing = false;
  bool _menuOpen = false;

  @override
  void initState() {
    super.initState();
    _playPauseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _menuCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _playPauseCtrl.dispose();
    _menuCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'AnimatedIcon bawaan Flutter',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() => _playing = !_playing);
                  _playing ? _playPauseCtrl.forward() : _playPauseCtrl.reverse();
                },
                child: Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _playPauseCtrl,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(_playing ? 'Pause' : 'Play',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() => _menuOpen = !_menuOpen);
                  _menuOpen ? _menuCtrl.forward() : _menuCtrl.reverse();
                },
                child: Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _menuCtrl,
                    color: AppColors.secondary,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(_menuOpen ? 'Close' : 'Menu',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── 6. Staggered Animation ─────────────────────────────────────────────────

class _StaggeredSection extends StatefulWidget {
  const _StaggeredSection();

  @override
  State<_StaggeredSection> createState() => _StaggeredSectionState();
}

class _StaggeredSectionState extends State<_StaggeredSection>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  static const _count = 5;

  static const _titles = ['Flutter SDK', 'Riverpod', 'GoRouter', 'Material 3', 'Dio Client'];
  static const _subtitles = [
    'Framework multi-platform', 'State management', 'Deklaratif routing',
    'Design system terbaru', 'HTTP client',
  ];
  static const _colors = [Colors.blue, Colors.purple, Colors.teal, Colors.orange, Colors.red];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _count,
      (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 400)),
    );
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    for (var i = 0; i < _count; i++) {
      await Future.delayed(Duration(milliseconds: i == 0 ? 300 : 120));
      if (mounted) _controllers[i].forward();
    }
  }

  void _resetAnimation() async {
    for (final c in _controllers) {
      c.reset();
    }
    _startAnimation();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: List.generate(_count, (i) {
              final anim = CurvedAnimation(
                parent: _controllers[i],
                curve: Curves.easeOut,
              );
              return AnimatedBuilder(
                animation: anim,
                builder: (_, child) => SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.6, 0),
                    end: Offset.zero,
                  ).animate(anim),
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: _colors[i].withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.code, color: _colors[i], size: 20),
                    ),
                    title: Text(_titles[i]),
                    subtitle: Text(_subtitles[i]),
                    trailing: Text('${(i + 1) * 100}ms',
                        style: TextStyle(fontSize: 11, color: _colors[i])),
                  ),
                ),
              );
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.replay, size: 18),
            label: const Text('Ulangi Animasi'),
            onPressed: _resetAnimation,
          ),
        ),
      ],
    );
  }
}
