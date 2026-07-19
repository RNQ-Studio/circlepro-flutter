import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/equipment_profile_entity.dart';
import '../../domain/round_preset.dart';
import '../../domain/scoring_entities.dart';
import '../../domain/scoring_enums.dart';

class ScoringSetupHeader extends StatelessWidget {
  const ScoringSetupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scoring individu',
          style: textTheme.labelLarge?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: ManahSpacing.sm),
        Text('Siapkan sesi', style: textTheme.headlineMedium),
        const SizedBox(height: ManahSpacing.sm),
        Text(
          'Pilih format latihanmu. Pengaturan terakhir tetap tersimpan di perangkat.',
          style: textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class ScoringSetupSection extends StatelessWidget {
  const ScoringSetupSection({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: const BorderRadius.all(
          Radius.circular(ManahRadius.lg),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(ManahRadius.md),
                    ),
                  ),
                  child: SizedBox.square(
                    dimension: 40,
                    child: Icon(
                      icon,
                      color: colors.onPrimaryContainer,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: ManahSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleMedium),
                      const SizedBox(height: ManahSpacing.xs),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: ManahSpacing.base),
            child,
          ],
        ),
      ),
    );
  }
}

class BowCategorySelector extends StatelessWidget {
  const BowCategorySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final BowCategory selected;
  final ValueChanged<BowCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<BowCategory>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(
          value: BowCategory.traditional,
          icon: Icon(Icons.brightness_low_rounded),
          label: Text('Tradisional'),
        ),
        ButtonSegment(
          value: BowCategory.modern,
          icon: Icon(Icons.tune_rounded),
          label: Text('Modern'),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (values) => onChanged(values.first),
    );
  }
}

class BowClassSelector extends StatelessWidget {
  const BowClassSelector({
    super.key,
    required this.values,
    required this.selected,
    required this.onChanged,
  });

  final List<BowClass> values;
  final BowClass selected;
  final ValueChanged<BowClass> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Kelas busur', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: ManahSpacing.sm),
        Wrap(
          spacing: ManahSpacing.sm,
          runSpacing: ManahSpacing.sm,
          children: [
            for (final bowClass in values)
              ChoiceChip(
                label: Text(bowClass.label),
                selected: selected == bowClass,
                onSelected: (_) => onChanged(bowClass),
              ),
          ],
        ),
      ],
    );
  }
}

class EquipmentPicker extends StatelessWidget {
  const EquipmentPicker({
    super.key,
    required this.profiles,
    required this.selectedId,
    required this.onChanged,
  });

