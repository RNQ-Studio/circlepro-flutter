import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../group_invite_share.dart';
import '../group_scoring_providers.dart';
import '../widgets/join_qr_view.dart';

/// Full-screen QR poster (Sprint 09, task 9.3). The host drops the phone on the
/// coffee table and everyone scans in parallel while stringing their bows.
class ShowQrScreen extends ConsumerWidget {
  const ShowQrScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(groupDetailProvider(groupId));

    return Scaffold(
      appBar: AppBar(title: const Text('QR Undangan')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            const Center(child: Text('Sesi tidak ditemukan.')),
        data: (group) {
          if (group == null) {
            return const Center(child: Text('Sesi tidak ditemukan.'));
          }
          final title =
              group.title?.isNotEmpty == true ? group.title! : 'Latihan Bersama';
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(ManahSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: ManahSpacing.xs),
                  Text(
                    'Pindai untuk bergabung',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.textTheme.bodySmall?.color),
                  ),
                  const SizedBox(height: ManahSpacing.xl),
                  JoinQrView(code: group.joinCode, size: 280),
                  const SizedBox(height: ManahSpacing.lg),
                  Text(
                    group.joinCode,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6,
                      color: ManahColors.brand,
                    ),
                  ),
                  const SizedBox(height: ManahSpacing.xs),
                  Text(
                    'Tidak bisa scan? Ketik kode di atas, atau bagikan tautannya.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: ManahColors.mediumGrey),
                  ),
                  const SizedBox(height: ManahSpacing.xl),
                  OutlinedButton.icon(
                    onPressed: () => shareGroupInvite(group),
                    icon: const Icon(Icons.ios_share),
                    label: const Text('Bagikan Tautan'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
