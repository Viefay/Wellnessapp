import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dummy_data.dart';
import '../../data/models/gait_result.dart';
import '../providers/session_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/bottom_nav_shell.dart';
class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionProvider>();
    final result = provider.currentResult ?? dummyResult;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _ResultAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(AppTheme.marginMobile),
              child: Column(
                children: [
                  // Success header
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check,
                        size: 32, color: AppColors.onPrimaryContainer),
                  ),
                  const SizedBox(height: AppTheme.md),
                  Text('Gait Analysis Result',
                      style: AppText.headlineMd,
                      textAlign: TextAlign.center),
                  const SizedBox(height: AppTheme.xl),
                  // Main score card
                  _MainScoreCard(result: result),
                  const SizedBox(height: AppTheme.md),
                  // Classification card
                  _ClassificationCard(result: result),
                  const SizedBox(height: AppTheme.md),
                  // Gait events card
                  _GaitEventsCard(result: result),
                  const SizedBox(height: AppTheme.md),
                  // Radar chart card
                  _RadarChartCard(result: result),
                  const SizedBox(height: AppTheme.xl),
                  // Action buttons
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.semiogramDetail),
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
                        'View Semiogram Details',
                        style: AppText.labelMd
                            .copyWith(color: AppColors.onPrimary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.sm),
                  Row(
                    children: [
                      Expanded(
                        child: _OutlineBtn(
                          label: 'Save Result',
                          icon: Icons.save_outlined,
                          onTap: () async {
                            await provider.saveSession();
                            if (context.mounted) {
                              context.go(AppRoutes.home);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: AppTheme.sm),
                      Expanded(
                        child: _OutlineBtn(
                          label: 'Export Report',
                          icon: Icons.ios_share,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
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

class _SeverityBadge extends StatelessWidget {
  final String severity;
  const _SeverityBadge({required this.severity});

  Color get _color => switch (severity.toLowerCase()) {
        'mild' => AppColors.success,
        'moderate' => AppColors.warning,
        'severe' => AppColors.error,
        _ => AppColors.onSurfaceVariant,
      };

  Color get _bg => switch (severity.toLowerCase()) {
        'mild' => AppColors.successContainer,
        'moderate' => AppColors.warningContainer,
        'severe' => AppColors.errorContainer,
        _ => AppColors.surfaceContainerHighest,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: AppTheme.radiusFull,
      ),
      child: Text(severity,
          style: AppText.labelSm
              .copyWith(color: _color, fontWeight: FontWeight.w700)),
    );
  }
}

class _ResultAppBar extends StatelessWidget {
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
            onTap: () => context.go(AppRoutes.home),
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
          Text('Analysis Result', style: AppText.headlineSm),
        ],
      ),
    );
  }
}

class _MainScoreCard extends StatelessWidget {
  final GaitResult result;
  const _MainScoreCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FMA-LE Score', style: AppText.labelSm),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        result.fmaLeScore.toString(),
                        style: AppText.dataXl
                            .copyWith(color: AppColors.primary),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(' / 34',
                            style: AppText.headlineSm.copyWith(
                                color: AppColors.onSurfaceVariant)),
                      ),
                    ],
                  ),
                ],
              ),
              _SeverityBadge(severity: result.severity),
            ],
          ),
          const SizedBox(height: AppTheme.sm),
          Row(
            children: [
              const Icon(Icons.verified_outlined,
                  size: 16, color: AppColors.success),
              const SizedBox(width: 4),
              Text(
                '${(result.confidence * 100).round()}% confidence',
                style: AppText.labelSm
                    .copyWith(color: AppColors.success),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClassificationCard extends StatelessWidget {
  final GaitResult result;
  const _ClassificationCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medical_information_outlined,
                color: AppColors.secondary),
          ),
          const SizedBox(width: AppTheme.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Classification', style: AppText.labelSm),
                Text(result.classification, style: AppText.headlineSm),
                Text(
                  'Stroke-related gait impairment pattern detected',
                  style: AppText.bodySm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GaitEventsCard extends StatelessWidget {
  final GaitResult result;
  const _GaitEventsCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gait Events', style: AppText.labelMd),
          const SizedBox(height: AppTheme.md),
          _EventRow(
            label: 'Heel Strike',
            count: result.heelStrikeCount,
            max: 40,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppTheme.sm),
          _EventRow(
            label: 'Toe Off',
            count: result.toeOffCount,
            max: 40,
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  final String label;
  final int count;
  final int max;
  final Color color;

  const _EventRow({
    required this.label,
    required this.count,
    required this.max,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppText.labelSm),
            Text(count.toString(), style: AppText.dataViz),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: AppTheme.radiusFull,
          child: LinearProgressIndicator(
            value: count / max,
            minHeight: 8,
            backgroundColor: AppColors.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _RadarChartCard extends StatelessWidget {
  final GaitResult result;
  const _RadarChartCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final s = result.semiogram;
    final values = [
      s.v,
      s.strT,
      s.ldlja,
      s.symmetryIndex,
      s.cvStrideTime,
      s.sparcrot,
    ];

    return AppCard(
      child: Column(
        children: [
          Text('Semiogram Overview', style: AppText.labelMd),
          const SizedBox(height: AppTheme.md),
          SizedBox(
            height: 220,
            child: CustomPaint(
              painter: _RadarPainter(values: values),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(s.symmetryIndex * 100).round()}',
                      style: AppText.dataLg
                          .copyWith(color: AppColors.primary),
                    ),
                    Text('Index', style: AppText.labelSm),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.md),
          // Legend metrics
          Wrap(
            spacing: AppTheme.sm,
            runSpacing: AppTheme.sm,
            children: [
              _MetricChip(
                  label: 'Speed',
                  value: '${(s.v * 100).round()}%'),
              _MetricChip(
                  label: 'Springiness',
                  value: '${(s.strT * 100).round()}%'),
              _MetricChip(
                  label: 'Smoothness',
                  value: '${(s.ldlja * 100).round()}%'),
              _MetricChip(
                  label: 'Symmetry',
                  value: '${(s.symmetryIndex * 100).round()}%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;
  const _MetricChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppTheme.radiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppText.labelSm),
          const SizedBox(width: 6),
          Text(value,
              style: AppText.dataViz
                  .copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final List<double> values;
  const _RadarPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 24;
    final sides = values.length;
    final angle = 2 * pi / sides;

    // Grid rings
    final gridPaint = Paint()
      ..color = AppColors.outlineVariant.withAlpha(80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int ring = 1; ring <= 4; ring++) {
      final r = radius * ring / 4;
      final path = Path();
      for (int i = 0; i < sides; i++) {
        final a = -pi / 2 + i * angle;
        final x = center.dx + r * cos(a);
        final y = center.dy + r * sin(a);
        if (i == 0) path.moveTo(x, y);
        else path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Axes
    for (int i = 0; i < sides; i++) {
      final a = -pi / 2 + i * angle;
      canvas.drawLine(
        center,
        Offset(center.dx + radius * cos(a), center.dy + radius * sin(a)),
        gridPaint,
      );
    }

    // Data polygon
    final dataPath = Path();
    final dataPaint = Paint()
      ..color = AppColors.primaryContainer.withAlpha(120)
      ..style = PaintingStyle.fill;
    final dataStroke = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < sides; i++) {
      final a = -pi / 2 + i * angle;
      final r = radius * values[i].clamp(0.0, 1.0);
      final x = center.dx + r * cos(a);
      final y = center.dy + r * sin(a);
      if (i == 0) dataPath.moveTo(x, y);
      else dataPath.lineTo(x, y);
    }
    dataPath.close();
    canvas.drawPath(dataPath, dataPaint);
    canvas.drawPath(dataPath, dataStroke);

    // Labels
    const labels = ['Speed', 'Spring', 'Smooth', 'Sym', 'Stride', 'SPARC'];
    const textStyle = TextStyle(
      fontSize: 10,
      fontFamily: 'Inter',
      color: AppColors.onSurfaceVariant,
    );
    for (int i = 0; i < sides; i++) {
      final a = -pi / 2 + i * angle;
      final lx = center.dx + (radius + 18) * cos(a);
      final ly = center.dy + (radius + 18) * sin(a);
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas,
          Offset(lx - tp.width / 2, ly - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_RadarPainter old) => false;
}

class _OutlineBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _OutlineBtn(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: AppTheme.radiusFull,
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(label,
                style:
                    AppText.labelMd.copyWith(color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}