  final List<EquipmentProfileEntity> profiles;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: ManahSpacing.base),
        DropdownButtonFormField<String?>(
          initialValue: selectedId,
          decoration: const InputDecoration(
            labelText: 'Equipment (opsional)',
          ),
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('Tanpa equipment'),
            ),
            for (final profile in profiles)
              DropdownMenuItem<String?>(
                value: profile.id,
                child: Text(profile.name),
              ),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class RoundPresetField extends StatelessWidget {
  const RoundPresetField({
    super.key,
    required this.selected,
    required this.onTap,
    required this.onClear,
  });

  final RoundPreset? selected;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: colors.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(ManahRadius.md),
            ),
            side: BorderSide(color: colors.outlineVariant),
          ),
          child: InkWell(
            key: const ValueKey('round-preset-field'),
            onTap: onTap,
            borderRadius: const BorderRadius.all(
              Radius.circular(ManahRadius.md),
            ),
            child: Padding(
              padding: const EdgeInsets.all(ManahSpacing.base),
              child: Row(
                children: [
                  Icon(Icons.view_list_rounded, color: colors.primary),
                  const SizedBox(width: ManahSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selected?.label ?? 'Pilih preset ronde',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: ManahSpacing.xs),
                        Text(
                          selected?.description ??
                              'Opsional, semua nilai dapat diatur manual.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: ManahSpacing.sm),
                  Icon(
                    Icons.unfold_more_rounded,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (selected != null) ...[
          const SizedBox(height: ManahSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onClear,
              child: const Text('Atur manual'),
            ),
          ),
        ],
      ],
    );
  }
}

class RoundPresetSheet extends StatelessWidget {
  const RoundPresetSheet({
    super.key,
    required this.selected,
  });

  final RoundPreset? selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return FractionallySizedBox(
      heightFactor: 0.82,
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                ManahSpacing.base,
                ManahSpacing.sm,
                ManahSpacing.base,
                ManahSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih preset ronde',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: ManahSpacing.xs),
                  Text(
                    'Preset mengisi jarak, target, dan jumlah panah sekaligus.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: colors.outlineVariant),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: ManahSpacing.sm,
                ),
                itemCount: RoundPreset.values.length,
                separatorBuilder: (_, __) => Divider(
                  indent: ManahSpacing.base,
                  endIndent: ManahSpacing.base,
                  color: colors.outlineVariant,
                ),
                itemBuilder: (context, index) {
                  final preset = RoundPreset.values[index];
                  final isSelected = selected?.key == preset.key;
                  return ListTile(
                    minVerticalPadding: ManahSpacing.md,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: ManahSpacing.base,
                    ),
                    title: Text(preset.label),
                    subtitle: Text(
                      '${preset.category.label} · ${preset.description ?? '${preset.distanceM}m'}',
                    ),
                    trailing: Icon(
                      isSelected
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      color:
                          isSelected ? colors.primary : colors.onSurfaceVariant,
                    ),
                    onTap: () => Navigator.pop(context, preset),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DistanceSelector extends StatelessWidget {
  const DistanceSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final DistanceCategory selected;
  final ValueChanged<DistanceCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<DistanceCategory>(
      key: const ValueKey('distance-selector'),
      initialValue: selected,
      decoration: const InputDecoration(labelText: 'Jarak'),
      items: [
        for (final distance in DistanceCategory.values)
          DropdownMenuItem(
            value: distance,
            child: Text(distance.label),
          ),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class EnvironmentSelector extends StatelessWidget {
  const EnvironmentSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ArcheryEnvironment selected;
  final ValueChanged<ArcheryEnvironment> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Lingkungan', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: ManahSpacing.sm),
        SegmentedButton<ArcheryEnvironment>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(
              value: ArcheryEnvironment.outdoor,
              icon: Icon(Icons.wb_sunny_outlined),
              label: Text('Outdoor'),
            ),
            ButtonSegment(
              value: ArcheryEnvironment.indoor,
              icon: Icon(Icons.home_work_outlined),
              label: Text('Indoor'),
            ),
          ],
          selected: {selected},
          onSelectionChanged: (values) => onChanged(values.first),
        ),
      ],
    );
  }
}

class ScoringCounterRow extends StatelessWidget {
  const ScoringCounterRow({
    super.key,
    required this.label,
    required this.helper,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final String helper;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.titleSmall),
              const SizedBox(height: ManahSpacing.xs),
              Text(
                helper,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: ManahSpacing.md),
        IconButton.filledTonal(
          tooltip: 'Kurangi $label',
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove_rounded),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48),
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Tambah $label',
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add_rounded),
        ),
      ],
    );
  }
}

class TargetFaceSelector extends StatelessWidget {
  const TargetFaceSelector({
    super.key,
    required this.targets,
    required this.selected,
    required this.onTap,
    required this.onRetry,
  });

  final AsyncValue<List<TargetFaceEntity>> targets;
  final TargetFaceEntity? selected;
  final VoidCallback onTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return targets.when(
      skipLoadingOnRefresh: true,
      loading: () => const _TargetFaceSkeleton(),
      error: (_, __) => _TargetFaceState(
        icon: Icons.cloud_off_outlined,
        title: 'Target belum bisa dimuat.',
        message: 'Periksa koneksi atau coba gunakan data lokal lagi.',
        actionLabel: 'Coba lagi',
        onAction: onRetry,
      ),
      data: (items) {
        if (items.isEmpty) {
          return _TargetFaceState(
            icon: Icons.adjust_rounded,
            title: 'Belum ada target tersimpan.',
            message:
                'Muat daftar target sekali agar bisa dipakai saat offline.',
            actionLabel: 'Muat target',
            onAction: onRetry,
          );
        }

        return _TargetFaceData(
          selected: selected,
          onTap: onTap,
        );
      },
    );
  }
}

