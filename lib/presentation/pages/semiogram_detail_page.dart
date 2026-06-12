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
import '../../data/models/semiogram_reference.dart';
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

    final scores = buildSemiogramScores(s);
    // Preserve reference order while grouping by criteria.
    final groups = <String, List<SemiogramScore>>{};
    for (final score in scores) {
      groups.putIfAbsent(score.param.criteria, () => []).add(score);
    }

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                  // Full semiogram parameter table (from journal)
                  Row(
                    children: [
                      Text('Semiogram Parameters',
                          style: AppText.headlineSm),
                      const SizedBox(width: 6),
                      Text('(reference: journal)',
                          style: AppText.labelSm.copyWith(
                              color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                  const SizedBox(height: AppTheme.sm),
                  for (final entry in groups.entries) ...[
                    _CriteriaTable(
                      criteria: entry.key,
                      scores: entry.value,
                    ),
                    const SizedBox(height: AppTheme.sm),
                  ],
                  const SizedBox(height: AppTheme.sm),
                  // How to read
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
                            Text('How to read', style: AppText.labelMd),
                          ],
                        ),
                        const SizedBox(height: AppTheme.sm),
                        Text(
                          'Each parameter is standardised as Z = (value − mean) / SD '
                          'against the reference population. The Z-coefficient '
                          'sign (+/−) marks whether higher or lower is clinically '
                          'better; green means the subject is on the favourable '
                          'side of the reference, red means unfavourable.',
                          style: AppText.bodySm,
                        ),
                        const SizedBox(height: AppTheme.md),
                        _TertiaryBtn(
                          label: 'Compare Past Sessions',
                          onTap: () => context.go(AppRoutes.history),
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

/// One collapsible card per semiogram criteria, holding the full reference
/// table (Parameter / Mean / SD / Z-coefficient) plus the subject value and
/// computed Z-score.
class _CriteriaTable extends StatefulWidget {
  final String criteria;
  final List<SemiogramScore> scores;
  const _CriteriaTable({required this.criteria, required this.scores});

  @override
  State<_CriteriaTable> createState() => _CriteriaTableState();
}

class _CriteriaTableState extends State<_CriteriaTable> {
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
                  Expanded(
                    child: Text(widget.criteria,
                        style: AppText.labelMd),
                  ),
                  Text('${widget.scores.length} param',
                      style: AppText.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant)),
                  const SizedBox(width: 6),
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
          if (_expanded) ...[
            const _TableHeader(),
            for (int i = 0; i < widget.scores.length; i++)
              _ParamRow(
                score: widget.scores[i],
                isLast: i == widget.scores.length - 1,
              ),
          ],
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    final style = AppText.labelSm
        .copyWith(color: AppColors.onSurfaceVariant);
    return Container(
      color: AppColors.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.md, vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 30, child: Text('Parameter', style: style)),
          Expanded(
              flex: 22,
              child: Text('Mean±SD', style: style,
                  textAlign: TextAlign.right)),
          Expanded(
              flex: 12,
              child: Text('Z-c', style: style,
                  textAlign: TextAlign.center)),
          Expanded(
              flex: 18,
              child: Text('Subj', style: style,
                  textAlign: TextAlign.right)),
          Expanded(
              flex: 18,
              child: Text('Z', style: style,
                  textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

class _ParamRow extends StatelessWidget {
  final SemiogramScore score;
  final bool isLast;
  const _ParamRow({required this.score, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final p = score.param;
    final favourable = score.isFavourable;
    final zColor = favourable ? AppColors.success : AppColors.error;

    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                    color: AppColors.outlineVariant.withAlpha(40))),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.md, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: AppText.labelSm),
                Text(p.unit,
                    style: AppText.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Expanded(
            flex: 22,
            child: Text(
              '${p.mean.toStringAsFixed(2)}±${p.sd.toStringAsFixed(2)}',
              style: AppText.dataViz,
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 12,
            child: Text(
              p.zSign,
              style: AppText.labelMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 18,
            child: Text(
              score.value.toStringAsFixed(2),
              style: AppText.dataViz
                  .copyWith(color: AppColors.primary),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 18,
            child: Text(
              '${score.z >= 0 ? '+' : ''}${score.z.toStringAsFixed(2)}',
              style: AppText.dataViz.copyWith(
                  color: zColor, fontWeight: FontWeight.w700),
              textAlign: TextAlign.right,
            ),
          ),
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
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: AppTheme.radiusFull,
          border: Border.all(
              color: AppColors.tertiary.withAlpha(120), width: 1.5),
        ),
        child: Text(label,
            style: AppText.labelSm.copyWith(color: AppColors.tertiary),
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

    for (int i = 0; i < sides; i++) {
      final a = -pi / 2 + i * angle;
      canvas.drawLine(
          center,
          Offset(center.dx + radius * cos(a),
              center.dy + radius * sin(a)),
          gridPaint);
    }

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
