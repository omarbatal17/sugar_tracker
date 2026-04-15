import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';
import '../constants/colors.dart';
import '../models/user_profile.dart';
import '../widgets/form_input.dart';
import '../widgets/keyboard_aware_scroll_view_compat.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _targetMinController;
  late TextEditingController _targetMaxController;
  String _diabetesType = 'type1';

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _ageController = TextEditingController(text: (user?.age ?? 28).toString());
    _targetMinController = TextEditingController(text: (user?.targetRangeMin ?? 80).toString());
    _targetMaxController = TextEditingController(text: (user?.targetRangeMax ?? 180).toString());
    _diabetesType = user?.diabetesType ?? 'type1';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _targetMinController.dispose();
    _targetMaxController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final appState = context.read<AppState>();
    final tr = AppTranslation(appState.language);

    final profile = UserProfile(
      name: _nameController.text.trim(),
      email: appState.user?.email ?? 'user@example.com',
      age: int.tryParse(_ageController.text) ?? 28,
      diabetesType: _diabetesType,
      targetRangeMin: int.tryParse(_targetMinController.text) ?? 80,
      targetRangeMax: int.tryParse(_targetMaxController.text) ?? 180,
    );

    await appState.setUser(profile);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr.t('profileUpdated'))),
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

    final types = [
      {'key': 'type1', 'label': tr.t('type1')},
      {'key': 'type2', 'label': tr.t('type2')},
      {'key': 'gestational', 'label': tr.t('gestational')},
      {'key': 'prediabetes', 'label': tr.t('prediabetes')},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(tr.t('editProfile'))),
      body: KeyboardAwareScrollViewCompat(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormInput(label: tr.t('fullName'), controller: _nameController),
            const SizedBox(height: 16),
            FormInput(label: tr.t('age'), controller: _ageController, keyboardType: TextInputType.number),
            const SizedBox(height: 16),

            Text(tr.t('diabetesType'), style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: types.map((t) {
                final isSelected = _diabetesType == t['key'];
                return GestureDetector(
                  onTap: () => setState(() => _diabetesType = t['key']!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? palette.primary : palette.surfaceInput,
                      borderRadius: BorderRadius.circular(AppColors.badgeRadius),
                      border: Border.all(color: isSelected ? palette.primary : palette.border),
                    ),
                    child: Text(
                      t['label']!,
                      style: TextStyle(
                        color: isSelected ? palette.primaryForeground : palette.text,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            FormInput(label: tr.t('targetMin'), controller: _targetMinController, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            FormInput(label: tr.t('targetMax'), controller: _targetMaxController, keyboardType: TextInputType.number),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: AppColors.inputHeight,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(tr.t('save')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
