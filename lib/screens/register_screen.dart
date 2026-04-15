import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';
import '../widgets/form_input.dart';
import '../widgets/keyboard_aware_scroll_view_compat.dart';
import '../constants/colors.dart';
import '../models/user_profile.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _nameError, _emailError, _passwordError, _confirmPasswordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validate(AppTranslation tr) {
    bool valid = true;
    setState(() {
      _nameError = _emailError = _passwordError = _confirmPasswordError = null;
    });

    if (_nameController.text.trim().isEmpty) {
      _nameError = tr.t('nameRequired');
      valid = false;
    }
    if (_emailController.text.trim().isEmpty) {
      _emailError = tr.t('emailRequired');
      valid = false;
    } else if (!_emailController.text.contains('@')) {
      _emailError = tr.t('emailInvalid');
      valid = false;
    }
    if (_passwordController.text.isEmpty) {
      _passwordError = tr.t('passwordRequired');
      valid = false;
    } else if (_passwordController.text.length < 6) {
      _passwordError = tr.t('passwordTooShort');
      valid = false;
    }
    if (_confirmPasswordController.text != _passwordController.text) {
      _confirmPasswordError = tr.t('passwordsDoNotMatch');
      valid = false;
    }

    setState(() {});
    return valid;
  }

  Future<void> _register() async {
    final appState = context.read<AppState>();
    final tr = AppTranslation(appState.language);

    if (!_validate(tr)) return;

    setState(() => _isLoading = true);

    // Simulate 1s delay
    await Future.delayed(const Duration(seconds: 1));

    final profile = UserProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      age: 28,
      diabetesType: 'type1',
      targetRangeMin: 80,
      targetRangeMax: 180,
    );

    await appState.setUser(profile);
    await appState.login(_emailController.text.trim(), _passwordController.text);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr.t('registerSuccess'))),
      );
      context.go('/tabs/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: palette.text),
          onPressed: () => context.pop(),
        ),
      ),
      body: KeyboardAwareScrollViewCompat(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.t('register'),
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 32),

            FormInput(
              label: tr.t('fullName'),
              hintText: tr.t('fullName'),
              controller: _nameController,
              errorText: _nameError,
            ),
            const SizedBox(height: 16),
            FormInput(
              label: tr.t('email'),
              hintText: 'user@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
            ),
            const SizedBox(height: 16),
            FormInput(
              label: tr.t('password'),
              hintText: '••••••',
              controller: _passwordController,
              obscureText: true,
              errorText: _passwordError,
            ),
            const SizedBox(height: 16),
            FormInput(
              label: tr.t('confirmPassword'),
              hintText: '••••••',
              controller: _confirmPasswordController,
              obscureText: true,
              errorText: _confirmPasswordError,
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: AppColors.inputHeight,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: palette.primaryForeground,
                        ),
                      )
                    : Text(tr.t('register')),
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(tr.t('alreadyHaveAccount'), style: theme.textTheme.bodySmall),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      tr.t('login'),
                      style: TextStyle(color: palette.primary, fontWeight: FontWeight.w600),
                    ),
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
