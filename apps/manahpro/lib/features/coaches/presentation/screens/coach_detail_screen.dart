import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../coaches_providers.dart';
import '../../domain/coach_profile_entity.dart';

class CoachDetailScreen extends ConsumerStatefulWidget {
  const CoachDetailScreen({super.key, required this.coachId});

  final String coachId;

  @override
  ConsumerState<CoachDetailScreen> createState() => _CoachDetailScreenState();
}

class _CoachDetailScreenState extends ConsumerState<CoachDetailScreen> {
  final _dateFormat = DateFormat('d MMMM yyyy', 'id');

  void _showAddReviewDialog(CoachProfileEntity coach) {
    showDialog<void>(
      context: context,
      builder: (context) => _AddReviewDialog(
        coachId: coach.id,
        onSuccess: () {
          ref.invalidate(coachDetailProvider(widget.coachId));
          ref.invalidate(coachReviewsProvider(widget.coachId));
        },
      ),
    );
  }

  Future<void> _contactCoach(CoachProfileEntity coach) async {
    final name = coach.user.displayName;
    final phone = coach.whatsappNumber ?? '';
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor WhatsApp pelatih tidak tersedia')),
      );
      return;
    }

    // Format phone: remove non-digits, ensure starts with country code or convert 08 to 62
    var formattedPhone = phone.replaceAll(RegExp(r'\D'), '');
    if (formattedPhone.startsWith('0')) {
      formattedPhone = '62${formattedPhone.substring(1)}';
    }

    final message = Uri.encodeComponent(
      'Halo Coach $name, saya tertarik untuk berlatih panahan dengan Anda melalui ManahPro. Apakah Anda memiliki slot waktu luang?',
    );
    final url = 'https://wa.me/$formattedPhone?text=$message';

    try {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghubungi pelatih: $e')),
        );
      }
    }
  }

  String _formatSpecialtyName(String spec) {
    return spec.replaceAll('_', ' ').toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final coachAsync = ref.watch(coachDetailProvider(widget.coachId));
    final reviewsAsync = ref.watch(coachReviewsProvider(widget.coachId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pelatih'),
      ),
      body: coachAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat detail pelatih: $err')),
        data: (coach) {
          final user = coach.user;

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(coachDetailProvider(widget.coachId));
                    ref.invalidate(coachReviewsProvider(widget.coachId));
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(ManahSpacing.base),
                    children: [
                      // Header Card (Profile info)
                      Container(
                        padding: const EdgeInsets.all(ManahSpacing.base),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(ManahBorderRadius.card),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: ManahColors.brandSurface,
                              backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                                  ? NetworkImage(user.avatarUrl!)
                                  : null,
                              child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                                  ? Text(
                                      user.displayName.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: ManahColors.brand,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: ManahSpacing.base),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          user.displayName,
                                          style: theme.textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (coach.isVerified) ...[
                                        const SizedBox(width: ManahSpacing.xs),
                                        const Icon(Icons.verified, color: ManahColors.brand, size: 20),
                                      ],
                                    ],
                                  ),
                                  if (user.username != null) ...[
                                    Text(
                                      '@${user.username}',
                                      style: const TextStyle(color: ManahColors.mediumGrey, fontSize: 13),
                                    ),
                                    const SizedBox(height: ManahSpacing.xs),
                                  ],
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 16, color: ManahColors.mediumGrey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          user.location.isNotEmpty ? user.location : 'Luar Kota',
                                          style: const TextStyle(color: ManahColors.mediumGrey, fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: ManahSpacing.base),

                      // Bio Section
                      _SectionCard(
                        title: 'Tentang Pelatih',
                        child: Text(
                          coach.bio,
                          style: const TextStyle(fontSize: 14, height: 1.5, color: ManahColors.darkGrey),
                        ),
                      ),
                      const SizedBox(height: ManahSpacing.base),

                      // Specs & Certifications Section
                      _SectionCard(
                        title: 'Spesialisasi & Sertifikasi',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Spesialisasi Busur:',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ManahColors.darkGrey),
                            ),
                            const SizedBox(height: ManahSpacing.xs),
                            Wrap(
                              spacing: ManahSpacing.xs,
                              runSpacing: ManahSpacing.xs,
                              children: coach.specialties.map((spec) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: ManahColors.brandSurface,
                                    borderRadius: BorderRadius.circular(ManahRadius.sm),
                                  ),
                                  child: Text(
                                    _formatSpecialtyName(spec),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: ManahColors.brand,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            if (coach.certification != null && coach.certification!.isNotEmpty) ...[
                              const SizedBox(height: ManahSpacing.base),
                              const Text(
                                'Sertifikasi / Kredensial:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ManahColors.darkGrey),
                              ),
                              const SizedBox(height: ManahSpacing.xs),
                              Row(
                                children: [
                                  const Icon(Icons.workspace_premium, color: Colors.amber, size: 20),
                                  const SizedBox(width: ManahSpacing.xs),
                                  Expanded(
                                    child: Text(
                                      coach.certification!,
                                      style: const TextStyle(fontSize: 13, color: ManahColors.darkGrey),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: ManahSpacing.base),

                      // Info Panel (Exp, availability, hourly rate)
                      Container(
                        padding: const EdgeInsets.all(ManahSpacing.base),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(ManahBorderRadius.card),
                        ),
                        child: Column(
                          children: [
                            _InfoRow(
                              icon: Icons.calendar_today,
                              label: 'Ketersediaan',
                              value: coach.availability != null && coach.availability!.isNotEmpty
                                  ? coach.availability!.join(', ')
                                  : 'Tanyakan Jadwal',
                            ),
                            const Divider(height: ManahSpacing.base),
                            _InfoRow(
                              icon: Icons.history,
                              label: 'Pengalaman',
                              value: '${coach.experienceYears} Tahun Berlatih',
                            ),
                            const Divider(height: ManahSpacing.base),
                            _InfoRow(
                              icon: Icons.payments_outlined,
                              label: 'Tarif Per Jam',
                              value: 'Rp ${NumberFormat.decimalPattern('id').format(coach.hourlyRate)}',
                              valueColor: ManahColors.brand,
                              valueWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: ManahSpacing.base),

                      // Reviews Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ulasan & Rating (${coach.reviewsCount})',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () => _showAddReviewDialog(coach),
                            child: const Text('Beri Ulasan'),
                          ),
                        ],
                      ),
                      const SizedBox(height: ManahSpacing.xs),

                      // Reviews List
                      reviewsAsync.when(
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(ManahSpacing.base),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (err, _) => Center(child: Text('Gagal memuat ulasan: $err')),
                        data: (reviews) {
                          if (reviews.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(ManahSpacing.xl),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(ManahBorderRadius.card),
                              ),
                              child: const Center(
                                child: Text(
                                  'Belum ada ulasan dari atlet.',
                                  style: TextStyle(color: ManahColors.mediumGrey),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: reviews.map((review) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: ManahSpacing.sm),
                                padding: const EdgeInsets.all(ManahSpacing.base),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(ManahBorderRadius.card),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: ManahColors.brandSurface,
                                          backgroundImage: review.user.avatarUrl != null &&
                                                  review.user.avatarUrl!.isNotEmpty
                                              ? NetworkImage(review.user.avatarUrl!)
                                              : null,
                                          child: review.user.avatarUrl == null ||
                                                  review.user.avatarUrl!.isEmpty
                                              ? Text(
                                                  review.user.displayName.substring(0, 1).toUpperCase(),
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: ManahColors.brand,
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: ManahSpacing.xs),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                review.user.displayName,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (review.createdAt != null)
                                                Text(
                                                  _dateFormat.format(review.createdAt!),
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: ManahColors.mediumGrey,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        // Stars
                                        Row(
                                          children: List.generate(5, (starIdx) {
                                            return Icon(
                                              Icons.star,
                                              size: 14,
                                              color: starIdx < review.rating
                                                  ? Colors.amber
                                                  : theme.dividerColor,
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                    if (review.comment != null && review.comment!.isNotEmpty) ...[
                                      const SizedBox(height: ManahSpacing.xs),
                                      Text(
                                        review.comment!,
                                        style: const TextStyle(fontSize: 13, color: ManahColors.darkGrey),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom CTA (Contact Button)
              Container(
                padding: const EdgeInsets.all(ManahSpacing.base),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  border: Border(top: BorderSide(color: theme.dividerColor)),
                ),
                child: SafeArea(
                  top: false,
                  child: FilledButton.icon(
                    onPressed: () => _contactCoach(coach),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Hubungi Pelatih (WhatsApp)'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(ManahSpacing.base),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(ManahBorderRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: ManahSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = ManahColors.darkGrey,
    this.valueWeight = FontWeight.normal,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final FontWeight valueWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: ManahColors.mediumGrey),
        const SizedBox(width: ManahSpacing.sm),
        Text(label, style: const TextStyle(color: ManahColors.mediumGrey, fontSize: 13)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: valueWeight,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _AddReviewDialog extends ConsumerStatefulWidget {
  const _AddReviewDialog({required this.coachId, required this.onSuccess});

  final String coachId;
  final VoidCallback onSuccess;

  @override
  ConsumerState<_AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends ConsumerState<_AddReviewDialog> {
  int _rating = 5;
  final _commentCtrl = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    try {
      await ref.read(coachesRepositoryProvider).addReview(
            widget.coachId,
            _rating,
            _commentCtrl.text.trim().isEmpty ? null : _commentCtrl.text.trim(),
          );
      widget.onSuccess();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memberikan ulasan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Beri Ulasan Pelatih'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Berikan penilaian Anda untuk pelatih ini:',
              style: TextStyle(fontSize: 13, color: ManahColors.darkGrey),
            ),
            const SizedBox(height: ManahSpacing.sm),
            // Star Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIdx = index + 1;
                return IconButton(
                  onPressed: () => setState(() => _rating = starIdx),
                  icon: Icon(
                    Icons.star,
                    size: 32,
                    color: starIdx <= _rating ? Colors.amber : Theme.of(context).dividerColor,
                  ),
                );
              }),
            ),
            const SizedBox(height: ManahSpacing.sm),
            TextField(
              controller: _commentCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Tulis komentar/ulasan Anda mengenai pelatih ini (opsional)...',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: _busy ? null : _submit,
          child: _busy
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Kirim'),
        ),
      ],
    );
  }
}
