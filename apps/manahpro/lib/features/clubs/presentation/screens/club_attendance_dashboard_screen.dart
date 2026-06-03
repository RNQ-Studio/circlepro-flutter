import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../clubs_providers.dart';
import '../../domain/club_schedule_entity.dart';

class ClubAttendanceDashboardScreen extends ConsumerStatefulWidget {
  const ClubAttendanceDashboardScreen({
    super.key,
    required this.clubId,
    required this.scheduleId,
  });

  final String clubId;
  final String scheduleId;

  @override
  ConsumerState<ClubAttendanceDashboardScreen> createState() => _ClubAttendanceDashboardScreenState();
}

class _ClubAttendanceDashboardScreenState extends ConsumerState<ClubAttendanceDashboardScreen> {
  final Map<int, String> _statuses = {};
  final Map<int, String> _remarks = {};
  bool _initialized = false;
  bool _saving = false;

  void _initializeData(List<ClubAttendanceEntity> list) {
    if (_initialized) return;
    for (final item in list) {
      if (item.status != null) {
        _statuses[item.userId] = item.status!;
      } else {
        _statuses[item.userId] = 'absent'; // default to absent
      }
      if (item.remark != null) {
        _remarks[item.userId] = item.remark!;
      }
    }
    _initialized = true;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final payload = _statuses.entries.map((e) {
        final userId = e.key;
        final status = e.value;
        final remark = _remarks[userId];
        return {
          'user_id': userId,
          'status': status,
          'remark': remark,
        };
      }).toList();

      await ref.read(clubsRepositoryProvider).saveScheduleAttendance(
            widget.clubId,
            widget.scheduleId,
            payload,
          );

      ref.invalidate(scheduleAttendanceProvider(widget.clubId, widget.scheduleId));
      ref.invalidate(clubSchedulesProvider(widget.clubId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Presensi berhasil disimpan')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan presensi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _editRemark(int userId, String currentRemark, String userName) {
    final ctrl = TextEditingController(text: currentRemark);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Catatan Kehadiran — $userName'),
        content: TextField(
          controller: ctrl,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'Tulis keterangan (sakit, terlambat, dll.)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (ctrl.text.trim().isEmpty) {
                  _remarks.remove(userId);
                } else {
                  _remarks[userId] = ctrl.text.trim();
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final attendanceAsync = ref.watch(scheduleAttendanceProvider(widget.clubId, widget.scheduleId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lembar Kehadiran'),
      ),
      body: attendanceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat daftar anggota: $err')),
        data: (list) {
          _initializeData(list);

          if (list.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(ManahSpacing.xl),
                child: Text('Belum ada anggota aktif di klub ini.', style: TextStyle(color: ManahColors.mediumGrey)),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(
              top: ManahSpacing.base,
              left: ManahSpacing.base,
              right: ManahSpacing.base,
              bottom: 80,
            ),
            itemCount: list.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = list[index];
              final userId = item.userId;
              final hasRemark = _remarks[userId]?.isNotEmpty ?? false;
              final displayName = item.fullName ?? item.username ?? 'Anggota';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: ManahSpacing.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: ManahColors.brandSurface,
                          backgroundImage: item.avatarUrl != null ? NetworkImage(item.avatarUrl!) : null,
                          child: item.avatarUrl == null
                              ? const Icon(Icons.person, color: ManahColors.brand, size: 18)
                              : null,
                        ),
                        const SizedBox(width: ManahSpacing.sm),
                        Expanded(
                          child: Text(
                            displayName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _editRemark(userId, _remarks[userId] ?? '', displayName),
                          icon: Icon(
                            hasRemark ? Icons.note : Icons.note_add_outlined,
                            color: hasRemark ? ManahColors.brand : ManahColors.mediumGrey,
                            size: 20,
                          ),
                          tooltip: 'Catatan Kehadiran',
                        ),
                      ],
                    ),
                    if (hasRemark) ...[
                      const SizedBox(height: 2),
                      Padding(
                        padding: const EdgeInsets.only(left: 44),
                        child: Text(
                          _remarks[userId]!,
                          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: ManahColors.mediumGrey),
                        ),
                      ),
                    ],
                    const SizedBox(height: ManahSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.only(left: 44),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildStatusChip(userId, 'present', 'Hadir', ManahColors.success),
                            const SizedBox(width: ManahSpacing.xs),
                            _buildStatusChip(userId, 'absent', 'Absen', ManahColors.error),
                            const SizedBox(width: ManahSpacing.xs),
                            _buildStatusChip(userId, 'sick', 'Sakit', ManahColors.warning),
                            const SizedBox(width: ManahSpacing.xs),
                            _buildStatusChip(userId, 'excused', 'Izin', ManahColors.info),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(ManahSpacing.base),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(top: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1))),
          ),
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text('Simpan Presensi'),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(int userId, String status, String label, Color color) {
    final isSelected = _statuses[userId] == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: color.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? color : null,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _statuses[userId] = status;
          });
        }
      },
    );
  }
}
