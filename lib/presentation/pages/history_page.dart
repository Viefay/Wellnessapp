import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/gait_session.dart';
import '../providers/session_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/custom_app_bar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _searchQuery = '';
  String? _filterSeverity;

  @override
  Widget build(BuildContext context) {
    final sessions = context.watch<SessionProvider>().history;

    final filtered = sessions.where((s) {
      final matchSearch = _searchQuery.isEmpty ||
          s.classification
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          s.severity
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      final matchFilter =
          _filterSeverity == null || s.severity == _filterSeverity;
      return matchSearch && matchFilter;
    }).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: 'History'),
      body: Column(
        children: [
          SizedBox(height: 64 + MediaQuery.of(context).padding.top),
          // Search and filter
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.marginMobile, vertical: AppTheme.sm),
            child: Column(
              children: [
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: AppTheme.radiusDefault,
                    border: Border.all(
                        color: AppColors.outlineVariant.withAlpha(80)),
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search sessions...',
                      hintStyle: AppText.bodySm,
                      prefixIcon: const Icon(Icons.search,
                          color: AppColors.onSurfaceVariant),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    style: AppText.bodyMd,
                  ),
                ),
                const SizedBox(height: AppTheme.sm),
                // Filter chips
                Row(
                  children: [
                    Text('Filter:',
                        style: AppText.labelSm),
                    const SizedBox(width: AppTheme.sm),
                    ...['Mild', 'Moderate', 'Severe'].map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _FilterChip(
                          label: s,
                          isActive: _filterSeverity == s,
                          onTap: () => setState(() =>
                              _filterSeverity =
                                  _filterSeverity == s ? null : s),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Session list
          Expanded(
            child: filtered.isEmpty
                ? _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.marginMobile),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppTheme.sm),
                      child: _HistoryCard(
                        session: filtered[i],
                        onTap: () {
                          context
                              .read<SessionProvider>()
                              .setResult(filtered[i].result);
                          context.go(AppRoutes.result);
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(activePage: 'history'),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip(
      {required this.label,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              isActive ? AppColors.primary : AppColors.surfaceContainerLow,
          borderRadius: AppTheme.radiusFull,
        ),
        child: Text(
          label,
          style: AppText.labelSm.copyWith(
            color: isActive ? AppColors.onPrimary : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final GaitSession session;
  final VoidCallback onTap;

  const _HistoryCard({required this.session, required this.onTap});

  String get _dateLabel {
    final d = session.date;
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month]} ${d.year}';
  }

  Color get _severityColor => switch (session.severity.toLowerCase()) {
        'mild' => AppColors.success,
        'moderate' => AppColors.warning,
        'severe' => AppColors.error,
        _ => AppColors.onSurfaceVariant,
      };

  Color get _severityBg => switch (session.severity.toLowerCase()) {
        'mild' => AppColors.successContainer,
        'moderate' => AppColors.warningContainer,
        'severe' => AppColors.errorContainer,
        _ => AppColors.surfaceContainerHighest,
      };

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_dateLabel, style: AppText.labelSm),
                    const SizedBox(height: 2),
                    Text(session.classification,
                        style: AppText.labelMd),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _severityBg,
                  borderRadius: AppTheme.radiusFull,
                ),
                child: Text(
                  session.severity,
                  style: AppText.labelSm.copyWith(
                      color: _severityColor,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.sm),
          Row(
            children: [
              Expanded(
                child: _MiniMetric(
                  label: 'FMA-LE',
                  value: '${session.result.fmaLeScore} / 34',
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Symmetry',
                  value:
                      '${(session.result.semiogram.symmetryIndex * 100).round()}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.sm),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withAlpha(40),
                borderRadius: AppTheme.radiusFull,
              ),
              child: Text(
                'View Details',
                style: AppText.labelSm
                    .copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  final String label;
  final String value;
  const _MiniMetric({required this.label, required this.value});

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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.history_toggle_off,
              size: 64, color: AppColors.outlineVariant),
          const SizedBox(height: AppTheme.md),
          Text('No sessions found', style: AppText.headlineSm),
          const SizedBox(height: AppTheme.sm),
          Text('Need more data?',
              style: AppText.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: AppTheme.lg),
          GestureDetector(
            onTap: () => context.go(AppRoutes.instruction),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppTheme.radiusFull,
              ),
              child: Text('Start New Test',
                  style: AppText.labelMd
                      .copyWith(color: AppColors.onPrimary)),
            ),
          ),
        ],
      ),
    );
  }
}
