import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../articles_providers.dart';
import '../../domain/article_entity.dart';

class ArticleListScreen extends ConsumerStatefulWidget {
  const ArticleListScreen({super.key});

  @override
  ConsumerState<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends ConsumerState<ArticleListScreen> {
  final _searchCtrl = TextEditingController();
  int? _selectedCategoryId;
  String _searchQuery = '';
  bool _filterIslamic = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(articleCategoriesProvider);
    final articlesAsync = ref.watch(articlesListProvider(
      categoryId: _selectedCategoryId,
      search: _searchQuery,
      isIslamic: _filterIslamic ? true : null,
    ));

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Search & Filter Panel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: ManahSpacing.base, vertical: ManahSpacing.sm),
            color: theme.cardColor,
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Cari artikel...',
                    prefixIcon: const Icon(Icons.search, color: ManahColors.mediumGrey),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onSubmitted: (val) {
                    setState(() => _searchQuery = val.trim());
                  },
                ),
                const SizedBox(height: ManahSpacing.sm),
                // Categories Tabs
                categoriesAsync.when(
                  loading: () => const SizedBox(height: 32, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                  error: (_, __) => const SizedBox(height: 32, child: Center(child: Text('Gagal memuat kategori', style: TextStyle(fontSize: 12)))),
                  data: (categories) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: ManahSpacing.xs),
                            child: ChoiceChip(
                              label: const Text('Semua', style: TextStyle(fontSize: 12)),
                              selected: _selectedCategoryId == null && !_filterIslamic,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedCategoryId = null;
                                    _filterIslamic = false;
                                  });
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: ManahSpacing.xs),
                            child: ChoiceChip(
                              label: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.nightlight_round_outlined, size: 14, color: ManahColors.amber),
                                  SizedBox(width: 4),
                                  Text('Sunnah Panahan', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              selected: _filterIslamic,
                              onSelected: (selected) {
                                setState(() {
                                  _filterIslamic = selected;
                                  if (selected) _selectedCategoryId = null;
                                });
                              },
                            ),
                          ),
                          ...categories.map((cat) {
                            return Padding(
                              padding: const EdgeInsets.only(right: ManahSpacing.xs),
                              child: ChoiceChip(
                                label: Text(cat.name, style: const TextStyle(fontSize: 12)),
                                selected: _selectedCategoryId == cat.id && !_filterIslamic,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategoryId = selected ? cat.id : null;
                                    _filterIslamic = false;
                                  });
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: ManahSpacing.sm),
          // Articles List
          Expanded(
            child: articlesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Gagal memuat artikel: $err')),
              data: (articles) {
                if (articles.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(ManahSpacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article_outlined, size: 64, color: theme.dividerColor),
                          const SizedBox(height: ManahSpacing.base),
                          Text(
                            'Belum ada artikel',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: ManahSpacing.xs),
                          const Text(
                            'Artikel tentang panahan akan muncul di sini.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: ManahColors.mediumGrey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(articlesListProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(ManahSpacing.base),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return _ArticleCard(article: article);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});

  final ArticleEntity article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = article.publishedAt != null
        ? DateFormat('d MMM yyyy', 'id').format(article.publishedAt!)
        : '';

    return GestureDetector(
      onTap: () => context.push('/articles/${article.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: ManahSpacing.base),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(ManahBorderRadius.card),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.featuredImage != null && article.featuredImage!.isNotEmpty)
              Image.network(
                article.featuredImage!,
                height: 160,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (article.category != null)
                            Text(
                              article.category!.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: ManahColors.brand,
                              ),
                            ),
                          if (article.category != null && article.isIslamic)
                            const SizedBox(width: 8),
                          if (article.isIslamic)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: ManahColors.amber.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.nightlight_round, size: 10, color: ManahColors.amber),
                                  const SizedBox(width: 2),
                                  Text(
                                    'SUNNAH',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: ManahColors.amberDeep,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      Text(
                        '${article.readingTime} mnt baca',
                        style: const TextStyle(fontSize: 11, color: ManahColors.mediumGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: ManahSpacing.xs),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  if (article.excerpt != null && article.excerpt!.isNotEmpty) ...[
                    const SizedBox(height: ManahSpacing.xs),
                    Text(
                      article.excerpt!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: ManahColors.darkGrey, height: 1.4),
                    ),
                  ],
                  const SizedBox(height: ManahSpacing.base),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 14, color: ManahColors.mediumGrey),
                      const SizedBox(width: 4),
                      Text(
                        article.authorName ?? 'Admin',
                        style: const TextStyle(fontSize: 11, color: ManahColors.mediumGrey),
                      ),
                      const Spacer(),
                      if (dateStr.isNotEmpty)
                        Text(
                          dateStr,
                          style: const TextStyle(fontSize: 11, color: ManahColors.mediumGrey),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderBanner() {
    return Container(
      height: 120,
      width: double.infinity,
      color: ManahColors.brandSurface,
      child: const Center(
        child: Icon(Icons.article_outlined, size: 48, color: ManahColors.brand),
      ),
    );
  }
}
