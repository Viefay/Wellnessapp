import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_routes.dart';
import '../presentation/pages/splash_page.dart';
import '../presentation/pages/onboarding_page.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/instruction_page.dart';
import '../presentation/pages/foot_selection_page.dart';
import '../presentation/pages/recording_page.dart';
import '../presentation/pages/processing_page.dart';
import '../presentation/pages/result_page.dart';
import '../presentation/pages/semiogram_detail_page.dart';
import '../presentation/pages/history_page.dart';
import '../presentation/pages/profile_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder: (_, __) => const NoTransitionPage(child: SplashPage()),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      pageBuilder: (_, __) =>
          _slidePage(const OnboardingPage()),
    ),
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (_, __) => _fadePage(const HomePage()),
    ),
    GoRoute(
      path: AppRoutes.instruction,
      pageBuilder: (_, __) => _slidePage(const InstructionPage()),
    ),
    GoRoute(
      path: AppRoutes.footSelection,
      pageBuilder: (_, __) => _slidePage(const FootSelectionPage()),
    ),
    GoRoute(
      path: AppRoutes.recording,
      pageBuilder: (_, __) => _slidePage(const RecordingPage()),
    ),
    GoRoute(
      path: AppRoutes.processing,
      pageBuilder: (_, __) => _fadePage(const ProcessingPage()),
    ),
    GoRoute(
      path: AppRoutes.result,
      pageBuilder: (_, __) => _slidePage(const ResultPage()),
    ),
    GoRoute(
      path: AppRoutes.semiogramDetail,
      pageBuilder: (_, __) => _slidePage(const SemiogramDetailPage()),
    ),
    GoRoute(
      path: AppRoutes.history,
      pageBuilder: (_, __) => _fadePage(const HistoryPage()),
    ),
    GoRoute(
      path: AppRoutes.profile,
      pageBuilder: (_, __) => _fadePage(const ProfilePage()),
    ),
  ],
);

CustomTransitionPage<void> _fadePage(Widget child) => CustomTransitionPage(
      child: child,
      transitionsBuilder: (_, anim, __, c) =>
          FadeTransition(opacity: anim, child: c),
      transitionDuration: const Duration(milliseconds: 200),
    );

CustomTransitionPage<void> _slidePage(Widget child) => CustomTransitionPage(
      child: child,
      transitionsBuilder: (_, anim, __, c) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: c,
      ),
      transitionDuration: const Duration(milliseconds: 280),
    );
