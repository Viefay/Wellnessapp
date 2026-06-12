import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../providers/session_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/custom_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = context.watch<SessionProvider>().history;
    final profile = context.watch<ProfileProvider>().profile;
    final displayName =
        profile.name.trim().isEmpty ? 'there' : profile.name.trim();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'Gait Analysis',
        actions: [
          IconButton(
            icon: const Icon(Icons.sensors, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
                height: 64 + MediaQuery.of(context).padding.top + 8),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.marginMobile),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Greeting
                Text('Hello, welcome back',
                    style: AppText.bodySm),
                const SizedBox(height: 4),
                Text(displayName, style: AppText.headlineSm),
                const SizedBox(height: AppTheme.lg),
                // Hero card
                _HeroCard(onStartTest: () => context.go(AppRoutes.instruction)),
                const SizedBox(height: AppTheme.lg),
                // Bento stats grid
                _StatsGrid(),
                const SizedBox(height: AppTheme.xl),
                // Activity history header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Activity', style: AppText.headlineSm),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.history),
                      child: Text('View All',
                          style: AppText.labelMd
                              .copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.md),
                // Session cards
                ...sessions.take(3).map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.sm),
                      child: _SessionCard(
                        date: _formatDate(s.date),
                        classification: s.classification,
                        severity: s.severity,
                        fmaScore: s.result.fmaLeScore,
                        symmetry: (s.result.semiogram.symmetryIndex * 100)
                            .round(),
                        onTap: () => context.go(AppRoutes.result),
                      ),
                    )),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(activePage: 'home'),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_monthName(d.month)} ${d.year}';

  String _monthName(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];
}

class _HeroCard extends StatelessWidget {
  final VoidCallback onStartTest;
  const _HeroCard({required this.onStartTest});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF006A62), Color(0xFF2EC4B6)],
        ),
        borderRadius: AppTheme.radiusLg,
        boxShadow: AppTheme.primaryShadow,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.directions_walk,
              size: 160,
              color: Colors.white.withAlpha(26),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Start a new gait test',
                    style: AppText.headlineSm
                        .copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text('Attach sensor and begin walking',
                    style: AppText.bodySm
                        .copyWith(color: Colors.white70)),
                const SizedBox(height: AppTheme.md),
                GestureDetector(
                  onTap: onStartTest,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppTheme.radiusFull,
                    ),
                    child: Text(
                      'Start Test',
                      style: AppText.labelMd
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final history = context.watch<SessionProvider>().history;
    final latest = history.isNotEmpty ? history.first : null;

    return Column(
      children: [
        // FMA-LE card (full width)
        AppCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FMA-LE Score',
                        style: AppText.labelSm),
                    const SizedBox(height: 4),
                    Text(
                        latest != null
                            ? latest.result.fmaLeScore.toString()
                            : '—',
                        style: AppText.dataLg
                            .copyWith(color: AppColors.primary)),
                    Text('out of 34',
                        style: AppText.labelSm),
                  ],
                ),
              ),
              if (latest != null)
                _SeverityBadge(severity: latest.severity),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.sm),
        Row(
          children: [
            // Classification
            Expanded(
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Classification',
                        style: AppText.labelSm),
                    const SizedBox(height: 4),
                    Text(latest != null ? latest.classification : '—',
                        style: AppText.headlineSm
                            .copyWith(color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Text(
                        latest != null
                            ? '${(latest.result.confidence * 100).round()}% confidence'
                            : 'No tests yet',
                        style: AppText.labelSm
                            .copyWith(color: AppColors.success)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppTheme.sm),
            // Sessions
            Expanded(
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sessions', style: AppText.labelSm),
                    const SizedBox(height: 4),
                    Text(history.length.toString(),
                        style: AppText.headlineSm
                            .copyWith(color: AppColors.secondary)),
                    const SizedBox(height: 4),
                    Text('total tests',
                        style: AppText.labelSm),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
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
          style: AppText.labelSm.copyWith(
              color: _color, fontWeight: FontWeight.w700)),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final String date;
  final String classification;
  final String severity;
  final int fmaScore;
  final int symmetry;
  final VoidCallback onTap;

  const _SessionCard({
    required this.date,
    required this.classification,
    required this.severity,
    required this.fmaScore,
    required this.symmetry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date, style: AppText.labelSm),
                    const SizedBox(height: 2),
                    Text(classification, style: AppText.labelMd),
                  ],
                ),
              ),
              _SeverityBadge(severity: severity),
            ],
          ),
          const SizedBox(height: AppTheme.sm),
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                    label: 'FMA-LE',
                    value: '$fmaScore / 34'),
              ),
              Expanded(
                child: _MetricItem(
                    label: 'Symmetry',
                    value: '$symmetry%'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  const _MetricItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.labelSm),
        Text(value,
            style: AppText.dataViz.copyWith(color: AppColors.primary)),
      ],
    );
  }
}