class _TargetFaceSkeleton extends StatelessWidget {
  const _TargetFaceSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Memuat target',
      child: DecoratedBox(
        key: const ValueKey('target-loading-skeleton'),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          border: Border.all(color: colors.outlineVariant),
          borderRadius: const BorderRadius.all(
            Radius.circular(ManahRadius.md),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(ManahSpacing.base),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(dimension: 56),
              ),
              const SizedBox(width: ManahSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: ManahSpacing.base,
                      color: colors.surfaceContainerHighest,
                    ),
                    const SizedBox(height: ManahSpacing.sm),
                    FractionallySizedBox(
                      widthFactor: 0.64,
                      child: Container(
                        height: ManahSpacing.md,
                        color: colors.surfaceContainerHigh,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TargetFaceState extends StatelessWidget {
  const _TargetFaceState({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: const BorderRadius.all(
          Radius.circular(ManahRadius.md),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.base),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colors.onSurfaceVariant),
            const SizedBox(width: ManahSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: ManahSpacing.xs),
                  Text(
                    message,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: ManahSpacing.sm),
                  TextButton(
                    onPressed: onAction,
                    child: Text(actionLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetFaceData extends StatelessWidget {
  const _TargetFaceData({
    required this.selected,
    required this.onTap,
  });

  final TargetFaceEntity? selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final target = selected;

    return Material(
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(ManahRadius.md),
        ),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: InkWell(
        key: const ValueKey('target-face-selector'),
        onTap: onTap,
        borderRadius: const BorderRadius.all(
          Radius.circular(ManahRadius.md),
        ),
        child: Padding(
          padding: const EdgeInsets.all(ManahSpacing.base),
          child: Row(
            children: [
              SizedBox.square(
                dimension: 56,
                child: target == null
                    ? DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.adjust_rounded,
                          color: colors.onSurfaceVariant,
                        ),
                      )
                    : TargetFacePreview(
                        code: target.code,
                        imagePath: target.imagePath,
                      ),
              ),
              const SizedBox(width: ManahSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      target?.name ?? 'Pilih target',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: ManahSpacing.xs),
                    Text(
                      target?.organizationName ??
                          'Tentukan target dan aturan nilainya.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: ManahSpacing.sm),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubscriptionUsageNotice extends StatelessWidget {
  const SubscriptionUsageNotice({
    super.key,
    required this.used,
    required this.limit,
    required this.isGated,
    required this.onUpgrade,
  });

  final int used;
  final int limit;
  final bool isGated;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final background =
        isGated ? colors.errorContainer : colors.primaryContainer;
    final foreground =
        isGated ? colors.onErrorContainer : colors.onPrimaryContainer;

    return Material(
      color: background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(ManahRadius.md)),
      ),
      child: InkWell(
        onTap: isGated ? onUpgrade : null,
        borderRadius: const BorderRadius.all(
          Radius.circular(ManahRadius.md),
        ),
        child: Padding(
          padding: const EdgeInsets.all(ManahSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isGated
                    ? Icons.lock_outline_rounded
                    : Icons.info_outline_rounded,
                color: foreground,
              ),
              const SizedBox(width: ManahSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$used dari $limit sesi minggu ini',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: foreground,
                      ),
                    ),
                    const SizedBox(height: ManahSpacing.xs),
                    Text(
                      isGated
                          ? 'Batas paket gratis tercapai. Buka Premium untuk lanjut.'
                          : 'Sesi tersimpan lokal dan disinkronkan saat online.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: foreground,
                      ),
                    ),
                  ],
                ),
              ),
              if (isGated) Icon(Icons.chevron_right_rounded, color: foreground),
            ],
          ),
        ),
      ),
    );
  }
}

class SessionActionBar extends StatelessWidget {
  const SessionActionBar({
    super.key,
    required this.bowClass,
    required this.distance,
    required this.environment,
    required this.countedArrows,
    required this.sighterArrows,
    required this.canStart,
    required this.isStarting,
    required this.isGated,
    required this.errorMessage,
    required this.onPressed,
  });

