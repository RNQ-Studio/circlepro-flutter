import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:core/core.dart';
import '../widgets/section_header.dart';
import '../widgets/demo_card.dart';

class FormInputScreen extends StatefulWidget {
  const FormInputScreen({super.key});

  @override
  State<FormInputScreen> createState() => _FormInputScreenState();
}

class _FormInputScreenState extends State<FormInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollCtrl = ScrollController();

  // Controllers
  final _nameCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  // State
  bool _showPw = false;
  bool _emailValid = false;
  bool _emailTouched = false;
  String? _selectedStack = 'Flutter';
  DateTime? _selectedDate;
  String _accountType = 'Personal';
  final Map<String, bool> _skills = {
    'Flutter': false,
    'Laravel': false,
    'UI/UX': false,
    'DevOps': false,
  };
  bool _notifEnabled = true;
  double _experience = 3;

  // Focus keys for scroll-to-error
  final _nameKey = GlobalKey();
  final _emailKey = GlobalKey();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pwCtrl.dispose();
    _emailCtrl.dispose();
    _noteCtrl.dispose();
    _dateCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  bool _isEmailValid(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateCtrl.text = DateFormat('dd MMMM yyyy').format(picked);
      });
    }
  }

  void _submit() {
    final isEmailOk = _isEmailValid(_emailCtrl.text);
    setState(() => _emailTouched = true);
    if (_formKey.currentState!.validate() && isEmailOk) {
      _showSuccess();
    } else {
      // Scroll to top if name is empty
      if (_nameCtrl.text.trim().isEmpty) {
        Scrollable.ensureVisible(_nameKey.currentContext!,
            duration: const Duration(milliseconds: 400));
      } else if (!isEmailOk) {
        Scrollable.ensureVisible(_emailKey.currentContext!,
            duration: const Duration(milliseconds: 400));
      }
    }
  }

  void _showSuccess() {
    final selectedSkills =
        _skills.entries.where((e) => e.value).map((e) => e.key).toList();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.check_circle, color: AppColors.success),
          SizedBox(width: 8),
          Text('Form Berhasil!'),
        ]),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _summaryRow('Nama', _nameCtrl.text),
              _summaryRow('Email', _emailCtrl.text),
              _summaryRow('Stack', _selectedStack ?? '-'),
              _summaryRow(
                  'Tgl Lahir',
                  _selectedDate != null
                      ? DateFormat('dd MMMM yyyy').format(_selectedDate!)
                      : '-'),
              _summaryRow('Tipe Akun', _accountType),
              _summaryRow('Keahlian',
                  selectedSkills.isEmpty ? '-' : selectedSkills.join(', ')),
              _summaryRow(
                  'Notifikasi', _notifEnabled ? 'Aktif' : 'Nonaktif'),
              _summaryRow('Pengalaman', '${_experience.round()} tahun'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 90,
              child: Text('$label:',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.galleryFormScreenTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          controller: _scrollCtrl,
          children: [
            SectionHeader(
                title: l10n.gallerySectionTextFields, subtitle: l10n.gallerySectionTextFieldsDesc),

            // 1. TextField biasa
            DemoCard(
              key: _nameKey,
              title: '1. TextField dengan Counter',
              subtitle: 'Floating label, prefix icon, max 50 karakter',
              child: TextFormField(
                controller: _nameCtrl,
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
              ),
            ),

            // 2. Password Field
            DemoCard(
              title: '2. Password Field',
              subtitle: 'Toggle show/hide password',
              child: TextFormField(
                controller: _pwCtrl,
                obscureText: !_showPw,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _showPw ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _showPw = !_showPw),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.length < 6) ? 'Min. 6 karakter' : null,
              ),
            ),

            // 3. Email dengan validasi real-time
            DemoCard(
              key: _emailKey,
              title: '3. Email dengan Validasi Real-time',
              subtitle: 'Border & helper berubah sesuai status input',
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (v) => setState(() {
                      _emailTouched = true;
                      _emailValid = _isEmailValid(v);
                    }),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      helperText: !_emailTouched
                          ? 'Masukkan email yang valid'
                          : _emailValid
                              ? 'Email valid ✓'
                              : 'Format email tidak valid',
                      helperStyle: TextStyle(
                        color: !_emailTouched
                            ? Colors.grey
                            : _emailValid
                                ? AppColors.success
                                : AppColors.error,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: !_emailTouched
                              ? AppColors.grey200
                              : _emailValid
                                  ? AppColors.success
                                  : AppColors.error,
                          width: _emailTouched ? 2 : 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 4. Multiline / TextArea
            DemoCard(
              title: '4. TextArea / Multiline',
              subtitle: 'Min 3 baris, max 6 baris',
              child: TextFormField(
                controller: _noteCtrl,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Catatan / Keterangan',
                  alignLabelWithHint: true,
                ),
              ),
            ),

            SectionHeader(
                title: l10n.gallerySectionSelectors, subtitle: l10n.gallerySectionSelectorsDesc),

            // 5. Dropdown
            DemoCard(
              title: '5. Dropdown',
              subtitle: 'Pilih tech stack favorit',
              child: DropdownButtonFormField<String>(
                value: _selectedStack,
                decoration: const InputDecoration(
                  labelText: 'Tech Stack',
                  prefixIcon: Icon(Icons.code),
                ),
                items: const ['Flutter', 'Laravel', 'Next.js', 'React Native', 'Vue.js']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedStack = v),
              ),
            ),

            // 6. Date Picker
            DemoCard(
              title: '6. Date Picker',
              subtitle: 'Tap untuk pilih tanggal',
              child: TextFormField(
                readOnly: true,
                onTap: _pickDate,
                controller: _dateCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
              ),
            ),

            // 7. Radio Button Group
            DemoCard(
              title: '7. Radio Button Group',
              subtitle: 'Pilih tipe akun',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipe Akun:',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    children: ['Personal', 'Tim', 'Perusahaan']
                        .map((t) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: t,
                                  groupValue: _accountType,
                                  onChanged: (v) =>
                                      setState(() => _accountType = v!),
                                ),
                                Text(t),
                                const SizedBox(width: 12),
                              ],
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

            // 8. Checkbox Group
            DemoCard(
              title: '8. Checkbox Group',
              subtitle: 'Pilih satu atau lebih keahlian',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Keahlian:',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  for (final entry in _skills.entries)
                    CheckboxListTile(
                      title: Text(entry.key),
                      value: entry.value,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (v) =>
                          setState(() => _skills[entry.key] = v!),
                    ),
                ],
              ),
            ),

            SectionHeader(
                title: l10n.gallerySectionTogglesSliders, subtitle: l10n.gallerySectionTogglesSlidersDesc),

            // 9. Toggle Switch
            DemoCard(
              title: '9. Toggle Switch',
              subtitle: 'Aktifkan/nonaktifkan notifikasi',
              child: SwitchListTile(
                title: const Text('Aktifkan Notifikasi'),
                subtitle: Text(_notifEnabled
                    ? 'Kamu akan menerima notifikasi push'
                    : 'Notifikasi dinonaktifkan'),
                value: _notifEnabled,
                onChanged: (v) => setState(() => _notifEnabled = v),
                contentPadding: EdgeInsets.zero,
              ),
            ),

            // 10. Slider
            DemoCard(
              title: '10. Slider',
              subtitle: 'Pengalaman kerja dalam tahun',
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                          child: Text('Pengalaman (tahun)')),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_experience.round()} thn',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _experience,
                    min: 0,
                    max: 20,
                    divisions: 20,
                    label: '${_experience.round()} tahun',
                    onChanged: (v) => setState(() => _experience = v),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
                icon: const Icon(Icons.send),
                label: const Text('Submit Form'),
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
