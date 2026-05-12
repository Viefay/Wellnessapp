import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _slides = const [
    _OnboardingData(
      icon: Icons.directions_walk,
      iconColor: AppColors.primary,
      title: 'Attach Your Phone',
      description:
          'Securely fasten your smartphone to your ankle or lower leg before starting the test.',
      chips: ['Secure Mount', 'IMU Sensor', '120Hz'],
    ),
    _OnboardingData(
      icon: Icons.analytics_outlined,
      iconColor: AppColors.secondary,
      title: 'Walk Naturally',
      description:
          'Walk at your normal pace along a straight path. The app captures your gait pattern automatically.',
      chips: ['Natural Gait', 'Auto Capture', '30 sec'],
    ),
    _OnboardingData(
      icon: Icons.health_and_safety_outlined,
      iconColor: AppColors.tertiary,
      title: 'Get Your Results',
      description:
          'Receive detailed FMA-LE scores, semiogram analysis, and clinical insights for therapy planning.',
      chips: ['FMA-LE Score', 'Semiogram', 'Clinical AI'],
    ),
  ];

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header row
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.marginMobile, vertical: AppTheme.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot indicators
                  Row(
                    children: List.generate(
                      _slides.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? AppColors.primary
                              : AppColors.outlineVariant,
                          borderRadius: AppTheme.radiusFull,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.home),
                    child: Text('Skip',
                        style: AppText.labelMd
                            .copyWith(color: AppColors.onSurfaceVariant)),
                  ),
                ],
              ),
            ),
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _OnboardingSlide(data: _slides[i]),
              ),
            ),
            // Bottom button
            Padding(
              padding: const EdgeInsets.all(AppTheme.marginMobile),
              child: GestureDetector(
                onTap: _next,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppTheme.radiusFull,
                    boxShadow: AppTheme.primaryShadow,
                  ),
                  child: Text(
                    _currentPage == _slides.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style:
                        AppText.labelMd.copyWith(color: AppColors.onPrimary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final List<String> chips;

  const _OnboardingData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.chips,
  });
}

class _OnboardingSlide extends StatelessWidget {
  final _OnboardingData data;
  const _OnboardingSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppTheme.marginMobile),
      child: Column(
        children: [
          // Illustration area
          Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background shape
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        data.iconColor.withAlpha(26),
                        data.iconColor.withAlpha(13),
                      ],
                    ),
                    borderRadius: AppTheme.radiusXl,
                  ),
                ),
                // Icon
                Icon(data.icon, size: 120, color: data.iconColor),
                // Data chips
                ...List.generate(
                  data.chips.length,
                  (i) => Positioned(
                    top: 24 + i * 40.0,
                    right: 24,
                    child: _DataChip(label: data.chips[i]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.xl),
          // Text content
          Text(data.title,
              style: AppText.headlineMd, textAlign: TextAlign.center),
          const SizedBox(height: AppTheme.md),
          Text(data.description,
              style: AppText.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center),
          const SizedBox(height: AppTheme.lg),
        ],
      ),
    );
  }
}

class _DataChip extends StatelessWidget {
  final String label;
  const _DataChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppTheme.radiusFull,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Text(label, style: AppText.labelSm),
    );
  }
}
