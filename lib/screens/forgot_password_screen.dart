import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';
import '../widgets/form_input.dart';
import '../widgets/keyboard_aware_scroll_view_compat.dart';
import '../constants/colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String? _emailError;
  bool _isLoading = false;
  bool _isSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    final appState = context.read<AppState>();
    final tr = AppTranslation(appState.language);

    setState(() => _emailError = null);

    if (_emailController.text.trim().isEmpty) {
      setState(() => _emailError = tr.t('emailRequired'));
      return;
    }
    if (!_emailController.text.contains('@')) {
      setState(() => _emailError = tr.t('emailInvalid'));
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isSent = true;
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
              tr.t('forgotPasswordTitle'),
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              tr.t('forgotPasswordDesc'),
              style: theme.textTheme.bodyMedium?.copyWith(color: palette.mutedForeground),
            ),
            const SizedBox(height: 32),

            if (_isSent)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.statusColors('normal', isDark).background,
                  borderRadius: BorderRadius.circular(AppColors.iconPillRadius),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.statusColors('normal', isDark).foreground),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tr.t('resetLinkSent'),
                        style: TextStyle(
                          color: AppColors.statusColors('normal', isDark).foreground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              FormInput(
                label: tr.t('email'),
                hintText: 'user@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: AppColors.inputHeight,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendResetLink,
                  child: _isLoading
                      ? SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: palette.primaryForeground,
                          ),
                        )
                      : Text(tr.t('sendResetLink')),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
