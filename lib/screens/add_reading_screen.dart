import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';
import '../constants/colors.dart';
import '../models/glucose_reading.dart';
import '../widgets/form_input.dart';
import '../widgets/status_badge.dart';
import '../widgets/keyboard_aware_scroll_view_compat.dart';

class AddReadingScreen extends StatefulWidget {
  const AddReadingScreen({super.key});

  @override
  State<AddReadingScreen> createState() => _AddReadingScreenState();
}

class _AddReadingScreenState extends State<AddReadingScreen> {
  final _valueController = TextEditingController();
  final _noteController = TextEditingController();
  String? _mealContext;
  String? _valueError;
  String? _mealError;

  int get _currentValue => int.tryParse(_valueController.text) ?? 0;
  String get _currentStatus => GlucoseReading.computeStatus(_currentValue);

  @override
  void dispose() {
    _valueController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final appState = context.read<AppState>();
    final tr = AppTranslation(appState.language);

    setState(() {
      _valueError = null;
      _mealError = null;
    });

    bool valid = true;

    if (_valueController.text.trim().isEmpty) {
      _valueError = tr.t('valueRequired');
      valid = false;
    } else {
      final v = int.tryParse(_valueController.text);
      if (v == null || v < 1 || v > 600) {
        _valueError = tr.t('valueInvalid');
        valid = false;
      }
    }

    if (_mealContext == null) {
      _mealError = tr.t('mealContextRequired');
      valid = false;
    }

    setState(() {});
    if (!valid) return;

    final value = int.parse(_valueController.text);
    final reading = GlucoseReading(
      id: DateTime.now().millisecondsSinceEpoch.toString() + Random().nextDouble().toString(),
      value: value,
      status: GlucoseReading.computeStatus(value),
      timestamp: DateTime.now().toIso8601String(),
      mealContext: _mealContext!,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    await appState.addReading(reading);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr.t('readingAdded'))),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;

    final mealOptions = [
      {'key': 'before', 'label': tr.t('beforeMeal'), 'icon': FeatherIcons.sunrise},
      {'key': 'after', 'label': tr.t('afterMeal'), 'icon': FeatherIcons.sun},
      {'key': 'fasting', 'label': tr.t('fasting'), 'icon': FeatherIcons.moon},
      {'key': 'bedtime', 'label': tr.t('bedtime'), 'icon': FeatherIcons.cloudDrizzle},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.t('addReading')),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: KeyboardAwareScrollViewCompat(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Value input
            FormInput(
              label: tr.t('bloodSugarValue'),
              hintText: tr.t('enterValue'),
              controller: _valueController,
              keyboardType: TextInputType.number,
              errorText: _valueError,
              onChanged: (_) => setState(() {}),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(tr.t('mgdl'), style: TextStyle(color: palette.mutedForeground)),
              ),
            ),

            // Live status preview
            if (_currentValue > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.statusColors(_currentStatus, isDark).background,
                  borderRadius: BorderRadius.circular(AppColors.iconPillRadius),
                ),
                child: Row(
                  children: [
                    StatusBadge(status: _currentStatus),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tr.t('status${_currentStatus[0].toUpperCase()}${_currentStatus.substring(1)}Hint'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.statusColors(_currentStatus, isDark).foreground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Meal context
            Text(
              tr.t('mealContext'),
              style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            if (_mealError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(_mealError!, style: TextStyle(color: palette.destructive, fontSize: 12)),
              ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: mealOptions.map((option) {
                final isSelected = _mealContext == option['key'];
                return GestureDetector(
                  onTap: () => setState(() => _mealContext = option['key'] as String),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? palette.primary : palette.surfaceInput,
                      borderRadius: BorderRadius.circular(AppColors.badgeRadius),
                      border: Border.all(
                        color: isSelected ? palette.primary : palette.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          option['icon'] as IconData,
                          size: 16,
                          color: isSelected ? palette.primaryForeground : palette.text,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          option['label'] as String,
                          style: TextStyle(
                            color: isSelected ? palette.primaryForeground : palette.text,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Note
            FormInput(
              label: tr.t('note'),
              hintText: tr.t('addNotePlaceholder'),
              controller: _noteController,
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              height: AppColors.inputHeight,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(tr.t('save')),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
