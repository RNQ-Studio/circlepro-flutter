import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/manah_colors.dart';
import '../../domain/monetization_entities.dart';
import '../monetization_providers.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  String _selectedPlanCode = 'pro'; // default selected plan code

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(monetizationPlansProvider);
    final subscriptionAsync = ref.watch(userSubscriptionProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? ManahColors.darkBg : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: isDark ? Colors.white : ManahColors.nearBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'ManahPro Premium',
          style: TextStyle(
            color: isDark ? Colors.white : ManahColors.nearBlack,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: plansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat paket: $err')),
        data: (plans) {
          final userPlans = plans.where((p) => p.audience == 'user' && p.code != 'free').toList();

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Promo
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ManahColors.amberSurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: ManahColors.amber, width: 2),
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: ManahColors.amberDeep,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Buka Potensi Panahan Terbaikmu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : ManahColors.nearBlack,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tingkatkan ke Pro atau Elite untuk mencatat scoring latihan tanpa batas dan mendapatkan statistik analisis tingkat tinggi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : ManahColors.mediumGrey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Active Subscription Status Banner
                subscriptionAsync.when(
                  data: (subStatus) {
                    if (subStatus.subscription != null && subStatus.subscription!.isActive) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: ManahColors.brandSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: ManahColors.brandLight, width: 1.2),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: ManahColors.brand, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Paket Aktif: ${subStatus.subscription!.plan.name}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ManahColors.brand,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Berlaku hingga: ${subStatus.subscription!.currentPeriodEnd?.toLocal().toString().substring(0, 10) ?? '-'}',
                                    style: const TextStyle(
                                      color: ManahColors.brand,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                // Pricing Cards
                Row(
                  children: userPlans.map((plan) {
                    final isSelected = _selectedPlanCode == plan.code;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPlanCode = plan.code;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.all(16),
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
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (plan.code == 'elite')
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: ManahColors.amberDeep,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'REKOMENDASI',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              Text(
                                plan.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: isDark ? Colors.white : ManahColors.nearBlack,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Rp ${plan.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: ManahColors.brand,
                                ),
                              ),
                              Text(
                                '/ bulan',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? Colors.white60 : ManahColors.mediumGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Selected Plan Features
                _buildFeaturesList(userPlans.firstWhere((p) => p.code == _selectedPlanCode, orElse: () => userPlans.first)),

                const SizedBox(height: 32),

                // Subscribe Button (Google Play)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ManahColors.brand,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () => _simulateGooglePlayPurchase(context, _selectedPlanCode),
                  child: const Text(
                    'Langganan dengan Google Play',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),

                const SizedBox(height: 12),

                // Subscribe via Bank Transfer
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ManahColors.brand,
                    side: const BorderSide(color: ManahColors.brand, width: 1.5),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => _showManualTransferSheet(context, _selectedPlanCode),
                  child: const Text(
                    'Metode Transfer Bank Manual',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),

                const SizedBox(height: 24),
                Text(
                  'Langganan diperbarui secara otomatis per bulan. Anda dapat membatalkan kapan saja melalui Google Play Store. Tunduk pada Syarat & Ketentuan kami.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.white30 : ManahColors.mediumGrey.withOpacity(0.7),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturesList(SubscriptionPlanEntity plan) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? ManahColors.darkSurface : ManahColors.lightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FITUR ${plan.name.toUpperCase()}',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: ManahColors.amberDeep, letterSpacing: 0.5),
          ),
          const SizedBox(height: 12),
          ...plan.features.map((feature) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, color: ManahColors.success, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : ManahColors.nearBlack,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _simulateGooglePlayPurchase(BuildContext context, String planCode) {
    showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Simulasi Google Play Billing'),
        content: const Text(
            'Layanan ini terintegrasi dengan Google Play Store Billing API. Pilih status transaksi untuk simulasi pembelian di sandbox:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 0),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 1),
            child: const Text('Sukses', style: TextStyle(color: ManahColors.success, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ).then((result) async {
      if (result == 1) {
        // Success simulation
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Memproses pembelian dengan Google Play...')),
          );

          await ref.read(userSubscriptionProvider.notifier).upgradeWithGooglePlay(
                planCode,
                'token-mock-${DateTime.now().millisecondsSinceEpoch}',
              );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Akun Anda berhasil ditingkatkan ke Premium!'),
                backgroundColor: ManahColors.success,
              ),
            );
            Navigator.of(context).pop();
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal validasi pembelian: $e'),
                backgroundColor: ManahColors.error,
              ),
            );
          }
        }
      }
    });
  }

  void _showManualTransferSheet(BuildContext context, String planCode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.8,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? ManahColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Panduan Transfer Bank Manual',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: [
                    const Text(
                      'Silakan lakukan transfer sejumlah biaya paket ke rekening resmi CirclePro berikut:',
                      style: TextStyle(fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ManahColors.brandSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: ManahColors.brandLight.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Bank', style: TextStyle(color: ManahColors.mediumGrey, fontSize: 12)),
                              Text('Bank Mandiri', style: TextStyle(fontWeight: FontWeight.bold, color: ManahColors.brand)),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Nomor Rekening', style: TextStyle(color: ManahColors.mediumGrey, fontSize: 12)),
                              Text('123-456-7890', style: TextStyle(fontWeight: FontWeight.bold, color: ManahColors.brand)),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Atas Nama', style: TextStyle(color: ManahColors.mediumGrey, fontSize: 12)),
                              Text('CirclePro Indonesia', style: TextStyle(fontWeight: FontWeight.bold, color: ManahColors.brand)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Langkah setelah transfer:\n1. Klik tombol "Saya Sudah Transfer" di bawah.\n2. Hubungi WhatsApp admin di +62-812-3456-7890 untuk mengirimkan struk bukti pembayaran.\n3. Admin akan menyetujui transaksi Anda dalam waktu maksimal 1x24 jam.',
                      style: TextStyle(fontSize: 11, height: 1.5, color: ManahColors.mediumGrey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ManahColors.brand,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () async {
                  try {
                    final repo = ref.read(monetizationRepositoryProvider);
                    final response = await repo.purchaseManual(planCode);

                    if (context.mounted) {
                      Navigator.pop(context); // close sheet
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Permintaan Terkirim'),
                          content: Text(
                              'Permintaan langganan Anda telah dicatat dengan ${response['payment']['payment_number']}.\n\nSilakan kirimkan bukti transfer ke WhatsApp admin agar segera diverifikasi.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context); // close paywall screen too
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal membuat permintaan manual: $e'),
                          backgroundColor: ManahColors.error,
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Saya Sudah Transfer',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
