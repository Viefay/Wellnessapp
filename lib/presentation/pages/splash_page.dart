import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();

    Timer(const Duration(seconds: 2), () {
      if (mounted) context.go(AppRoutes.onboarding);
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Logo
                _LogoBadge(),
                const SizedBox(height: AppTheme.lg),
                // Title
                Text('Wellness App', style: AppText.displayLg),
                const SizedBox(height: AppTheme.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.marginMobile),
                  child: Text(
                    'Smart gait assessment\nfrom your smartphone',
                    style: AppText.bodyLg.copyWith(
                        color: AppColors.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(flex: 1),
                // Hero card
                _HeroCard(),
                const Spacer(flex: 2),
                // Progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.marginMobile),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: AppTheme.radiusFull,
                        child: LinearProgressIndicator(
                          value: 0.68,
                          minHeight: 4,
                          backgroundColor:
                              AppColors.outlineVariant.withAlpha(80),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primaryContainer),
                        ),
                      ),
                      const SizedBox(height: AppTheme.lg),
                      // Page dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: i == 0 ? 24 : 8,
                            height: 8,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: i == 0
                                  ? AppColors.primary
                                  : AppColors.outlineVariant,
                              borderRadius: AppTheme.radiusFull,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.xl),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.onboarding),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: AppTheme.radiusFull,
                            boxShadow: AppTheme.primaryShadow,
                          ),
                          child: Text(
                            'Get Started',
                            style: AppText.labelMd
                                .copyWith(color: AppColors.onPrimary),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.xl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: AppTheme.radiusLg,
            boxShadow: AppTheme.cardShadow,
          ),
          child: const Icon(Icons.directions_walk,
              size: 48, color: AppColors.primary),
        ),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.monitor_heart,
              size: 14, color: AppColors.onPrimaryContainer),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppTheme.marginMobile),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF006A62), Color(0xFF2EC4B6)],
          ),
          borderRadius: AppTheme.radiusLg,
          boxShadow: AppTheme.primaryShadow,
        ),
        child: Stack(
          children: [
            // Glassmorphism overlay
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(26),
                  borderRadius: AppTheme.radiusDefault,
                  border: Border.all(
                      color: Colors.white.withAlpha(51), width: 1),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FMA-LE',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontFamily: 'Inter')),
                    Text('24 / 34',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Inter')),
                  ],
                ),
              ),
            ),
            // Walking icon background
            Positioned(
              bottom: -20,
              left: -10,
              child: Icon(Icons.directions_walk,
                  size: 160,
                  color: Colors.white.withAlpha(26)),
            ),
            // Center content
            Padding(
              padding: const EdgeInsets.all(AppTheme.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gait Analysis\nReady',
                    style: AppText.headlineMd
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4ADE80),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Sensors Active',
                        style: AppText.labelSm
                            .copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
