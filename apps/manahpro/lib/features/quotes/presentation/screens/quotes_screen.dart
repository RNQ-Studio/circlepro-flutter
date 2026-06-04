import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
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
  List<QuoteEntity>? _shuffledQuotes;

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
        backgroundColor: ManahColors.nearWhite,
        body: Center(
          child: CircularProgressIndicator(color: ManahColors.brand),
        ),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: ManahColors.nearWhite,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 64, color: ManahColors.error),
                const SizedBox(height: 16),
                const Text(
                  'Gagal memuat kutipan.',
                  style: TextStyle(
                    color: ManahColors.nearBlack,
                    fontSize: 16,
                  ),
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
          _shuffledQuotes = null;
          return Scaffold(
            backgroundColor: ManahColors.nearWhite,
            body: Stack(
              children: [
                Center(
                  child: Text(
                    'Belum ada kutipan aktif.',
                    style: TextStyle(
                      color: ManahColors.mediumGrey,
                      fontSize: 16,
                    ),
                  ),
                ),
                _buildBackButton(context),
              ],
            ),
          );
        }

        // Initialize or update the shuffled quotes list.
        // We preserve the shuffled order but update the objects inside it to reflect their latest state (e.g. loved).
        if (_shuffledQuotes == null) {
          final tempQuotes = List<QuoteEntity>.from(activeQuotes)..shuffle();
          if (widget.initialId != null) {
            final initialIndex =
                tempQuotes.indexWhere((q) => q.id == widget.initialId);
            if (initialIndex != -1) {
              final initialQuote = tempQuotes.removeAt(initialIndex);
              tempQuotes.insert(0, initialQuote);
            }
          }
          _shuffledQuotes = tempQuotes;
        } else {
          // Remove quotes that are no longer active, and update existing ones with fresh data
          _shuffledQuotes = _shuffledQuotes!
              .where((shuffled) => activeQuotes.any((q) => q.id == shuffled.id))
              .map((shuffled) {
            return activeQuotes.firstWhere((q) => q.id == shuffled.id);
          }).toList();

          // If new active quotes were added while on the screen, append them at the end
          final newQuotes = activeQuotes
              .where((q) =>
                  !_shuffledQuotes!.any((shuffled) => shuffled.id == q.id))
              .toList();
          if (newQuotes.isNotEmpty) {
            newQuotes.shuffle();
            _shuffledQuotes!.addAll(newQuotes);
          }
        }

        if (_shuffledQuotes!.isEmpty) {
          return Scaffold(
            backgroundColor: ManahColors.nearWhite,
            body: Stack(
              children: [
                Center(
                  child: Text(
                    'Belum ada kutipan aktif.',
                    style: TextStyle(
                      color: ManahColors.mediumGrey,
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
          final N = _shuffledQuotes!.length;
          if (N > 1) {
            initialPage = (50000 ~/ N) * N;
          }
          _pageController = PageController(initialPage: initialPage);
        }

        return Scaffold(
          backgroundColor: ManahColors.nearWhite,
          body: Stack(
            children: [
              // Subtle brand watermark
              Positioned(
                top: -60,
                right: -40,
                child: Icon(
                  Icons.format_quote_rounded,
                  size: 260,
                  color: ManahColors.brand.withValues(alpha: 0.03),
                ),
              ),

              // PageView for swiping quotes (infinite scroll)
              PageView.builder(
                controller: _pageController,
                itemCount: _shuffledQuotes!.length > 1 ? 100000 : 1,
                itemBuilder: (context, index) {
                  final quote =
                      _shuffledQuotes![index % _shuffledQuotes!.length];
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

  Widget _buildBackButton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, top: 12),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: ManahColors.brand.withValues(alpha: 0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: ManahColors.nearBlack,
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
        width: size.width * 0.88,
        constraints: BoxConstraints(
          maxHeight: size.height * 0.65,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: ManahColors.brand.withValues(alpha: 0.08),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: ManahColors.brand.withValues(alpha: 0.03),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Subtle watermark
              Positioned(
                top: -10,
                left: -20,
                child: Icon(
                  Icons.format_quote_rounded,
                  size: 140,
                  color: ManahColors.brand.withValues(alpha: 0.03),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top accent — brand-colored quote icon
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ManahColors.brandSurface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: ManahColors.brand.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.format_quote_rounded,
                          color: ManahColors.brand,
                          size: 24,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Quote Body (Scrollable if long)
                    Flexible(
                      child: Center(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              quote.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: ManahColors.nearBlack,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                                height: 1.7,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Divider
                    Container(
                      width: 40,
                      height: 3,
                      decoration: BoxDecoration(
                        color: ManahColors.brand.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Author & Source
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          quote.author,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: ManahColors.nearBlack,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        if (quote.source != null &&
                            quote.source!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            quote.source!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ManahColors.mediumGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),

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
                            const SizedBox(width: 12),

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
      color: isLoved
          ? Colors.red.withValues(alpha: 0.06)
          : ManahColors.brandSurface,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: _handleLoveTap,
        splashColor: isLoved
            ? Colors.red.withValues(alpha: 0.08)
            : ManahColors.brand.withValues(alpha: 0.06),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  color: isLoved ? Colors.redAccent : ManahColors.brand,
                ),
              ),
              if (quote.loveCount > 0) ...[
                const SizedBox(width: 8),
                Text(
                  '${quote.loveCount}',
                  style: TextStyle(
                    color: isLoved ? Colors.redAccent : ManahColors.brand,
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
            backgroundColor: ManahColors.brand,
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
      color: ManahColors.brandSurface,
      shape: const CircleBorder(),
      child: IconButton(
        icon: const Icon(
          Icons.copy_rounded,
          color: ManahColors.brand,
          size: 18,
        ),
        onPressed: () => _copyToClipboard(context),
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.all(12),
        tooltip: 'Salin kutipan',
      ),
    );
  }
}
