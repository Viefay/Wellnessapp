import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/app_card.dart';

class InstructionPage extends StatelessWidget {
  const InstructionPage({super.key});

  static const List<_InstructionItem> _items = [
    _InstructionItem(
      icon: Icons.smartphone,
      title: 'Attach Your Phone',
      description:
          'Securely fasten your smartphone to your ankle or lower leg using the provided strap.',
    ),
    _InstructionItem(
      icon: Icons.directions_walk,
      title: 'Walk Naturally',
      description:
          'Walk at your normal pace. Do not try to walk differently — natural gait gives the best results.',
    ),
    _InstructionItem(
      icon: Icons.repeat,
      title: 'Record Both Feet',
      description:
          'You will record each foot separately. Complete the right foot first, then the left.',
    ),
    _InstructionItem(
      icon: Icons.health_and_safety_outlined,
      title: 'Stay Safe',
      description:
          'Ensure a clear, flat path of at least 10 meters. Have a support person nearby if needed.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // App bar
          _BackAppBar(title: 'Test Instructions'),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.marginMobile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero illustration
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withAlpha(26),
                          AppColors.primaryContainer.withAlpha(26),
                        ],
                      ),
                      borderRadius: AppTheme.radiusLg,
                    ),
                    child: const Icon(
                      Icons.directions_walk,
                      size: 100,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.xl),
                  Text('Before You Begin', style: AppText.headlineSm),
                  const SizedBox(height: AppTheme.md),
                  ..._items.map((item) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppTheme.sm),
                        child: _InstructionCard(item: item),
                      )),
                  const SizedBox(height: AppTheme.md),
                  // Reassurance banner
                  Container(
                    padding: const EdgeInsets.all(AppTheme.md),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withAlpha(26),
                      borderRadius: AppTheme.radiusDefault,
                      border: Border.all(
                          color: AppColors.primaryContainer.withAlpha(80)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_outline,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: AppTheme.sm),
                        Expanded(
                          child: Text(
                            'Your data is encrypted and stored securely. Only you can access your results.',
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
                onTap: () => context.go(AppRoutes.footSelection),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppTheme.radiusFull,
                    boxShadow: AppTheme.primaryShadow,
                  ),
                  child: Text(
                    'Continue',
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

class _BackAppBar extends StatelessWidget {
  final String title;
  const _BackAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 20,
          right: 20),
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
          Text(title, style: AppText.headlineSm),
        ],
      ),
    );
  }
}

class _InstructionItem {
  final IconData icon;
  final String title;
  final String description;
  const _InstructionItem(
      {required this.icon,
      required this.title,
      required this.description});
}

class _InstructionCard extends StatefulWidget {
  final _InstructionItem item;
  const _InstructionCard({required this.item});

  @override
  State<_InstructionCard> createState() => _InstructionCardState();
}

class _InstructionCardState extends State<_InstructionCard> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Icon(widget.item.icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppTheme.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.item.title, style: AppText.labelMd),
                const SizedBox(height: 4),
                Text(widget.item.description, style: AppText.bodySm),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.sm),
          GestureDetector(
            onTap: () => setState(() => _checked = !_checked),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _checked ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _checked
                      ? AppColors.primary
                      : AppColors.outlineVariant,
                  width: 2,
                ),
              ),
              child: _checked
                  ? const Icon(Icons.check,
                      size: 14, color: AppColors.onPrimary)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
