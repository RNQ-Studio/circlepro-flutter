import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../clubs_providers.dart';
import '../../domain/club_schedule_entity.dart';

class ClubScheduleScreen extends ConsumerStatefulWidget {
  const ClubScheduleScreen({super.key, required this.clubId});

  final String clubId;

  @override
  ConsumerState<ClubScheduleScreen> createState() => _ClubScheduleScreenState();
}

class _ClubScheduleScreenState extends ConsumerState<ClubScheduleScreen> {
  final _dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id');
  final _timeFormat = DateFormat('HH:mm');

  Future<void> _deleteSchedule(ClubScheduleEntity schedule) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Jadwal'),
        content: Text('Apakah Anda yakin ingin menghapus jadwal "${schedule.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: ManahColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await ref.read(clubsRepositoryProvider).deleteSchedule(widget.clubId, schedule.id);
        ref.invalidate(clubSchedulesProvider(widget.clubId));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Jadwal berhasil dihapus')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus jadwal: $e')),
          );
        }
      }
    }
  }

  void _showScheduleForm({ClubScheduleEntity? schedule}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ScheduleFormSheet(
        clubId: widget.clubId,
        schedule: schedule,
        onSuccess: () {
          ref.invalidate(clubSchedulesProvider(widget.clubId));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clubAsync = ref.watch(clubDetailProvider(widget.clubId));
    final schedulesAsync = ref.watch(clubSchedulesProvider(widget.clubId));

    return Scaffold(
      appBar: AppBar(
        title: clubAsync.when(
          data: (club) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Jadwal Latihan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(club.name, style: const TextStyle(fontSize: 12, color: ManahColors.mediumGrey)),
            ],
          ),
          loading: () => const Text('Jadwal Latihan'),
          error: (_, __) => const Text('Jadwal Latihan'),
        ),
      ),
      body: schedulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat jadwal: $err')),
        data: (schedules) {
          if (schedules.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(ManahSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_month_outlined, size: 64, color: Theme.of(context).dividerColor),
                    const SizedBox(height: ManahSpacing.base),
                    Text(
                      'Belum ada jadwal latihan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: ManahSpacing.xs),
                    const Text(
                      'Jadwal latihan rutin klub akan ditampilkan di sini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: ManahColors.mediumGrey),
                    ),
                    if (clubAsync.value?.isAdmin ?? false) ...[
                      const SizedBox(height: ManahSpacing.lg),
                      FilledButton.icon(
                        onPressed: () => _showScheduleForm(),
                        icon: const Icon(Icons.add),
                        label: const Text('Buat Jadwal Baru'),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(clubSchedulesProvider(widget.clubId));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(ManahSpacing.base),
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final s = schedules[index];
                final isAdmin = clubAsync.value?.isAdmin ?? false;
                final isPast = s.endTime.isBefore(DateTime.now());

                return Container(
                  margin: const EdgeInsets.only(bottom: ManahSpacing.base),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(ManahBorderRadius.card),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 6,
                          color: isPast ? ManahColors.mediumGrey : ManahColors.brand,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(ManahSpacing.base),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        s.title,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    if (isAdmin)
                                      PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.more_vert, size: 20, color: ManahColors.mediumGrey),
                                        onSelected: (val) {
                                          if (val == 'edit') {
                                            _showScheduleForm(schedule: s);
                                          } else if (val == 'delete') {
                                            _deleteSchedule(s);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(value: 'edit', child: Text('Ubah')),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Text('Hapus', style: TextStyle(color: ManahColors.error)),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                const SizedBox(height: ManahSpacing.xs),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 14, color: ManahColors.mediumGrey),
                                    const SizedBox(width: ManahSpacing.xs),
                                    Expanded(
                                      child: Text(
                                        '${_dateFormat.format(s.startTime)} • ${_timeFormat.format(s.startTime)} - ${_timeFormat.format(s.endTime)}',
                                        style: const TextStyle(fontSize: 12, color: ManahColors.mediumGrey),
                                      ),
                                    ),
                                  ],
                                ),
                                if (s.location != null && s.location!.isNotEmpty) ...[
                                  const SizedBox(height: ManahSpacing.xs),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 14, color: ManahColors.mediumGrey),
                                      const SizedBox(width: ManahSpacing.xs),
                                      Expanded(
                                        child: Text(
                                          s.location!,
                                          style: const TextStyle(fontSize: 12, color: ManahColors.mediumGrey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (s.description != null && s.description!.isNotEmpty) ...[
                                  const SizedBox(height: ManahSpacing.sm),
                                  Text(
                                    s.description!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13, color: ManahColors.darkGrey),
                                  ),
                                ],
                                const SizedBox(height: ManahSpacing.base),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _AttendanceStatusBadge(
                                      status: s.myAttendance?.status,
                                      isPast: isPast,
                                    ),
                                    if (isAdmin)
                                      TextButton.icon(
                                        onPressed: () {
                                          context.push('/clubs/${widget.clubId}/schedules/${s.id}/attendance');
                                        },
                                        style: TextButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        icon: const Icon(Icons.assignment_ind_outlined, size: 16),
                                        label: const Text('Kelola Absensi', style: TextStyle(fontSize: 12)),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: clubAsync.value?.isAdmin == true
          ? FloatingActionButton(
              onPressed: () => _showScheduleForm(),
              backgroundColor: ManahColors.brand,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _AttendanceStatusBadge extends StatelessWidget {
  const _AttendanceStatusBadge({required this.status, required this.isPast});

  final String? status;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    if (!isPast) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: ManahColors.brandSurface,
          borderRadius: BorderRadius.circular(ManahRadius.sm),
        ),
        child: const Text(
          'Akan Datang',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ManahColors.brand),
        ),
      );
    }

    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'present':
        bgColor = ManahColors.success.withValues(alpha: 0.1);
        textColor = ManahColors.success;
        label = 'Hadir';
        break;
      case 'absent':
        bgColor = ManahColors.error.withValues(alpha: 0.1);
        textColor = ManahColors.error;
        label = 'Absen';
        break;
      case 'sick':
        bgColor = ManahColors.warning.withValues(alpha: 0.1);
        textColor = ManahColors.warning;
        label = 'Sakit';
        break;
      case 'excused':
        bgColor = ManahColors.info.withValues(alpha: 0.1);
        textColor = ManahColors.info;
        label = 'Izin';
        break;
      default:
        bgColor = ManahColors.lightGrey;
        textColor = ManahColors.mediumGrey;
        label = 'Belum Dicatat';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(ManahRadius.sm),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }
}

class _ScheduleFormSheet extends ConsumerStatefulWidget {
  const _ScheduleFormSheet({
    required this.clubId,
    this.schedule,
    required this.onSuccess,
  });

  final String clubId;
  final ClubScheduleEntity? schedule;
  final VoidCallback onSuccess;

  @override
  ConsumerState<_ScheduleFormSheet> createState() => _ScheduleFormSheetState();
}

class _ScheduleFormSheetState extends ConsumerState<_ScheduleFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _locCtrl;

  late DateTime _date;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final s = widget.schedule;
    _titleCtrl = TextEditingController(text: s?.title);
    _descCtrl = TextEditingController(text: s?.description);
    _locCtrl = TextEditingController(text: s?.location);

    _date = s?.startTime ?? DateTime.now().add(const Duration(days: 1));
    _startTime = s != null ? TimeOfDay.fromDateTime(s.startTime) : const TimeOfDay(hour: 8, minute: 0);
    _endTime = s != null ? TimeOfDay.fromDateTime(s.endTime) : const TimeOfDay(hour: 10, minute: 0);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null) {
      setState(() => _endTime = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final startDateTime = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _startTime.hour,
      _startTime.minute,
    );

    final endDateTime = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _endTime.hour,
      _endTime.minute,
    );

    if (endDateTime.isBefore(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Waktu selesai harus setelah waktu mulai')),
      );
      return;
    }

    setState(() => _busy = true);
    try {
      final repo = ref.read(clubsRepositoryProvider);
      final payload = {
        'title': _titleCtrl.text,
        'description': _descCtrl.text,
        'location': _locCtrl.text,
        'start_time': startDateTime.toUtc().toIso8601String(),
        'end_time': endDateTime.toUtc().toIso8601String(),
      };

      if (widget.schedule == null) {
        await repo.createSchedule(widget.clubId, payload);
      } else {
        await repo.updateSchedule(widget.clubId, widget.schedule!.id, payload);
      }

      widget.onSuccess();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan jadwal: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        top: ManahSpacing.base,
        left: ManahSpacing.base,
        right: ManahSpacing.base,
        bottom: ManahSpacing.base + keyboardHeight,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(ManahRadius.lg)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.schedule == null ? 'Buat Jadwal Baru' : 'Ubah Jadwal',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: ManahSpacing.sm),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul Latihan *',
                hintText: 'Misal: Latihan Rutin Sabtu',
              ),
              validator: (v) => v == null || v.trim().isEmpty ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: ManahSpacing.base),
            TextFormField(
              controller: _locCtrl,
              decoration: const InputDecoration(
                labelText: 'Lokasi',
                hintText: 'Misal: Lapangan Utama Sasana',
              ),
            ),
            const SizedBox(height: ManahSpacing.base),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                hintText: 'Tulis detail kegiatan latihan...',
              ),
            ),
            const SizedBox(height: ManahSpacing.base),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(ManahRadius.sm),
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Tanggal'),
                      child: Text(DateFormat('dd MMM yyyy').format(_date)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: ManahSpacing.base),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickStartTime,
                    borderRadius: BorderRadius.circular(ManahRadius.sm),
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Mulai'),
                      child: Text(_startTime.format(context)),
                    ),
                  ),
                ),
                const SizedBox(width: ManahSpacing.base),
                Expanded(
                  child: InkWell(
                    onTap: _pickEndTime,
                    borderRadius: BorderRadius.circular(ManahRadius.sm),
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Selesai'),
                      child: Text(_endTime.format(context)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: ManahSpacing.xl),
            FilledButton(
              onPressed: _busy ? null : _save,
              child: _busy
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Simpan Jadwal'),
            ),
          ],
        ),
      ),
    );
  }
}
