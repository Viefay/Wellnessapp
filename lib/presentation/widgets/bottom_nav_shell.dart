import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';

class BottomNavBar extends StatelessWidget {
  final String activePage;

  const BottomNavBar({super.key, required this.activePage});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withAlpha(204),
            border: Border(
              top: BorderSide(
                color: AppColors.outlineVariant.withAlpha(51),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  _NavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    isActive: activePage == 'home',
                    onTap: () => context.go(AppRoutes.home),
                  ),
                  _NavItem(
                    icon: Icons.fiber_manual_record_outlined,
                    activeIcon: Icons.fiber_manual_record,
                    label: 'Record',
                    isActive: activePage == 'record',
                    onTap: () => context.go(AppRoutes.instruction),
                  ),
                  _NavItem(
                    icon: Icons.history_outlined,
                    activeIcon: Icons.history,
                    label: 'History',
                    isActive: activePage == 'history',
                    onTap: () => context.go(AppRoutes.history),
                  ),
                  _NavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
                    isActive: activePage == 'profile',
                    onTap: () => context.go(AppRoutes.profile),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.secondaryContainer
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  isActive ? activeIcon : icon,
                  size: 24,
                  color: isActive
                      ? AppColors.onSecondaryContainer
                      : AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppText.labelSm.copyWith(
                  color: isActive
                      ? AppColors.onSecondaryContainer
                      : AppColors.onSurfaceVariant,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
