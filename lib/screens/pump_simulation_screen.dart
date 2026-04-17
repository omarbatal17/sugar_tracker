import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';
import '../constants/colors.dart';
import '../models/pump_simulation.dart';
import '../widgets/section_header.dart';

class PumpSimulationScreen extends StatefulWidget {
  const PumpSimulationScreen({super.key});

  @override
  State<PumpSimulationScreen> createState() => _PumpSimulationScreenState();
}

class _PumpSimulationScreenState extends State<PumpSimulationScreen> {
  final _glucoseController = TextEditingController(text: '150');
  final _manualDoseController = TextEditingController();
  double _sensitivityFactor = 50.0;
  double _slideValue = 0;
  bool _confirmed = false;

  int get _glucose => int.tryParse(_glucoseController.text) ?? 0;
  double get _suggestedDose => _glucose > 100 ? (_glucose - 100) / _sensitivityFactor : 0;

  @override
  void dispose() {
    _glucoseController.dispose();
    _manualDoseController.dispose();
    super.dispose();
  }

  Future<void> _confirmSimulation() async {
    final appState = context.read<AppState>();
    final tr = AppTranslation(appState.language);

    final manualDose = double.tryParse(_manualDoseController.text) ?? _suggestedDose;

    final sim = PumpSimulationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString() + Random().nextDouble().toString(),
      currentGlucose: _glucose,
      suggestedDose: double.parse(_suggestedDose.toStringAsFixed(1)),
      manualDose: double.parse(manualDose.toStringAsFixed(1)),
      timestamp: DateTime.now().toIso8601String(),
      confirmed: true,
    );

    await appState.addPumpSimulation(sim);

    if (mounted) {
      setState(() => _confirmed = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr.t('simulationConfirmed'))),
      );
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
      appBar: AppBar(title: Text(tr.t('pumpSimulation'))),
      body: ListView(
        padding: const EdgeInsets.all(AppColors.screenHorizontalPadding),
        children: [
          // Disclaimer
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(AppColors.iconPillRadius),
              border: Border.all(color: const Color(0xFFF59E0B).withAlpha(60)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(FeatherIcons.alertTriangle, size: 18, color: Color(0xFFF59E0B)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tr.t('educationalDisclaimer'),
                    style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF92400E), height: 1.4),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Current Glucose
          Text(tr.t('currentGlucose'), style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          TextField(
            controller: _glucoseController,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {
              _confirmed = false;
              _slideValue = 0;
            }),
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              suffix: Text(tr.t('mgdl'), style: theme.textTheme.bodySmall?.copyWith(color: palette.mutedForeground)),
            ),
          ),

          const SizedBox(height: 20),

          // Sensitivity Factor
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tr.t('sensitivityFactor'), style: theme.textTheme.labelLarge),
              Text('${_sensitivityFactor.round()}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          Slider(
            value: _sensitivityFactor,
            min: 10,
            max: 100,
            divisions: 18,
            onChanged: (v) => setState(() {
              _sensitivityFactor = v;
              _confirmed = false;
              _slideValue = 0;
            }),
          ),

          const SizedBox(height: 16),

          // Formula
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: palette.surfaceSoft,
              borderRadius: BorderRadius.circular(AppColors.iconPillRadius),
            ),
            child: Text(
              tr.t('doseFormula'),
              style: theme.textTheme.bodySmall?.copyWith(color: palette.mutedForeground, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),

          // Suggested Dose
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: palette.primaryContainer.withAlpha(60),
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              border: Border.all(color: palette.primary.withAlpha(40)),
            ),
            child: Column(
              children: [
                Text(tr.t('suggestedDose'), style: theme.textTheme.bodySmall?.copyWith(color: palette.mutedForeground)),
                const SizedBox(height: 4),
                Text(
                  '${_suggestedDose.toStringAsFixed(1)} ${tr.t('units')}',
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: palette.primary),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Manual Override
          Text(tr.t('manualDose'), style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          TextField(
            controller: _manualDoseController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: _suggestedDose.toStringAsFixed(1),
              suffix: Text(tr.t('units'), style: theme.textTheme.bodySmall?.copyWith(color: palette.mutedForeground)),
            ),
          ),

          const SizedBox(height: 28),

          // Slide to Confirm
          if (!_confirmed) ...[
            Text(tr.t('slideToConfirm'), style: theme.textTheme.labelMedium?.copyWith(color: palette.mutedForeground), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: palette.surfaceInput,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: palette.border),
              ),
              child: Stack(
                children: [
                  // Fill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: MediaQuery.of(context).size.width * _slideValue * 0.85,
                    decoration: BoxDecoration(
                      color: palette.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  // Slider
                  SliderTheme(
                    data: SliderThemeData(
                      thumbColor: palette.primary,
                      activeTrackColor: Colors.transparent,
                      inactiveTrackColor: Colors.transparent,
                      overlayColor: palette.primary.withAlpha(20),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 22),
                    ),
                    child: Slider(
                      value: _slideValue,
                      onChanged: (v) => setState(() => _slideValue = v),
                      onChangeEnd: (v) {
                        if (v > 0.85) {
                          _confirmSimulation();
                        } else {
                          setState(() => _slideValue = 0);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ] else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.statusColors('normal', isDark).background,
                borderRadius: BorderRadius.circular(AppColors.iconPillRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FeatherIcons.checkCircle, color: AppColors.statusColors('normal', isDark).foreground),
                  const SizedBox(width: 8),
                  Text(
                    tr.t('simulationConfirmed'),
                    style: TextStyle(color: AppColors.statusColors('normal', isDark).foreground, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 32),

          // History
          if (appState.pumpHistory.isNotEmpty) ...[
            SectionHeader(title: tr.t('simulationHistory')),
            const SizedBox(height: 8),
            ...appState.pumpHistory.take(5).map((sim) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: palette.card,
                borderRadius: BorderRadius.circular(AppColors.iconPillRadius),
                border: Border.all(color: palette.border.withAlpha(80), width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${sim.currentGlucose} ${tr.t('mgdl')}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      Text('${sim.manualDose} ${tr.t('units')}', style: theme.textTheme.bodySmall?.copyWith(color: palette.mutedForeground)),
                    ],
                  ),
                  Text(tr.relativeTime(sim.timestamp), style: theme.textTheme.labelSmall?.copyWith(color: palette.mutedForeground)),
                ],
              ),
            )),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
