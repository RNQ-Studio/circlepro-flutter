import 'dart:math';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../widgets/section_header.dart';
import '../widgets/demo_card.dart';

class LoadingEmptyScreen extends StatelessWidget {
  const LoadingEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.galleryLoadingScreenTitle),
          bottom: TabBar(
            tabs: [Tab(text: l10n.galleryTabLoading), Tab(text: l10n.galleryTabEmptyState)],
          ),
        ),
        body: const TabBarView(
          children: [_LoadingTab(), _EmptyTab()],
        ),
      ),
    );
  }
}

// ── Loading Tab ────────────────────────────────────────────────────────────

class _LoadingTab extends StatefulWidget {
  const _LoadingTab();

  @override
  State<_LoadingTab> createState() => _LoadingTabState();
}

class _LoadingTabState extends State<_LoadingTab>
    with SingleTickerProviderStateMixin {
  // Shimmer
  bool _showingShimmer = true;
  late final AnimationController _shimmerCtrl;

  // Progress
  double _progress = 0;
  bool _progressRunning = false;

  // Pull-to-refresh list
  final _random = Random();
  late List<String> _refreshItems;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _refreshItems = _generateItems();
  }

  List<String> _generateItems() {
    final adjectives = ['Keren', 'Baru', 'Segar', 'Terbaru', 'Hot'];
    return List.generate(
        8,
        (i) =>
            '${adjectives[_random.nextInt(adjectives.length)]} Item ${_random.nextInt(100)}');
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  Future<void> _startProgress() async {
    if (_progressRunning) return;
    setState(() {
      _progressRunning = true;
      _progress = 0;
    });
    for (var i = 1; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted) return;
      setState(() => _progress = i / 100);
    }
    setState(() => _progressRunning = false);
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _refreshItems = _generateItems());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      children: [
        // 1. Shimmer
        SectionHeader(
            title: l10n.gallerySectionShimmer,
            subtitle: l10n.gallerySectionShimmerDesc),
        DemoCard(
          title: 'Shimmer Cards',
          subtitle: 'Toggle antara loading dan konten asli',
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Konten'),
                  Switch(
                    value: _showingShimmer,
                    onChanged: (v) => setState(() => _showingShimmer = v),
                  ),
                  const Text('Loading'),
                ],
              ),
              const SizedBox(height: 8),
              if (_showingShimmer)
                _ShimmerContainer(controller: _shimmerCtrl)
              else
                _RealContent(),
            ],
          ),
        ),

        // 2. Skeleton
        SectionHeader(
            title: l10n.gallerySectionSkeleton,
            subtitle: l10n.gallerySectionSkeletonDesc),
        DemoCard(
          title: 'Skeleton Avatar + Teks',
          child: _SkeletonDemo(controller: _shimmerCtrl),
        ),

        // 3. Linear Progress
        SectionHeader(
            title: l10n.gallerySectionLinearProgress,
            subtitle: l10n.gallerySectionLinearProgressDesc),
        DemoCard(
          title: 'Progress Bar',
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 44,
                    child: Text(
                      '${(_progress * 100).round()}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow, size: 18),
                label: Text(_progressRunning ? 'Loading...' : 'Mulai'),
                onPressed: _progressRunning ? null : _startProgress,
              ),
            ],
          ),
        ),

        // 4. Circular Progress
        SectionHeader(
            title: l10n.gallerySectionCircularProgress,
            subtitle: l10n.gallerySectionCircularProgressDesc),
        DemoCard(
          title: 'Progress Lingkaran',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _CircularProgress(value: _progress),
              Column(
                children: [
                  Text('${(_progress * 100).round()}%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Text(_progressRunning ? 'Memuat...' : 'Tap Mulai di atas',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),

        // 5. Pull-to-Refresh
        SectionHeader(
            title: l10n.gallerySectionPullToRefresh,
            subtitle: l10n.gallerySectionPullToRefreshDesc),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 280,
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _refreshItems.length,
                    itemBuilder: (_, i) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.primaries[i % Colors.primaries.length].withOpacity(0.2),
                        child: Icon(Icons.star,
                            color: Colors.primaries[i % Colors.primaries.length],
                            size: 18),
                      ),
                      title: Text(_refreshItems[i]),
                      subtitle: Text('Diperbarui baru saja'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// Shimmer container - manual ShaderMask implementation
class _ShimmerContainer extends StatelessWidget {
  const _ShimmerContainer({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final shimmerOffset = -1.5 + 3.0 * controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(shimmerOffset - 0.5, 0),
            end: Alignment(shimmerOffset + 0.5, 0),
            colors: const [
              Color(0xFFE0E0E0),
              Color(0xFFF8F8F8),
              Color(0xFFE0E0E0),
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: Column(
            children: List.generate(3, (_) => _shimmerCard()),
          ),
        );
      },
    );
  }

  Widget _shimmerCard() => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE0E0E0)),
    ),
    child: Row(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 14, color: Colors.white, margin: const EdgeInsets.only(right: 60)),
              const SizedBox(height: 6),
              Container(height: 10, color: Colors.white, margin: const EdgeInsets.only(right: 20)),
              const SizedBox(height: 4),
              Container(height: 10, color: Colors.white, width: 80),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SkeletonDemo extends StatelessWidget {
  const _SkeletonDemo({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final shimmerOffset = -1.5 + 3.0 * controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(shimmerOffset - 0.5, 0),
            end: Alignment(shimmerOffset + 0.5, 0),
            colors: const [Color(0xFFE0E0E0), Color(0xFFF8F8F8), Color(0xFFE0E0E0)],
          ).createShader(bounds),
          child: Row(
            children: [
              Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28))),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 16, color: Colors.white, margin: const EdgeInsets.only(right: 40)),
                    const SizedBox(height: 8),
                    Container(height: 12, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(height: 12, color: Colors.white, margin: const EdgeInsets.only(right: 80)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RealContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (i) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.primaries[i * 2].withOpacity(0.2),
              child: Icon(Icons.person, color: Colors.primaries[i * 2], size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ['Ahmad Rizki', 'Budi Santoso', 'Citra Dewi'][i],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ['Flutter Developer', 'Backend Engineer', 'UI/UX Designer'][i],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class _CircularProgress extends StatelessWidget {
  const _CircularProgress({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 80,
    height: 80,
    child: CircularProgressIndicator(
      value: value,
      strokeWidth: 7,
      backgroundColor: Colors.grey[200],
      color: AppColors.primary,
    ),
  );
}

// ── Empty State Tab ────────────────────────────────────────────────────────

class _EmptyTab extends StatefulWidget {
  const _EmptyTab();

  @override
  State<_EmptyTab> createState() => _EmptyTabState();
}

class _EmptyTabState extends State<_EmptyTab> {
  bool _retrying = false;
  bool _showNormal = false;

  Future<void> _retry() async {
    setState(() => _retrying = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() { _retrying = false; _showNormal = true; });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showNormal = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      children: [
        // 6. No Data
        SectionHeader(title: l10n.gallerySectionEmptyNoData, subtitle: l10n.gallerySectionEmptyNoDataDesc),
        _EmptyStateCard(
          icon: Icons.inbox_outlined,
          iconColor: Colors.blueGrey,
          title: 'Belum Ada Data',
          description: 'Kamu belum memiliki item apapun.\nTambahkan item baru untuk memulai.',
          actionLabel: 'Tambah Sekarang',
          onAction: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Navigasi ke form tambah data'))),
        ),

        // 7. No Internet
        SectionHeader(title: l10n.gallerySectionEmptyNoInternet, subtitle: l10n.gallerySectionEmptyNoInternetDesc),
        DemoCard(
          title: 'No Internet',
          child: _showNormal
              ? Column(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success, size: 60),
                    const SizedBox(height: 12),
                    const Text('Koneksi tersambung kembali!',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )
              : Column(
                  children: [
                    const Icon(Icons.wifi_off, size: 72, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text('Tidak Ada Koneksi',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text('Pastikan kamu terhubung ke internet\ndan coba lagi.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: _retrying
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.refresh, size: 18),
                      label: Text(_retrying ? 'Menghubungkan...' : 'Coba Lagi'),
                      onPressed: _retrying ? null : _retry,
                    ),
                  ],
                ),
        ),

        // 8. Error
        SectionHeader(title: l10n.gallerySectionEmptyError, subtitle: l10n.gallerySectionEmptyErrorDesc),
        _EmptyStateCard(
          icon: Icons.error_outline,
          iconColor: AppColors.error,
          title: 'Terjadi Kesalahan',
          description: 'Server merespons dengan kode 500:\nInternal Server Error. Silakan coba muat ulang.',
          actionLabel: 'Muat Ulang',
          onAction: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Simulasi reload...'))),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(icon, size: 72, color: iconColor),
              const SizedBox(height: 16),
              Text(title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
                onPressed: onAction,
                child: Text(actionLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
