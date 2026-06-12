import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../providers/recording_provider.dart';
import '../widgets/bottom_nav_shell.dart';

class _BackAppBar extends StatelessWidget {
  final String title;
  const _BackAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 20, right: 20),
      color: AppColors.surface,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.read<RecordingProvider>().cancelRecording();
              context.go(AppRoutes.footSelection);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back,
                  size: 20, color: AppColors.onSurface),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: AppText.headlineSm)),
        ],
      ),
    );
  }
}

class RecordingPage extends StatelessWidget {
  const RecordingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecordingProvider>();
    final footLabel = provider.selectedFootSide == 'right'
        ? 'Right Foot'
        : 'Left Foot';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _BackAppBar(title: 'Recording: $footLabel'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.marginMobile),
              child: Column(
                children: [
                  const SizedBox(height: AppTheme.lg),
                  // Circular timer (counts up while recording)
                  _TimerRing(
                    elapsedSeconds: provider.elapsedSeconds,
                    recommendedSeconds:
                        RecordingProvider.recommendedSeconds,
                    isRecording: provider.isRecording,
                  ),
                  const SizedBox(height: AppTheme.xl),
                  // Sensor status grid
                  _SensorStatusGrid(samplingRateHz: provider.samplingRateHz),
                  const SizedBox(height: AppTheme.xl),
                  // Recording controls
                  if (provider.isRecording) ...[
                    _PulseButton(
                      onTap: () {
                        provider.finishRecording();
                        context.go(AppRoutes.processing);
                      },
                    ),
                    const SizedBox(height: AppTheme.lg),
                    GestureDetector(
                      onTap: () {
                        provider.cancelRecording();
                        context.go(AppRoutes.footSelection);
                      },
                      child: Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: AppTheme.radiusFull,
                          border: Border.all(
                              color: AppColors.error, width: 1.5),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppText.labelMd
                              .copyWith(color: AppColors.error),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ] else
                    GestureDetector(
                      onTap: () => provider.startRecording(),
                      child: Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppTheme.radiusFull,
                          boxShadow: AppTheme.primaryShadow,
                        ),
                        child: Text(
                          'Start Recording',
                          style: AppText.labelMd
                              .copyWith(color: AppColors.onPrimary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  const SizedBox(height: AppTheme.lg),
                  // Safety note
                  Container(
                    padding: const EdgeInsets.all(AppTheme.md),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryContainer.withAlpha(80),
                      borderRadius: AppTheme.radiusDefault,
                      border: Border(
                        left: BorderSide(
                            color: AppColors.tertiary, width: 4),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.health_and_safety_outlined,
                            color: AppColors.tertiary, size: 20),
                        const SizedBox(width: AppTheme.sm),
                        Expanded(
                          child: Text(
                            'Walk naturally on a flat surface. Have someone nearby for support.',
                            style: AppText.bodySm,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(activePage: 'record'),
    );
  }
}

class _TimerRing extends StatelessWidget {
  final int elapsedSeconds;
  final int recommendedSeconds;
  final bool isRecording;

  const _TimerRing({
    required this.elapsedSeconds,
    required this.recommendedSeconds,
    required this.isRecording,
  });

  String get _timeLabel {
    final mins = elapsedSeconds ~/ 60;
    final secs = elapsedSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        (elapsedSeconds / recommendedSeconds).clamp(0.0, 1.0);

    return SizedBox(
      width: 264,
      height: 264,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(264, 264),
            painter: _RingPainter(
              progress: progress,
              isActive: isRecording,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _timeLabel,
                style: AppText.dataXl.copyWith(
                  color: isRecording
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                isRecording ? 'Recording...' : 'Ready',
                style: AppText.labelSm,
              ),
              if (isRecording) ...[
                const SizedBox(height: 2),
                Text(
                  elapsedSeconds < recommendedSeconds
                      ? 'Keep walking · ${recommendedSeconds}s+ recommended'
                      : 'You can finish anytime',
                  style: AppText.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('LIVE',
                        style: AppText.labelSm
                            .copyWith(color: AppColors.error)),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final bool isActive;

  const _RingPainter({required this.progress, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;

    // Background ring
    final bgPaint = Paint()
      ..color = AppColors.surfaceContainerHighest
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = isActive ? AppColors.primaryContainer : AppColors.outlineVariant
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.isActive != isActive;
}

class _SensorStatusGrid extends StatelessWidget {
  final int samplingRateHz;
  const _SensorStatusGrid({required this.samplingRateHz});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppTheme.radiusDefault,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(26)),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sensor Status', style: AppText.labelMd),
          const SizedBox(height: AppTheme.md),
          Row(
            children: [
              Expanded(
                  child: _SensorItem(
                      label: 'Accelerometer', status: 'Active')),
              Expanded(
                  child:
                      _SensorItem(label: 'Gyroscope', status: 'Active')),
            ],
          ),
          const SizedBox(height: AppTheme.sm),
          _SamplingRateItem(samplingRateHz: samplingRateHz),
        ],
      ),
    );
  }
}

class _SensorItem extends StatelessWidget {
  final String label;
  final String status;
  const _SensorItem({required this.label, required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.labelSm),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(status,
                style: AppText.labelSm
                    .copyWith(color: AppColors.primary)),
          ],
        ),
      ],
    );
  }
}

class _SamplingRateItem extends StatelessWidget {
  final int samplingRateHz;
  const _SamplingRateItem({required this.samplingRateHz});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Sampling Rate', style: AppText.labelSm),
        Row(
          children: [
            Text('$samplingRateHz Hz',
                style: AppText.dataViz
                    .copyWith(color: AppColors.primary)),
            const SizedBox(width: 8),
            // Mini bar chart
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                5,
                (i) => Container(
                  width: 4,
                  height: 8.0 + (i % 3) * 4,
                  margin: const EdgeInsets.only(left: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withAlpha(200),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PulseButton extends StatefulWidget {
  final VoidCallback onTap;
  const _PulseButton({required this.onTap});

  @override
  State<_PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<_PulseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Tap to finish recording',
            style: AppText.labelSm),
        const SizedBox(height: AppTheme.md),
        AnimatedBuilder(
          animation: _scaleAnim,
          builder: (_, child) => Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          ),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withAlpha(100),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.stop,
                  color: AppColors.onError, size: 36),
            ),
          ),
        ),
      ],
    );
  }
}
