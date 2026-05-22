import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../widgets/section_header.dart';
import '../widgets/demo_card.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.galleryFeedbackScreenTitle)),
      body: ListView(
        children: [
          SectionHeader(title: l10n.gallerySectionStarRating, subtitle: l10n.gallerySectionStarRatingDesc),
          const _StarRating(),
          SectionHeader(title: l10n.gallerySectionLikeButton, subtitle: l10n.gallerySectionLikeButtonDesc),
          const _LikeButton(),
          SectionHeader(title: l10n.gallerySectionReactionPicker, subtitle: l10n.gallerySectionReactionPickerDesc),
          const _ReactionPicker(),
          SectionHeader(title: l10n.gallerySectionCommentInput, subtitle: l10n.gallerySectionCommentInputDesc),
          const _CommentSection(),
          SectionHeader(title: l10n.gallerySectionQuickPoll, subtitle: l10n.gallerySectionQuickPollDesc),
          const _QuickPoll(),
          SectionHeader(title: l10n.gallerySectionOtpInput, subtitle: l10n.gallerySectionOtpInputDesc),
          const _OtpInput(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── 1. Star Rating ─────────────────────────────────────────────────────────

class _StarRating extends StatefulWidget {
  const _StarRating();

  @override
  State<_StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<_StarRating> {
  double _rating = 3;
  double _hoverRating = 0;

  @override
  Widget build(BuildContext context) {
    final display = _hoverRating > 0 ? _hoverRating : _rating;

    return DemoCard(
      title: 'Star Rating',
      subtitle: 'Tap bintang untuk memberi nilai',
      child: Column(
        children: [
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final pos = box.globalToLocal(details.globalPosition);
              final starWidth = (box.size.width - 80) / 5;
              final newRating = ((pos.dx - 40) / starWidth).clamp(0.5, 5.0);
              setState(() => _rating = (newRating * 2).round() / 2);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final starValue = i + 1;
                IconData icon;
                if (display >= starValue) {
                  icon = Icons.star_rounded;
                } else if (display >= starValue - 0.5) {
                  icon = Icons.star_half_rounded;
                } else {
                  icon = Icons.star_outline_rounded;
                }
                return GestureDetector(
                  onTap: () => setState(() => _rating = starValue.toDouble()),
                  child: AnimatedScale(
                    scale: display >= starValue - 0.4 ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(icon,
                        color: Colors.amber, size: 40),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${_rating.toStringAsFixed(1)} / 5.0',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold, color: Colors.amber),
          ),
          Text(_ratingLabel(_rating),
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  String _ratingLabel(double r) {
    if (r >= 5) return 'Sempurna!';
    if (r >= 4) return 'Sangat Bagus';
    if (r >= 3) return 'Cukup Baik';
    if (r >= 2) return 'Kurang Memuaskan';
    return 'Sangat Buruk';
  }
}

// ── 2. Like Button ─────────────────────────────────────────────────────────

class _LikeButton extends StatefulWidget {
  const _LikeButton();

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton>
    with SingleTickerProviderStateMixin {
  bool _liked = false;
  int _count = 42;
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _liked = !_liked;
      _count += _liked ? 1 : -1;
    });
    _ctrl.forward().then((_) => _ctrl.reset());
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Like / Unlike',
      subtitle: 'Tap ikon hati untuk like/unlike',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _scale,
            builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
            child: IconButton(
              iconSize: 40,
              icon: Icon(
                _liked ? Icons.favorite : Icons.favorite_border,
                color: _liked ? Colors.red : Colors.grey,
              ),
              onPressed: _toggle,
            ),
          ),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(anim),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: Text(
              '$_count',
              key: ValueKey(_count),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _liked ? Colors.red : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 3. Reaction Picker ─────────────────────────────────────────────────────

class _ReactionPicker extends StatefulWidget {
  const _ReactionPicker();

  @override
  State<_ReactionPicker> createState() => _ReactionPickerState();
}

class _ReactionPickerState extends State<_ReactionPicker>
    with TickerProviderStateMixin {
  static const _emojis = ['👍', '❤️', '😂', '😮', '😢', '😡'];
  String _current = '👍 Suka';
  bool _showPicker = false;
  late final List<AnimationController> _emojiCtrlrs;

  @override
  void initState() {
    super.initState();
    _emojiCtrlrs = List.generate(
      _emojis.length,
      (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 300)),
    );
  }

  @override
  void dispose() {
    for (final c in _emojiCtrlrs) c.dispose();
    super.dispose();
  }

  void _showReactions() async {
    setState(() => _showPicker = true);
    for (var i = 0; i < _emojiCtrlrs.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 50));
      if (mounted) _emojiCtrlrs[i].forward();
    }
  }

  void _hideReactions() {
    for (final c in _emojiCtrlrs) c.reverse();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showPicker = false);
    });
  }

  void _selectEmoji(String emoji) {
    setState(() => _current = '$emoji Suka');
    _hideReactions();
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Reaction Picker',
      subtitle: 'Long press tombol untuk pilih reaction',
      child: Column(
        children: [
          if (_showPicker) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_emojis.length, (i) {
                  final anim = CurvedAnimation(
                    parent: _emojiCtrlrs[i],
                    curve: Curves.elasticOut,
                  );
                  return AnimatedBuilder(
                    animation: anim,
                    builder: (_, child) => ScaleTransition(scale: anim, child: child),
                    child: GestureDetector(
                      onTap: () => _selectEmoji(_emojis[i]),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(_emojis[i], style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
          GestureDetector(
            onLongPress: _showPicker ? _hideReactions : _showReactions,
            onTap: _showPicker ? _hideReactions : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(24),
                color: AppColors.primary.withOpacity(0.08),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_current.split(' ')[0], style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(_current.contains(' ') ? _current.split(' ').last : '',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('Long press untuk pilih reaction',
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}

// ── 4. Comment Section ─────────────────────────────────────────────────────

class _CommentSection extends StatefulWidget {
  const _CommentSection();

  @override
  State<_CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<_CommentSection> {
  final _ctrl = TextEditingController();
  final List<String> _comments = [
    'Kode ini sangat membantu! Terima kasih.',
    'Penjelasannya sangat jelas dan mudah dipahami.',
    'Saya sudah mencoba dan berhasil. Top banget!',
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _send() {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() {
      _comments.add(_ctrl.text.trim());
      _ctrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Comment Section',
      subtitle: 'Ketik komentar dan tap kirim',
      child: Column(
        children: [
          ...(_comments.map((c) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child: Text(c[0].toUpperCase(),
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(c, style: Theme.of(context).textTheme.bodySmall),
                  ),
                ),
              ],
            ),
          ))),
          const SizedBox(height: 8),
          ValueListenableBuilder(
            valueListenable: _ctrl,
            builder: (_, value, __) => Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: const InputDecoration(
                      hintText: 'Tulis komentar...',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: value.text.trim().isNotEmpty ? AppColors.primary : Colors.grey,
                  onPressed: value.text.trim().isNotEmpty ? _send : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 5. Quick Poll ──────────────────────────────────────────────────────────

class _QuickPoll extends StatefulWidget {
  const _QuickPoll();

  @override
  State<_QuickPoll> createState() => _QuickPollState();
}

class _QuickPollState extends State<_QuickPoll> {
  static const _options = ['State Management', 'Navigation / Routing', 'Animasi Kompleks', 'Integrasi API'];
  static const _baseVotes = [45, 30, 15, 10];
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final totalVotes = _selected != null
        ? _baseVotes.reduce((a, b) => a + b) + 1
        : _baseVotes.reduce((a, b) => a + b);
    final votes = List.generate(_options.length, (i) => _baseVotes[i] + (_selected == i ? 1 : 0));

    return DemoCard(
      title: 'Quick Poll',
      subtitle: 'Fitur mana yang paling kamu butuhkan?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selected != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Icon(Icons.how_to_vote, size: 16, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text('$totalVotes total suara',
                      style: const TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ...List.generate(_options.length, (i) {
            final pct = votes[i] / totalVotes;
            final isSelected = _selected == i;
            return GestureDetector(
              onTap: _selected == null ? () => setState(() => _selected = i) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Theme.of(context).colorScheme.outlineVariant,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: isSelected ? AppColors.primary.withOpacity(0.06) : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(_options[i],
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 13,
                              )),
                        ),
                        if (_selected != null)
                          Text('${(pct * 100).round()}%',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppColors.primary : Colors.grey,
                              )),
                        if (_selected != null && isSelected) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.check_circle, color: AppColors.primary, size: 16),
                        ],
                      ],
                    ),
                    if (_selected != null) ...[
                      const SizedBox(height: 6),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: pct),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        builder: (_, value, __) => LinearProgressIndicator(
                          value: value,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                          backgroundColor: Colors.grey[200],
                          color: isSelected ? AppColors.primary : Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── 6. OTP / PIN Input ─────────────────────────────────────────────────────

class _OtpInput extends StatefulWidget {
  const _OtpInput();

  @override
  State<_OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<_OtpInput>
    with SingleTickerProviderStateMixin {
  static const _length = 6;
  final List<TextEditingController> _ctrlrs =
      List.generate(_length, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(_length, (_) => FocusNode());

  late final AnimationController _shakeCtrl;
  late final Animation<double> _shake;
  bool _verified = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shake = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.linear));
  }

  @override
  void dispose() {
    for (final c in _ctrlrs) c.dispose();
    for (final n in _nodes) n.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    } else if (value.isNotEmpty && index < _length - 1) {
      _nodes[index + 1].requestFocus();
    }
    // Check complete
    final pin = _ctrlrs.map((c) => c.text).join();
    if (pin.length == _length) _verify(pin);
  }

  void _verify(String pin) {
    if (pin == '123456') {
      setState(() { _verified = true; _failed = false; });
    } else {
      setState(() { _failed = true; _verified = false; });
      _shakeCtrl.forward().then((_) => _shakeCtrl.reset());
      Future.delayed(const Duration(milliseconds: 500), _clearPin);
    }
  }

  void _clearPin() {
    for (final c in _ctrlrs) c.clear();
    if (mounted) {
      _nodes[0].requestFocus();
      setState(() => _failed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'OTP / PIN Input',
      subtitle: 'PIN benar: 123456',
      child: Column(
        children: [
          if (_verified)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success),
                  const SizedBox(width: 6),
                  const Text('PIN benar! Akses diberikan.',
                      style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          LayoutBuilder(
            builder: (context, constraints) {
              final boxWidth = ((constraints.maxWidth - 80) / _length).clamp(36.0, 48.0);
              return AnimatedBuilder(
                animation: _shake,
                builder: (_, child) =>
                    Transform.translate(offset: Offset(_shake.value, 0), child: child),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_length, (i) => Container(
                    width: boxWidth,
                    height: 52,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: _ctrlrs[i],
                      focusNode: _nodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: '',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: _failed
                                ? AppColors.error
                                : (_verified ? AppColors.success : AppColors.grey200),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: _failed
                                ? AppColors.error
                                : (_verified ? AppColors.success : AppColors.primary),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: _verified
                            ? AppColors.success.withOpacity(0.05)
                            : _failed
                                ? AppColors.error.withOpacity(0.05)
                                : null,
                      ),
                      onChanged: (v) => _onChanged(i, v),
                    ),
                  )),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          if (_verified)
            ElevatedButton(
              onPressed: () {
                setState(() => _verified = false);
                _clearPin();
              },
              child: const Text('Reset'),
            )
          else
            Text(
              _failed ? 'PIN salah, coba lagi' : 'Masukkan 6 digit PIN',
              style: TextStyle(
                fontSize: 12,
                color: _failed ? AppColors.error : Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
