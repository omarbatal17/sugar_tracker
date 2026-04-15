import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';
import '../widgets/form_input.dart';
import '../widgets/keyboard_aware_scroll_view_compat.dart';
import '../constants/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;
  String? _generalError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validate(AppTranslation tr) {
    bool valid = true;
    setState(() {
      _emailError = null;
      _passwordError = null;
      _generalError = null;
    });

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

    setState(() {});
    return valid;
  }

  Future<void> _login() async {
    final appState = context.read<AppState>();
    final tr = AppTranslation(appState.language);

    if (!_validate(tr)) return;

    setState(() => _isLoading = true);

    try {
      await appState.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr.t('loginSuccess'))),
        );
        context.go('/tabs/dashboard');
      }
    } catch (e) {
      setState(() {
        _generalError = tr.t('invalidCredentials');
        _isLoading = false;
      });
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
      body: KeyboardAwareScrollViewCompat(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            // Logo
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: palette.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.monitor_heart_outlined, size: 40, color: palette.primary),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Smart Diabetes Care',
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                tr.t('login'),
                style: theme.textTheme.bodyMedium?.copyWith(color: palette.mutedForeground),
              ),
            ),
            const SizedBox(height: 40),

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
            const SizedBox(height: 8),

            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => context.push('/forgot-password'),
                child: Text(
                  tr.t('forgotPassword'),
                  style: TextStyle(color: palette.primary, fontSize: 13),
                ),
              ),
            ),

            if (_generalError != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: palette.destructive.withAlpha(20),
                  borderRadius: BorderRadius.circular(AppColors.iconPillRadius),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, size: 18, color: palette.destructive),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _generalError!,
                        style: TextStyle(color: palette.destructive, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: AppColors.inputHeight,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: palette.primaryForeground,
                        ),
                      )
                    : Text(tr.t('login')),
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tr.t('dontHaveAccount'),
                    style: theme.textTheme.bodySmall,
                  ),
                  TextButton(
                    onPressed: () => context.push('/register'),
                    child: Text(
                      tr.t('register'),
                      style: TextStyle(
                        color: palette.primary,
                        fontWeight: FontWeight.w600,
                      ),
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
