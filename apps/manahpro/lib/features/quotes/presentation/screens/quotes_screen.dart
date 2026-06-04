import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/quote_entity.dart';
import '../quotes_notifier.dart';

class QuotesScreen extends ConsumerStatefulWidget {
  const QuotesScreen({
    super.key,
    this.initialId,
  });

  final int? initialId;

  @override
  ConsumerState<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends ConsumerState<QuotesScreen> {
  PageController? _pageController;

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quotesAsync = ref.watch(quotesProvider);

    return quotesAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white70),
        ),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 64, color: Colors.redAccent),
                const SizedBox(height: 16),
                const Text(
                  'Gagal memuat kutipan.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () =>
                      ref.read(quotesProvider.notifier).refreshQuotes(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (quotes) {
        final activeQuotes = quotes.where((q) => q.isActive).toList();

        if (activeQuotes.isEmpty) {
          return Scaffold(
            backgroundColor: const Color(0xFF0F172A),
            body: Stack(
              children: [
                _buildAmbientBackground(),
                Center(
                  child: Text(
                    'Belum ada kutipan aktif.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
                _buildBackButton(context),
              ],
            ),
          );
        }

        // Initialize PageController with infinite scroll support
        if (_pageController == null) {
          int initialPage = 0;
          final N = activeQuotes.length;
          if (widget.initialId != null) {
            final index =
                activeQuotes.indexWhere((q) => q.id == widget.initialId);
            if (index != -1) {
              if (N > 1) {
                final middlePage = (50000 ~/ N) * N;
                initialPage = middlePage + index;
              } else {
                initialPage = index;
              }
            }
          } else {
            if (N > 1) {
              initialPage = (50000 ~/ N) * N;
            }
          }
          _pageController = PageController(initialPage: initialPage);
        }

        return Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          body: Stack(
            children: [
              // Ambient glow background
              _buildAmbientBackground(),

              // PageView for swiping quotes (infinite scroll)
              PageView.builder(
                controller: _pageController,
                itemCount: activeQuotes.length > 1 ? 100000 : 1,
                itemBuilder: (context, index) {
                  final quote = activeQuotes[index % activeQuotes.length];
                  return _buildQuoteCard(context, quote);
                },
              ),

              // Back button at top-left
              _buildBackButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmbientBackground() {
    return Stack(
      children: [
        // Solid deep dark base
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F172A), // Slate 900
                Color(0xFF020617), // Slate 950
              ],
            ),
          ),
        ),

        // Glowing Amber Orb at top-right
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber.withValues(alpha: 0.12),
            ),
          ),
        ),

        // Glowing Indigo Orb at bottom-left
        Positioned(
          bottom: -100,
          left: -100,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.indigo.withValues(alpha: 0.12),
            ),
          ),
        ),

        // Blur effect to soften orbs into high-end ambient light
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, top: 12),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => context.pop(),
              tooltip: 'Kembali',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteCard(BuildContext context, QuoteEntity quote) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.65,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Stack(
              children: [
                // Elegant Watermark Quotes Icon
                Positioned(
                  top: -10,
                  left: -20,
                  child: Icon(
                    Icons.format_quote_rounded,
                    size: 140,
                    color: Colors.white.withValues(alpha: 0.015),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Quote Symbol
                      Align(
                        alignment: Alignment.topLeft,
                        child: Icon(
                          Icons.format_quote_rounded,
                          color: Colors.amber.shade600.withValues(alpha: 0.7),
                          size: 40,
                        ),
                      ),

                      // Quote Body (Scrollable if long)
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                quote.text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                  height: 1.6,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Author & Source
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '— ${quote.author}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (quote.source != null &&
                              quote.source!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              quote.source!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 13,
                              ),
                            ),
                          ],
                          const SizedBox(height: 32),

                          // Interaction Buttons (Love & Copy)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Love Button
                              _FullscreenLoveButton(
                                quote: quote,
                                onToggleLove: () {
                                  if (quote.id != null) {
                                    ref
                                        .read(quotesProvider.notifier)
                                        .toggleLove(quote.id!, quote.isLoved);
                                  }
                                },
                              ),
                              const SizedBox(width: 20),

                              // Copy Button
                              _FullscreenCopyButton(quote: quote),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FullscreenLoveButton extends StatefulWidget {
  const _FullscreenLoveButton({
    required this.quote,
    required this.onToggleLove,
  });

  final QuoteEntity quote;
  final VoidCallback onToggleLove;

  @override
  State<_FullscreenLoveButton> createState() => _FullscreenLoveButtonState();
}

class _FullscreenLoveButtonState extends State<_FullscreenLoveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _loveAnimController;
  late Animation<double> _loveScaleAnimation;

  @override
  void initState() {
    super.initState();
    _loveAnimController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _loveScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _loveAnimController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _loveAnimController.dispose();
    super.dispose();
  }

  void _handleLoveTap() {
    _loveAnimController.forward(from: 0);
    widget.onToggleLove();
  }

  @override
  Widget build(BuildContext context) {
    final quote = widget.quote;
    final isLoved = quote.isLoved;

    return Material(
      color: Colors.white.withValues(alpha: 0.05),
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: _handleLoveTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _loveScaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _loveScaleAnimation.value,
                    child: child,
                  );
                },
                child: Icon(
                  isLoved
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 20,
                  color: isLoved ? Colors.redAccent : Colors.white70,
                ),
              ),
              if (quote.loveCount > 0) ...[
                const SizedBox(width: 8),
                Text(
                  '${quote.loveCount}',
                  style: TextStyle(
                    color: isLoved ? Colors.redAccent : Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FullscreenCopyButton extends StatelessWidget {
  const _FullscreenCopyButton({
    required this.quote,
  });

  final QuoteEntity quote;

  void _copyToClipboard(BuildContext context) {
    final textToCopy =
        '"${quote.text}"\n\n— ${quote.author}${quote.source != null && quote.source!.isNotEmpty ? " (${quote.source})" : ""}';
    Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: Colors.white, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Kutipan berhasil disalin ke papan klip!',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.indigoAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(24),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.05),
      shape: const CircleBorder(),
      child: IconButton(
        icon: const Icon(
          Icons.copy_rounded,
          color: Colors.white70,
          size: 20,
        ),
        onPressed: () => _copyToClipboard(context),
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
