import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../articles_providers.dart';
import '../../domain/article_entity.dart';

class ArticleReaderScreen extends ConsumerWidget {
  const ArticleReaderScreen({super.key, required this.articleId});

  final int articleId;

  Future<void> _shareArticle(BuildContext context, ArticleEntity article) async {
    final text = 'Baca artikel "${article.title}" di ManahPro!\n\n${article.excerpt ?? ''}\n\nDownload aplikasi ManahPro sekarang.';
    await Share.share(text, subject: article.title);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleAsync = ref.watch(articleDetailProvider(articleId));
    final theme = Theme.of(context);
    final dateStr = DateFormat('d MMMM yyyy', 'id');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Baca Artikel'),
        actions: [
          articleAsync.when(
            data: (article) => IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () => _shareArticle(context, article),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: articleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat artikel: $err')),
        data: (article) {
          final publishedDateStr = article.publishedAt != null
              ? dateStr.format(article.publishedAt!)
              : '';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Featured Image
                if (article.featuredImage != null && article.featuredImage!.isNotEmpty)
                  Image.network(
                    article.featuredImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, __) => _buildPlaceholderBanner(),
                  )
                else
                  _buildPlaceholderBanner(),

                Padding(
                  padding: const EdgeInsets.all(ManahSpacing.base),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category & Time
                      Row(
                        children: [
                          if (article.category != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: ManahColors.brandSurface,
                                borderRadius: BorderRadius.circular(ManahRadius.sm),
                              ),
                              child: Text(
                                article.category!.name.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: ManahColors.brand,
                                ),
                              ),
                            ),
                          const SizedBox(width: ManahSpacing.sm),
                          const Icon(Icons.access_time, size: 14, color: ManahColors.mediumGrey),
                          const SizedBox(width: 4),
                          Text(
                            '${article.readingTime} mnt baca',
                            style: const TextStyle(fontSize: 12, color: ManahColors.mediumGrey),
                          ),
                        ],
                      ),
                      const SizedBox(height: ManahSpacing.base),

                      // Title
                      Text(
                        article.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: ManahSpacing.base),

                      // Author & Date
                      Row(
                        children: [
                          const Icon(Icons.account_circle_outlined, size: 20, color: ManahColors.mediumGrey),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article.authorName ?? 'Admin',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: ManahColors.darkGrey,
                                  ),
                                ),
                                if (publishedDateStr.isNotEmpty)
                                  Text(
                                    publishedDateStr,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: ManahColors.mediumGrey,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: ManahSpacing.xl),

                      // Excerpt
                      if (article.excerpt != null && article.excerpt!.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(ManahSpacing.base),
                          decoration: BoxDecoration(
                            color: theme.dividerColor.withValues(alpha: 0.03),
                            border: Border(left: BorderSide(color: ManahColors.brand, width: 4)),
                          ),
                          child: Text(
                            article.excerpt!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                              color: ManahColors.darkGrey,
                            ),
                          ),
                        ),
                        const SizedBox(height: ManahSpacing.lg),
                      ],

                      if (article.isIslamic && article.hadithReference != null && article.hadithReference!.isNotEmpty) ...[
                        Container(
                          margin: const EdgeInsets.only(bottom: ManahSpacing.lg),
                          padding: const EdgeInsets.all(ManahSpacing.base),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                ManahColors.brandSurface,
                                Color(0xFFFFFBEB),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(ManahRadius.md),
                            border: Border.all(color: ManahColors.amber.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.nightlight_round, color: ManahColors.amber, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Dalil & Rujukan Sunnah',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: ManahColors.amberDeep,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: ManahSpacing.sm),
                              Text(
                                article.hadithReference!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  height: 1.4,
                                  color: ManahColors.darkGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Body Content
                      Text(
                        article.content,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: ManahColors.darkGrey,
                        ),
                      ),
                      const SizedBox(height: ManahSpacing.lg),

                      // Tags
                      if (article.tags.isNotEmpty) ...[
                        const Divider(),
                        const SizedBox(height: ManahSpacing.sm),
                        Wrap(
                          spacing: ManahSpacing.xs,
                          runSpacing: ManahSpacing.xs,
                          children: article.tags.map((tag) {
                            return Chip(
                              label: Text('#$tag', style: const TextStyle(fontSize: 11)),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholderBanner() {
    return Container(
      height: 160,
      width: double.infinity,
      color: ManahColors.brandSurface,
      child: const Center(
        child: Icon(Icons.article_outlined, size: 56, color: ManahColors.brand),
      ),
    );
  }
}
