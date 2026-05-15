import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dummy_data.dart';
import '../../data/services/api_service.dart';
import '../providers/session_provider.dart';
import '../providers/recording_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/bottom_nav_shell.dart';

class ProcessingPage extends StatefulWidget {
  const ProcessingPage({super.key});

  @override
  State<ProcessingPage> createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  late AnimationController _waveController;

  static const List<String> _steps = [
    'Validating sensor data',
    'Calculating FreeAcc',
    'Detecting gait events',
    'Calculating semiogram',
    'Predicting FMA-LE',
    'Saving result',
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _runSteps();
  }

  void _runSteps() {
    // Cosmetic step animation while the real backend call runs.
    for (int i = 0; i < _steps.length; i++) {
      Future.delayed(Duration(milliseconds: 500 + i * 600), () {
        if (mounted && _currentStep < i + 1) {
          setState(() => _currentStep = i + 1);
        }
      });
    }
    _analyze();
  }

  Future<void> _analyze() async {
    final recording = context.read<RecordingProvider>();
    final profile = context.read<ProfileProvider>().profile;
    final session = context.read<SessionProvider>();
    final messenger = ScaffoldMessenger.of(context);

    var result = dummyResult;
    String? error;
    try {
      result = await ApiService().analyzeGaitSession(
        timeseries: recording.recordedData,
        profile: profile,
        samplingRateHz: recording.samplingRateHz,
      );
    } on ApiException catch (e) {
      error = e.message;
    } catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    // Let the step animation breathe a little before navigating.
    if (_currentStep < _steps.length) {
      setState(() => _currentStep = _steps.length);
    }
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    session.setResult(result);
    if (error != null) {
      messenger.showSnackBar(SnackBar(
        content: Text(
            'Backend unavailable — showing sample result. $error'),
        duration: const Duration(seconds: 4),
      ));
    }
    context.go(AppRoutes.result);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.marginMobile),
          child: Column(
            children: [
              const SizedBox(height: AppTheme.xl),
              // Hero wave animation
              _WaveHero(controller: _waveController),
              const SizedBox(height: AppTheme.xl),
              Text('Processing Your Gait Data',
                  style: AppText.headlineMd,
                  textAlign: TextAlign.center),
              const SizedBox(height: AppTheme.sm),
              Text(
                'Our AI is analyzing your movement patterns.\nThis may take a moment.',
                style: AppText.bodyMd
                    .copyWith(color: AppColors.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.xl),
              // Steps card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: AppTheme.radiusDefault,
                  border: Border.all(
                      color: AppColors.outlineVariant.withAlpha(26)),
                  boxShadow: AppTheme.cardShadow,
                ),
                padding: const EdgeInsets.all(AppTheme.lg),
                child: Column(
                  children: List.generate(
                    _steps.length,
                    (i) => _StepTile(
                      label: _steps[i],
                      state: i < _currentStep
                          ? _StepState.done
                          : i == _currentStep
                              ? _StepState.active
                              : _StepState.pending,
                      isLast: i == _steps.length - 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.lg),
              // Tip chip
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.md, vertical: AppTheme.sm),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withAlpha(26),
                  borderRadius: AppTheme.radiusFull,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lightbulb_outline,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text('Keep your phone steady during processing',
                        style: AppText.labelSm
                            .copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(activePage: 'record'),
    );
  }
}

class _WaveHero extends StatelessWidget {
  final AnimationController controller;
  const _WaveHero({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 192,
      height: 192,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing rings
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) => Stack(
              alignment: Alignment.center,
              children: [
                _PulseRing(
                    scale: 1.0 + controller.value * 0.3,
                    opacity: 1.0 - controller.value),
                _PulseRing(
                    scale: 1.0 + ((controller.value + 0.5) % 1.0) * 0.3,
                    opacity: 1.0 - (controller.value + 0.5) % 1.0),
              ],
            ),
          ),
          // Core circle
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryContainer],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.analytics_outlined,
              size: 48,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseRing extends StatelessWidget {
  final double scale;
  final double opacity;
  const _PulseRing({required this.scale, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryContainer.withAlpha((opacity * 100).toInt()),
            width: 2,
          ),
        ),
      ),
    );
  }
}

enum _StepState { done, active, pending }

class _StepTile extends StatelessWidget {
  final String label;
  final _StepState state;
  final bool isLast;

  const _StepTile({
    required this.label,
    required this.state,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconBg = switch (state) {
      _StepState.done => AppColors.primaryContainer,
      _StepState.active => AppColors.primary,
      _StepState.pending => AppColors.surfaceContainerHighest,
    };
    final Color textColor = switch (state) {
      _StepState.done => AppColors.onSurface,
      _StepState.active => AppColors.primary,
      _StepState.pending => AppColors.onSurfaceVariant,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: state == _StepState.done
                  ? const Icon(Icons.check,
                      size: 16, color: AppColors.onPrimaryContainer)
                  : state == _StepState.active
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.onPrimary),
                            ),
                          ),
                        )
                      : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 24,
                color: state == _StepState.done
                    ? AppColors.primaryContainer
                    : AppColors.outlineVariant.withAlpha(80),
              ),
          ],
        ),
        const SizedBox(width: AppTheme.sm),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                top: 6, bottom: isLast ? 0 : AppTheme.sm),
            child: Text(label,
                style: AppText.labelMd.copyWith(color: textColor)),
          ),
        ),
      ],
    );
  }
}
