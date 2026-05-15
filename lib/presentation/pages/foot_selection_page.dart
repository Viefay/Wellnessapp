import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../providers/recording_provider.dart';
import '../widgets/app_card.dart';

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
            onTap: () => context.go(AppRoutes.instruction),
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
          Text(title, style: AppText.headlineSm),
        ],
      ),
    );
  }
}

class FootSelectionPage extends StatelessWidget {
  const FootSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecordingProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _BackAppBar(title: 'Select Foot Side'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.marginMobile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Which foot would you like to record first?',
                    style: AppText.bodyMd
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppTheme.lg),
                  // Foot selection cards
                  Row(
                    children: [
                      Expanded(
                        child: _FootCard(
                          label: 'Left Foot',
                          side: 'left',
                          isSelected: provider.selectedFootSide == 'left',
                          onTap: () => provider.selectFootSide('left'),
                        ),
                      ),
                      const SizedBox(width: AppTheme.md),
                      Expanded(
                        child: _FootCard(
                          label: 'Right Foot',
                          side: 'right',
                          isSelected: provider.selectedFootSide == 'right',
                          onTap: () => provider.selectFootSide('right'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.lg),
                  // Info box
                  Container(
                    padding: const EdgeInsets.all(AppTheme.md),
                    decoration: BoxDecoration(
                      color: AppColors.infoContainer.withAlpha(80),
                      borderRadius: AppTheme.radiusDefault,
                      border: Border.all(
                          color: AppColors.info.withAlpha(60)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.info, size: 20),
                        const SizedBox(width: AppTheme.sm),
                        Expanded(
                          child: Text(
                            'You will be asked to record the other foot after completing this one.',
                            style: AppText.bodySm,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          // Sticky footer
          Container(
            padding: const EdgeInsets.all(AppTheme.marginMobile),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(
                    color: AppColors.outlineVariant.withAlpha(51)),
              ),
            ),
            child: SafeArea(
              top: false,
              child: GestureDetector(
                onTap: () => context.go(AppRoutes.recording),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppTheme.radiusFull,
                    boxShadow: AppTheme.primaryShadow,
                  ),
                  child: Text(
                    'Continue to Recording',
                    style:
                        AppText.labelMd.copyWith(color: AppColors.onPrimary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FootCard extends StatelessWidget {
  final String label;
  final String side;
  final bool isSelected;
  final VoidCallback onTap;

  const _FootCard({
    required this.label,
    required this.side,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(13)
              : AppColors.surfaceContainerLowest,
          borderRadius: AppTheme.radiusLg,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: AppTheme.cardShadow,
        ),
        padding: const EdgeInsets.all(AppTheme.lg),
        child: Column(
          children: [
            Container(
              height: 100,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    side == 'left'
                        ? Icons.directions_walk
                        : Icons.directions_walk,
                    size: 80,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.outlineVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.md),
            Text(label,
                style: AppText.labelMd.copyWith(
                    color: isSelected
                        ? const Color.fromARGB(255, 132, 148, 146)
                        : AppColors.onSurface)),
            const SizedBox(height: AppTheme.xs),
            Text(
              isSelected ? 'Selected' : 'Tap to select',
              style: AppText.labelSm.copyWith(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant),
            ),
            if (isSelected) ...[
              const SizedBox(height: AppTheme.sm),
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check,
                    size: 16, color: AppColors.onPrimary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
