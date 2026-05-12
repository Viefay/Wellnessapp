import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dummy_data.dart';
import '../../data/models/semiogram_result.dart';
import '../providers/session_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/bottom_nav_shell.dart';

class SemiogramDetailPage extends StatelessWidget {
  const SemiogramDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionProvider>();
    final result = provider.currentResult ?? dummyResult;
    final s = result.semiogram;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _DetailAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.marginMobile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Radar chart card
                  AppCard(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Semiogram Radar',
                                style: AppText.labelMd),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer
                                    .withAlpha(40),
                                borderRadius: AppTheme.radiusFull,
                              ),
                              child: Text(
                                'Index: ${(s.symmetryIndex * 100).round()}',
                                style: AppText.labelSm.copyWith(
                                    color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.md),
                        SizedBox(
                          height: 260,
                          child: CustomPaint(
                            painter: _DetailRadarPainter(semiogram: s),
                          ),
                        ),
                        const SizedBox(height: AppTheme.sm),
                        // Legend
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            _LegendDot(
                                color: AppColors.primary,
                                label: 'Current State'),
                            const SizedBox(width: 16),
                            _LegendDot(
                                color: AppColors.outlineVariant,
                                label: 'Baseline'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.md),
                  // Parameter sections
                  _CollapsibleSection(
                    title: 'Velocity & Cadence',
                    icon: Icons.speed,
                    children: [
                      _ParamRow(
                          label: 'Avg Speed (V)',
                          value: '${s.v.toStringAsFixed(2)} m/s'),
                      _ParamRow(
                          label: 'Cadence',
                          value: '${s.cadence.round()} steps/min'),
                      _ParamRow(
                          label: 'Step Length (L)',
                          value:
                              '${s.stepLengthLeft.toStringAsFixed(2)} m'),
                      _ParamRow(
                          label: 'Step Length (R)',
                          value:
                              '${s.stepLengthRight.toStringAsFixed(2)} m'),
                    ],
                  ),
                  const SizedBox(height: AppTheme.sm),
                  _CollapsibleSection(
                    title: 'Dynamic Factors',
                    icon: Icons.analytics_outlined,
                    children: [
                      _ParamRow(
                          label: 'Springiness',
                          value: s.strT.toStringAsFixed(3)),
                      _ParamRow(
                          label: 'Smoothness',
                          value: s.ldlja.toStringAsFixed(3)),
                      _ParamRow(
                          label: 'SPARC (Rot)',
                          value: s.sparcrot.toStringAsFixed(3)),
                      _ParamRow(
                          label: 'SPARC (Tra)',
                          value: s.sparctra.toStringAsFixed(3)),
                      _ParamRow(
                          label: 'SPARC (Ver)',
                          value: s.sparcver.toStringAsFixed(3)),
                    ],
                  ),
                  const SizedBox(height: AppTheme.sm),
                  _CollapsibleSection(
                    title: 'Stance & Swing',
                    icon: Icons.swap_horiz,
                    children: [
                      _ParamRow(
                          label: 'Stance Phase (L)',
                          value: '${s.stanceLeft.toStringAsFixed(1)}%'),
                      _ParamRow(
                          label: 'Stance Phase (R)',
                          value:
                              '${s.stanceRight.toStringAsFixed(1)}%'),
                      _ParamRow(
                          label: 'Symmetry Index',
                          value: s.symmetryIndex.toStringAsFixed(3)),
                      _ParamRow(
                          label: 'CV Stride Time',
                          value: s.cvStrideTime.toStringAsFixed(3)),
                      // Weight distribution bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppTheme.sm),
                          Text('Weight Distribution',
                              style: AppText.labelSm),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: AppTheme.radiusFull,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: s.stanceLeft.round(),
                                  child: Container(
                                    height: 12,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Expanded(
                                  flex: s.stanceRight.round(),
                                  child: Container(
                                    height: 12,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'Left ${s.stanceLeft.toStringAsFixed(0)}%',
                                  style: AppText.labelSm.copyWith(
                                      color: AppColors.primary)),
                              Text(
                                  'Right ${s.stanceRight.toStringAsFixed(0)}%',
                                  style: AppText.labelSm.copyWith(
                                      color: AppColors.secondary)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.md),
                  // Clinical insights
                  AppCard(
                    color: AppColors.tertiaryContainer.withAlpha(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.lightbulb_outline,
                                color: AppColors.tertiary, size: 20),
                            const SizedBox(width: 8),
                            Text('Clinical Insights',
                                style: AppText.labelMd),
                          ],
                        ),
                        const SizedBox(height: AppTheme.sm),
                        Text(
                          'The semiogram indicates reduced walking speed and asymmetric gait pattern consistent with moderate hemiplegia. Targeted physiotherapy focusing on heel strike phase may improve FMA-LE scores.',
                          style: AppText.bodySm,
                        ),
                        const SizedBox(height: AppTheme.md),
                        Row(
                          children: [
                            Expanded(
                              child: _TertiaryBtn(
                                label: 'View Therapy Plan',
                                onTap: () {},
                              ),
                            ),
                            const SizedBox(width: AppTheme.sm),
                            Expanded(
                              child: _TertiaryBtn(
                                label: 'Compare Past',
                                onTap: () => context.go(AppRoutes.history),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

class _DetailAppBar extends StatelessWidget {
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
            onTap: () => context.go(AppRoutes.result),
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
          Text('Semiogram Details', style: AppText.headlineSm),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppText.labelSm),
      ],
    );
  }
}

class _CollapsibleSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _CollapsibleSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.md),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.icon,
                        color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: AppTheme.sm),
                  Expanded(
                    child: Text(widget.title, style: AppText.labelMd),
                  ),
                  Icon(
                    _expanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppTheme.md, 0, AppTheme.md, AppTheme.md),
              child: Column(children: widget.children),
            ),
        ],
      ),
    );
  }
}

