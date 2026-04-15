import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';
import '../constants/colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;

    final faqs = [
      {'q': tr.t('faq1Question'), 'a': tr.t('faq1Answer')},
      {'q': tr.t('faq2Question'), 'a': tr.t('faq2Answer')},
      {'q': tr.t('faq3Question'), 'a': tr.t('faq3Answer')},
      {'q': tr.t('faq4Question'), 'a': tr.t('faq4Answer')},
      {'q': tr.t('faq5Question'), 'a': tr.t('faq5Answer')},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(tr.t('helpSupport'))),
      body: ListView(
        padding: const EdgeInsets.all(AppColors.screenHorizontalPadding),
        children: [
          // Emergency Disclaimer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.destructive.withAlpha(15),
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              border: Border.all(color: palette.destructive.withAlpha(60)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(FeatherIcons.alertOctagon, size: 22, color: palette.destructive),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr.t('emergencyDisclaimer'),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: palette.destructive,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tr.t('emergencyDisclaimerText'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: palette.destructive,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Smart Assistant CTA
          GestureDetector(
            onTap: () => context.push('/chatbot'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [palette.primary, palette.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppColors.cardRadius),
                boxShadow: [
                  BoxShadow(
                    color: palette.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(FeatherIcons.messageCircle, size: 24, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr.t('chatbot'),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tr.t('chatbotHint'),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(FeatherIcons.chevronRight, size: 20, color: Colors.white),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // FAQ
          Text(tr.t('faq'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          ...faqs.map((faq) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
            ),
            child: Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                title: Text(
                  faq['q']!,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                children: [
                  Text(
                    faq['a']!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: palette.mutedForeground,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          )),

          const SizedBox(height: 24),

          // Contact Support
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
            ),
            child: Row(
              children: [
                Icon(FeatherIcons.mail, size: 20, color: palette.primary),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr.t('contactSupport'), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      Text('support@smartdiabetescare.app', style: theme.textTheme.bodySmall?.copyWith(color: palette.primary)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // About
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr.t('aboutApp'), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(tr.t('appDescription'), style: theme.textTheme.bodySmall?.copyWith(color: palette.mutedForeground, height: 1.5)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('${tr.t('version')}: ', style: theme.textTheme.bodySmall?.copyWith(color: palette.mutedForeground)),
                    Text('1.0.0', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
