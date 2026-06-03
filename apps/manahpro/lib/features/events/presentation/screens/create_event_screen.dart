import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../scoring/domain/scoring_enums.dart';
import '../../../scoring/utils/ulid.dart';
import '../../../clubs/presentation/clubs_providers.dart';
import '../../domain/event_division_entity.dart';
import '../../domain/event_entity.dart';
import '../../domain/event_enums.dart';
import '../events_providers.dart';
import '../../data/event_model.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  int _currentStep = 0;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  // Step 1: Info Dasar
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  EventTier _selectedTier = EventTier.b;
  EventFormat _selectedFormat = EventFormat.rankingRound;
  String? _selectedClubId;

  // Step 2: Waktu & Lokasi
  DateTime? _startsAt;
  DateTime? _endsAt;
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();
  final _venueNameController = TextEditingController();
  final _addressController = TextEditingController();

  // Step 3: Divisi
  final List<EventDivisionEntity> _divisions = [];

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _venueNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myClubsAsync = ref.watch(myClubsProvider);
    final fallbackClubsAsync = ref.watch(clubDirectoryProvider());

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Event Baru'),
      ),
      body: myClubsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat data klub: $err')),
        data: (myClubs) {
          // If no clubs are joined, check fallback list
          return fallbackClubsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Gagal memuat klub publik: $err')),
            data: (allClubs) {
              final availableClubs = myClubs.isNotEmpty ? myClubs : allClubs;

              if (availableClubs.isNotEmpty && _selectedClubId == null) {
                _selectedClubId = availableClubs.first.id;
              }

              return Column(
                children: [
                  // Step Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: ManahSpacing.base),
                    color: isDark ? ManahColors.darkSurface : ManahColors.lightGrey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStepIndicator(0, 'Informasi'),
                        _buildStepIndicator(1, 'Waktu & Tempat'),
                        _buildStepIndicator(2, 'Divisi & Biaya'),
                        _buildStepIndicator(3, 'Konfirmasi'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(ManahSpacing.base),
                      child: _buildCurrentStepContent(availableClubs, isDark),
                    ),
                  ),
                  // Bottom Navigation Actions
                  _buildBottomNavigation(availableClubs),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title) {
    final isActive = _currentStep == stepIndex;
    final isCompleted = _currentStep > stepIndex;

    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isCompleted
              ? ManahColors.success
              : isActive
                  ? ManahColors.brand
                  : ManahColors.mediumGrey.withOpacity(0.3),
          child: isCompleted
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Text(
                  '${stepIndex + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isActive || isCompleted ? Colors.white : ManahColors.mediumGrey,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: ManahTextStyles.bodyS.copyWith(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? ManahColors.brand : ManahColors.mediumGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStepContent(List<dynamic> availableClubs, bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildStep1(availableClubs, isDark);
      case 1:
        return _buildStep2(isDark);
      case 2:
        return _buildStep3(isDark);
      case 3:
        return _buildStep4(isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1(List<dynamic> availableClubs, bool isDark) {
    return Form(
      key: _formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Informasi Dasar', style: ManahTextStyles.h2),
          const SizedBox(height: ManahSpacing.base),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Nama / Judul Event *',
              hintText: 'Contoh: Piala Walikota Recurve 2026',
            ),
            validator: (value) => value == null || value.trim().isEmpty ? 'Nama event harus diisi' : null,
          ),
          const SizedBox(height: ManahSpacing.base),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Deskripsi Event',
              hintText: 'Jelaskan detail event, format pertandingan, dll.',
            ),
          ),
          const SizedBox(height: ManahSpacing.base),
          DropdownButtonFormField<EventTier>(
            value: _selectedTier,
            decoration: const InputDecoration(labelText: 'Tier Event *'),
            items: EventTier.values
                .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedTier = val);
            },
          ),
          const SizedBox(height: ManahSpacing.base),
          DropdownButtonFormField<EventFormat>(
            value: _selectedFormat,
            decoration: const InputDecoration(labelText: 'Format Tanding *'),
            items: EventFormat.values
                .map((f) => DropdownMenuItem(value: f, child: Text(f.label)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedFormat = val);
            },
          ),
          const SizedBox(height: ManahSpacing.base),
          if (availableClubs.isNotEmpty)
            DropdownButtonFormField<String>(
              value: _selectedClubId,
              decoration: const InputDecoration(labelText: 'Penyelenggara / Klub *'),
              items: availableClubs
                  .map((c) => DropdownMenuItem(value: c.id as String, child: Text(c.name as String)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedClubId = val);
              },
            )
          else
            Container(
              padding: const EdgeInsets.all(ManahSpacing.base),
              decoration: BoxDecoration(
                color: ManahColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ManahRadius.md),
                border: Border.all(color: ManahColors.warning),
              ),
              child: Text(
                'Peringatan: Tidak ada klub terdaftar. Silakan buat klub terlebih dahulu atau gunakan mode simulasi.',
                style: ManahTextStyles.bodyM.copyWith(color: ManahColors.warning),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStep2(bool isDark) {
    final startsStr = _startsAt != null
        ? DateFormat('EEEE, dd MMM yyyy HH:mm', 'id').format(_startsAt!)
        : 'Pilih Tanggal Mulai';
    final endsStr = _endsAt != null
        ? DateFormat('EEEE, dd MMM yyyy HH:mm', 'id').format(_endsAt!)
        : 'Pilih Tanggal Selesai';

    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Waktu & Lokasi', style: ManahTextStyles.h2),
          const SizedBox(height: ManahSpacing.base),
          ListTile(
            title: const Text('Tanggal Mulai *'),
            subtitle: Text(startsStr, style: TextStyle(color: _startsAt != null ? ManahColors.brand : null)),
            trailing: const Icon(Icons.calendar_month),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
              borderRadius: BorderRadius.circular(ManahRadius.sm),
            ),
            onTap: () => _pickDateTime(true),
          ),
          const SizedBox(height: ManahSpacing.base),
          ListTile(
            title: const Text('Tanggal Selesai *'),
            subtitle: Text(endsStr, style: TextStyle(color: _endsAt != null ? ManahColors.brand : null)),
            trailing: const Icon(Icons.calendar_month),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
              borderRadius: BorderRadius.circular(ManahRadius.sm),
            ),
            onTap: () => _pickDateTime(false),
          ),
          const SizedBox(height: ManahSpacing.base),
          TextFormField(
            controller: _provinceController,
            decoration: const InputDecoration(
              labelText: 'Provinsi *',
              hintText: 'Contoh: D.I. Yogyakarta',
            ),
            validator: (value) => value == null || value.trim().isEmpty ? 'Provinsi harus diisi' : null,
          ),
          const SizedBox(height: ManahSpacing.base),
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(
              labelText: 'Kota / Kabupaten *',
              hintText: 'Contoh: Sleman',
            ),
            validator: (value) => value == null || value.trim().isEmpty ? 'Kota harus diisi' : null,
          ),
          const SizedBox(height: ManahSpacing.base),
          TextFormField(
            controller: _venueNameController,
            decoration: const InputDecoration(
              labelText: 'Nama Venue / Lapangan *',
              hintText: 'Contoh: Lapangan Panahan Sleman',
            ),
            validator: (value) => value == null || value.trim().isEmpty ? 'Nama venue harus diisi' : null,
          ),
          const SizedBox(height: ManahSpacing.base),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Alamat Lengkap',
              hintText: 'Contoh: Jl. Magelang KM 10, Sleman',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3(bool isDark) {
    final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Divisi & Biaya', style: ManahTextStyles.h2),
            ElevatedButton.icon(
              onPressed: () => _showAddDivisionSheet(context),
              icon: const Icon(Icons.add),
              label: const Text('Tambah'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ManahColors.brand,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: ManahSpacing.base),
        if (_divisions.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 48),
            decoration: BoxDecoration(
              border: Border.all(color: isDark ? Colors.white12 : Colors.black12, style: BorderStyle.none),
            ),
            child: const Center(
              child: Text(
                'Belum ada divisi ditambahkan.\nTekan tombol Tambah untuk membuat minimal satu divisi.',
                textAlign: TextAlign.center,
                style: TextStyle(color: ManahColors.mediumGrey),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _divisions.length,
            separatorBuilder: (_, __) => const SizedBox(height: ManahSpacing.sm),
            itemBuilder: (context, index) {
              final div = _divisions[index];
              return ListTile(
                title: Text(div.displayName),
                subtitle: Text(
                  '${div.distanceM}m · ${div.numArrows} arrow · Fee: ${currencyFormatter.format(div.entryFee)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: ManahColors.error),
                  onPressed: () => setState(() => _divisions.removeAt(index)),
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
                  borderRadius: BorderRadius.circular(ManahRadius.sm),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildStep4(bool isDark) {
    final startsStr = _startsAt != null
        ? DateFormat('EEEE, dd MMM yyyy HH:mm', 'id').format(_startsAt!)
        : '-';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Konfirmasi & Publikasi', style: ManahTextStyles.h2),
        const SizedBox(height: ManahSpacing.base),
        Text('Nama Event', style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey)),
        Text(_titleController.text, style: ManahTextStyles.bodyL.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: ManahSpacing.sm),
        Text('Tanggal & Waktu', style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey)),
        Text(startsStr, style: ManahTextStyles.bodyL),
        const SizedBox(height: ManahSpacing.sm),
        Text('Lokasi', style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey)),
        Text('${_venueNameController.text}, ${_cityController.text}', style: ManahTextStyles.bodyL),
        const SizedBox(height: ManahSpacing.sm),
        Text('Tier / Format', style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey)),
        Text('Tier ${_selectedTier.value} / ${_selectedFormat.label}', style: ManahTextStyles.bodyL),
        const SizedBox(height: ManahSpacing.base),
        const Divider(),
        const SizedBox(height: ManahSpacing.base),
        Text('Daftar Divisi (${_divisions.length})', style: ManahTextStyles.h3),
        const SizedBox(height: ManahSpacing.sm),
        ..._divisions.map((div) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('• ${div.displayName}', style: ManahTextStyles.bodyM),
                  Text(
                    NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(div.entryFee),
                    style: ManahTextStyles.bodyM.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildBottomNavigation(List<dynamic> availableClubs) {
    return Container(
      padding: const EdgeInsets.all(ManahSpacing.base),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentStep > 0)
              TextButton(
                onPressed: () => setState(() => _currentStep--),
                child: const Text('KEMBALI'),
              )
            else
              const SizedBox.shrink(),
            ElevatedButton(
              onPressed: _isSubmitting ? null : () => _onNext(availableClubs),
              style: ElevatedButton.styleFrom(
                backgroundColor: ManahColors.brand,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: ManahSpacing.lg,
                  vertical: ManahSpacing.base,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ManahRadius.md),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(_currentStep == 3 ? 'SIMPAN EVENT' : 'LANJUT'),
            ),
          ],
        ),
      ),
    );
  }

  void _onNext(List<dynamic> availableClubs) {
    if (_currentStep == 0) {
      if (_formKey1.currentState?.validate() ?? false) {
        if (_selectedClubId == null && availableClubs.isNotEmpty) {
          _selectedClubId = availableClubs.first.id;
        }
        if (_selectedClubId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Silakan pilih klub penyelenggara')),
          );
          return;
        }
        setState(() => _currentStep++);
      }
    } else if (_currentStep == 1) {
      if (_formKey2.currentState?.validate() ?? false) {
        if (_startsAt == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Silakan tentukan tanggal mulai')),
          );
          return;
        }
        setState(() => _currentStep++);
      }
    } else if (_currentStep == 2) {
      if (_divisions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tambahkan minimal satu divisi tanding')),
        );
        return;
      }
      setState(() => _currentStep++);
    } else if (_currentStep == 3) {
      _submitEvent();
    }
  }

  Future<void> _pickDateTime(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (time == null) return;

    final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      if (isStart) {
        _startsAt = dt;
      } else {
        _endsAt = dt;
      }
    });
  }

  void _showAddDivisionSheet(BuildContext context) {
    BowClass bowClass = BowClass.recurve;
    AgeGroup ageGroup = AgeGroup.dewasa;
    Gender gender = Gender.male;
    DistanceCategory distanceCategory = DistanceCategory.d70m;
    final entryFeeController = TextEditingController(text: '150000');
    final capacityController = TextEditingController(text: '32');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: ManahSpacing.base,
                right: ManahSpacing.base,
                top: ManahSpacing.base,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Tambah Divisi Tanding', style: ManahTextStyles.h3),
                    const SizedBox(height: ManahSpacing.base),
                    // Bow class
                    DropdownButtonFormField<BowClass>(
                      value: bowClass,
                      decoration: const InputDecoration(labelText: 'Tipe Busur'),
                      items: BowClass.values
                          .map((b) => DropdownMenuItem(value: b, child: Text(b.label)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setSheetState(() => bowClass = val);
                      },
                    ),
                    const SizedBox(height: ManahSpacing.sm),
                    // Age group
                    DropdownButtonFormField<AgeGroup>(
                      value: ageGroup,
                      decoration: const InputDecoration(labelText: 'Kelompok Umur'),
                      items: AgeGroup.values
                          .map((a) => DropdownMenuItem(value: a, child: Text(a.label)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setSheetState(() => ageGroup = val);
                      },
                    ),
                    const SizedBox(height: ManahSpacing.sm),
                    // Gender
                    DropdownButtonFormField<Gender>(
                      value: gender,
                      decoration: const InputDecoration(labelText: 'Kategori Gender'),
                      items: Gender.values
                          .map((g) => DropdownMenuItem(value: g, child: Text(g.label)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setSheetState(() => gender = val);
                      },
                    ),
                    const SizedBox(height: ManahSpacing.sm),
                    // Distance Category
                    DropdownButtonFormField<DistanceCategory>(
                      value: distanceCategory,
                      decoration: const InputDecoration(labelText: 'Kategori Jarak'),
                      items: DistanceCategory.values
                          .map((d) => DropdownMenuItem(value: d, child: Text(d.label)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setSheetState(() => distanceCategory = val);
                      },
                    ),
                    const SizedBox(height: ManahSpacing.sm),
                    // Entry Fee
                    TextFormField(
                      controller: entryFeeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Biaya Pendaftaran (Rupiah)',
                        hintText: 'Contoh: 150000',
                      ),
                    ),
                    const SizedBox(height: ManahSpacing.sm),
                    // Capacity
                    TextFormField(
                      controller: capacityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Kuota Divisi (Peserta)',
                        hintText: 'Contoh: 32',
                      ),
                    ),
                    const SizedBox(height: ManahSpacing.base),
                    ElevatedButton(
                      onPressed: () {
                        final fee = int.tryParse(entryFeeController.text) ?? 0;
                        final cap = int.tryParse(capacityController.text);
                        final divId = Ids.ulid();

                        final newDiv = EventDivisionEntity(
                          id: divId,
                          eventId: '',
                          bowClass: bowClass,
                          gender: gender,
                          ageGroup: ageGroup,
                          distanceCategory: distanceCategory,
                          distanceM: distanceCategory.meters,
                          numArrows: 36, // default
                          maxScore: 360, // default
                          entryFee: fee,
                          capacity: cap,
                          numParticipants: 0,
                          ratingStatus: 'unrated',
                        );

                        setState(() => _divisions.add(newDiv));
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ManahColors.brand,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('TAMBAHKAN DIVISI'),
                    ),
                    const SizedBox(height: ManahSpacing.base),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submitEvent() async {
    setState(() => _isSubmitting = true);

    try {
      final eventId = Ids.ulid();
      final slug = _titleController.text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-');

      // Map division event IDs
      final mappedDivisions = _divisions.map((d) {
        return EventDivisionEntity(
          id: d.id,
          eventId: eventId,
          bowClass: d.bowClass,
          gender: d.gender,
          ageGroup: d.ageGroup,
          distanceCategory: d.distanceCategory,
          distanceM: d.distanceM,
          numArrows: d.numArrows,
          maxScore: d.maxScore,
          entryFee: d.entryFee,
          capacity: d.capacity,
          numParticipants: d.numParticipants,
          ratingStatus: d.ratingStatus,
        );
      }).toList();

      final totalCapacity = mappedDivisions.fold<int>(0, (sum, d) => sum + (d.capacity ?? 0));

      final eventEntity = EventEntity(
        id: eventId,
        organizationId: _selectedClubId!,
        createdBy: 1, // Will be overridden by Auth user on server
        title: _titleController.text,
        slug: '$slug-${Ids.ulid().substring(0, 6).toLowerCase()}',
        description: _descriptionController.text,
        tier: _selectedTier,
        format: _selectedFormat,
        status: EventStatus.draft, // Default to draft
        province: _provinceController.text,
        city: _cityController.text,
        venueName: _venueNameController.text,
        address: _addressController.text,
        startsAt: _startsAt!,
        endsAt: _endsAt ?? _startsAt!.add(const Duration(days: 1)),
        capacity: totalCapacity > 0 ? totalCapacity : null,
        isExternal: false,
        divisions: mappedDivisions,
      );

      final rawData = eventToJson(eventEntity);
      await ref.read(eventsRepositoryProvider).createEvent(rawData);

      // Invalidate events cache to show the new event
      ref.invalidate(eventsListProvider);
      ref.invalidate(myEventsProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event berhasil dibuat!'),
          backgroundColor: ManahColors.success,
        ),
      );
      context.pop(); // Go back to listings
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat event: $e'),
          backgroundColor: ManahColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