  final BowClass bowClass;
  final DistanceCategory distance;
  final ArcheryEnvironment environment;
  final int countedArrows;
  final int sighterArrows;
  final bool canStart;
  final bool isStarting;
  final bool isGated;
  final String? errorMessage;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final helper = errorMessage ??
        (canStart || isGated ? null : 'Pilih target untuk mulai');

    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          border: Border(top: BorderSide(color: colors.outlineVariant)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            ManahSpacing.base,
            ManahSpacing.md,
            ManahSpacing.base,
            ManahSpacing.base,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                key: const ValueKey('session-live-summary'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.my_location_rounded, color: colors.primary),
                  const SizedBox(width: ManahSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${distance.label} · ${bowClass.label} · ${environment.label}',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: ManahSpacing.xs),
                        Text(
                          sighterArrows > 0
                              ? '$countedArrows panah dihitung · $sighterArrows percobaan'
                              : '$countedArrows panah dihitung',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (helper != null) ...[
                const SizedBox(height: ManahSpacing.sm),
                Text(
                  helper,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: errorMessage == null
                        ? colors.onSurfaceVariant
                        : colors.error,
                  ),
                ),
              ],
              const SizedBox(height: ManahSpacing.md),
              FilledButton.icon(
                key: const ValueKey('start-scoring-button'),
                onPressed: isStarting ? null : onPressed,
                icon: isStarting
                    ? SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.onPrimary,
                        ),
                      )
                    : Icon(
                        isGated
                            ? Icons.workspace_premium_outlined
                            : Icons.arrow_forward_rounded,
                      ),
                label: Text(isGated ? 'Buka Premium' : 'Mulai sesi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TargetFacePreview extends StatelessWidget {
  const TargetFacePreview({
    super.key,
    required this.code,
    this.imagePath,
  });

  final String code;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final path = imagePath;
    if (path != null && path.isNotEmpty) {
      if (path.startsWith('http://') || path.startsWith('https://')) {
        return AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            path,
            fit: BoxFit.contain,
            cacheWidth: 128,
            cacheHeight: 128,
            loadingBuilder: (context, child, progress) {
              return progress == null ? child : _TargetFaceFallback(code: code);
            },
            errorBuilder: (_, __, ___) => _TargetFaceFallback(code: code),
          ),
        );
      }
      if (path.startsWith('assets/')) {
        return AspectRatio(
          aspectRatio: 1,
          child: Image.asset(
            path,
            fit: BoxFit.contain,
            cacheWidth: 128,
            cacheHeight: 128,
            errorBuilder: (_, __, ___) => _TargetFaceFallback(code: code),
          ),
        );
      }
    }

    return _TargetFaceFallback(code: code);
  }
}

class _TargetFaceFallback extends StatelessWidget {
  const _TargetFaceFallback({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(painter: _TargetFacePainter(code)),
    );
  }
}

class _TargetFacePainter extends CustomPainter {
  _TargetFacePainter(this.code);

  final String code;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    if (code.startsWith('fita_')) {
      _paintFita(canvas, center, radius);
      return;
    }
    if (code == 'jemparingan') {
      _paintJemparingan(canvas, size);
      return;
    }
    if (code == 'las_vegas_3spot') {
      _paintThreeSpot(canvas, size, radius);
      return;
    }

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = ManahColors.targetGold
        ..style = PaintingStyle.fill,
    );
  }

  void _paintFita(Canvas canvas, Offset center, double radius) {
    final paint = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..color = ManahColors.targetOutline
      ..strokeWidth = 0.5;
    const colors = [
      ManahColors.targetWhite,
      ManahColors.targetBlack,
      ManahColors.targetBlue,
      ManahColors.targetRed,
      ManahColors.targetGold,
    ];

    for (var index = 0; index < colors.length; index++) {
      paint.color = colors[index];
      final ringRadius = radius * (1 - index * 0.2);
      canvas.drawCircle(center, ringRadius, paint);
      canvas.drawCircle(center, ringRadius, stroke);
    }
  }

  void _paintJemparingan(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final capHeight = size.height * 0.25;

    paint.color = ManahColors.targetRed;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(size.width * 0.35, 0, size.width * 0.3, capHeight),
        topLeft: Radius.circular(size.width * 0.15),
        topRight: Radius.circular(size.width * 0.15),
      ),
      paint,
    );

    paint.color = ManahColors.targetWhite;
    final body = Rect.fromLTWH(
      size.width * 0.35,
      capHeight,
      size.width * 0.3,
      size.height * 0.7,
    );
    canvas.drawRect(body, paint);
    canvas.drawRect(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = ManahColors.targetOutline
        ..strokeWidth = 1,
    );
  }

  void _paintThreeSpot(Canvas canvas, Size size, double radius) {
    final paint = Paint()..style = PaintingStyle.fill;
    final spotRadius = radius * 0.3;
    final spots = [
      Offset(size.width * 0.5, size.height * 0.28),
      Offset(size.width * 0.25, size.height * 0.7),
      Offset(size.width * 0.75, size.height * 0.7),
    ];
    const colors = [
      ManahColors.targetBlue,
      ManahColors.targetRed,
      ManahColors.targetGold,
    ];

    for (final spotCenter in spots) {
      for (var index = 0; index < colors.length; index++) {
        paint.color = colors[index];
        canvas.drawCircle(
          spotCenter,
          spotRadius * (1 - index * 0.33),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TargetFacePainter oldDelegate) {
    return oldDelegate.code != code;
  }
}
