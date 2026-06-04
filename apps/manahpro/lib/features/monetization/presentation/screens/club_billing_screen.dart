import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/manah_colors.dart';
import '../monetization_providers.dart';

class ClubBillingScreen extends ConsumerStatefulWidget {
  const ClubBillingScreen({
    super.key,
    required this.clubId,
    required this.clubName,
  });

  final String clubId;
  final String clubName;

  @override
  ConsumerState<ClubBillingScreen> createState() => _ClubBillingScreenState();
}

class _ClubBillingScreenState extends ConsumerState<ClubBillingScreen> {
  String _selectedPlanCode = 'club_starter';

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(monetizationPlansProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? ManahColors.darkBg : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : ManahColors.nearBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Langganan Klub',
          style: TextStyle(
            color: isDark ? Colors.white : ManahColors.nearBlack,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: plansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat paket: $err')),
        data: (plans) {
          final clubPlans = plans.where((p) => p.audience == 'organization').toList();

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.clubName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: ManahColors.brand,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tingkatkan skala operasional dan kapasitas anggota klub Anda dengan beralih ke paket SaaS premium.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : ManahColors.mediumGrey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Plans list
                ...clubPlans.map((plan) {
                  final isSelected = _selectedPlanCode == plan.code;
                  final maxMembers = plan.limits['max_members'] ?? 0;
                  final maxMembersText = maxMembers == -1 ? 'Tanpa Batas' : '$maxMembers Anggota';

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPlanCode = plan.code;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? ManahColors.brand.withOpacity(0.2) : ManahColors.brandSurface)
                            : (isDark ? ManahColors.darkSurface : Colors.white),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? ManahColors.brand : (isDark ? Colors.white10 : Colors.black12),
                          width: isSelected ? 2.2 : 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isDark ? Colors.white : ManahColors.nearBlack,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  maxMembersText,
                                  style: const TextStyle(
                                    color: ManahColors.amberDeep,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...plan.features.map((f) => Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.check, color: ManahColors.success, size: 14),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              f,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: isDark ? Colors.white60 : ManahColors.mediumGrey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rp ${plan.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: ManahColors.brand,
                                ),
                              ),
                              Text(
                                '/ bulan',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark ? Colors.white60 : ManahColors.mediumGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: 32),

                // Upgrade Action Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ManahColors.brand,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => _handleClubUpgrade(context),
                  child: const Text(
                    'Daftar & Tingkatkan Klub',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleClubUpgrade(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Memproses pembayaran langganan klub...')),
      );

      final repo = ref.read(monetizationRepositoryProvider);
      await repo.purchaseClubSubscription(widget.clubId, _selectedPlanCode);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Langganan klub berhasil ditingkatkan!'),
            backgroundColor: ManahColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal meningkatkan langganan klub: $e'),
            backgroundColor: ManahColors.error,
          ),
        );
      }
    }
  }
}