class _ParamRow extends StatelessWidget {
  final String label;
  final String value;
  const _ParamRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppText.bodySm
                  .copyWith(color: AppColors.onSurfaceVariant)),
          Text(value,
              style: AppText.dataViz
                  .copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _TertiaryBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _TertiaryBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: AppTheme.radiusFull,
          border: Border.all(
              color: AppColors.tertiary.withAlpha(120), width: 1.5),
        ),
        child: Text(label,
            style: AppText.labelSm
                .copyWith(color: AppColors.tertiary),
            textAlign: TextAlign.center),
      ),
    );
  }
}

class _DetailRadarPainter extends CustomPainter {
  final SemiogramResult semiogram;
  const _DetailRadarPainter({required this.semiogram});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 32;
    const sides = 6;
    const angle = 2 * pi / sides;
    final values = [
      semiogram.v,
      semiogram.strT,
      semiogram.ldlja,
      semiogram.symmetryIndex,
      1.0 - semiogram.cvStrideTime, // inverted: lower is better
      semiogram.sparcrot,
    ];
    const labels = [
      'Speed',
      'Springiness',
      'Smoothness',
      'Symmetry',
      'Steadiness',
      'Stability'
    ];

    final gridPaint = Paint()
      ..color = AppColors.outlineVariant.withAlpha(60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Grid
    for (int ring = 1; ring <= 5; ring++) {
      final r = radius * ring / 5;
      final path = Path();
      for (int i = 0; i < sides; i++) {
        final a = -pi / 2 + i * angle;
        final x = center.dx + r * cos(a);
        final y = center.dy + r * sin(a);
        i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Axes
    for (int i = 0; i < sides; i++) {
      final a = -pi / 2 + i * angle;
      canvas.drawLine(center,
          Offset(center.dx + radius * cos(a), center.dy + radius * sin(a)),
          gridPaint);
    }

    // Baseline polygon (all at 0.7)
    final basePath = Path();
    final basePaint = Paint()
      ..color = AppColors.outlineVariant.withAlpha(40)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < sides; i++) {
      final a = -pi / 2 + i * angle;
      final r = radius * 0.7;
      final x = center.dx + r * cos(a);
      final y = center.dy + r * sin(a);
      i == 0 ? basePath.moveTo(x, y) : basePath.lineTo(x, y);
    }
    basePath.close();
    canvas.drawPath(basePath, basePaint);
    canvas.drawPath(
        basePath,
        Paint()
          ..color = AppColors.outlineVariant.withAlpha(120)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

    // Data polygon
    final dataPath = Path();
    for (int i = 0; i < sides; i++) {
      final a = -pi / 2 + i * angle;
      final r = radius * values[i].clamp(0.0, 1.0);
      final x = center.dx + r * cos(a);
      final y = center.dy + r * sin(a);
      i == 0 ? dataPath.moveTo(x, y) : dataPath.lineTo(x, y);
    }
    dataPath.close();
    canvas.drawPath(
        dataPath,
        Paint()
          ..color = AppColors.primaryContainer.withAlpha(100)
          ..style = PaintingStyle.fill);
    canvas.drawPath(
        dataPath,
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);

    // Labels
    for (int i = 0; i < sides; i++) {
      final a = -pi / 2 + i * angle;
      final lx = center.dx + (radius + 22) * cos(a);
      final ly = center.dy + (radius + 22) * sin(a);
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
              fontSize: 10,
              fontFamily: 'Inter',
              color: AppColors.onSurfaceVariant),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(lx - tp.width / 2, ly - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_DetailRadarPainter old) => false;
}
