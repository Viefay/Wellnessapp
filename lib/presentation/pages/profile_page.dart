import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/custom_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const List<_SettingsItem> _settings = [
    _SettingsItem(
      icon: Icons.tune,
      label: 'Sensor Calibration',
      subtitle: 'Calibrate accelerometer & gyroscope',
    ),
    _SettingsItem(
      icon: Icons.lock_outline,
      label: 'Data Privacy',
      subtitle: 'Manage your data and permissions',
    ),
    _SettingsItem(
      icon: Icons.upload_file,
      label: 'Export Data',
      subtitle: 'Export sessions as CSV or PDF',
    ),
    _SettingsItem(
      icon: Icons.cloud_sync_outlined,
      label: 'Backend Connection',
      subtitle: null,
      trailing: 'Connected',
    ),
    _SettingsItem(
      icon: Icons.info_outline,
      label: 'About App',
      subtitle: 'Wellness App v1.0',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: 'Profile'),
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
                // Profile card
                AppCard(
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.secondaryContainer,
                              border: Border.all(
                                  color: AppColors.outlineVariant,
                                  width: 2),
                              image: const DecorationImage(
                                image: NetworkImage(
                                    'https://ui-avatars.com/api/?name=John+Doe&background=D9E3FF&color=001A41&size=160'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit,
                                  size: 14,
                                  color: AppColors.onPrimary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: AppTheme.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('John Doe',
                                style: AppText.headlineSm),
                            const SizedBox(height: 2),
                            Text('Age 34 · Pro Athlete',
                                style: AppText.bodySm),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer
                                    .withAlpha(40),
                                borderRadius: AppTheme.radiusFull,
                              ),
                              child: Text('User Profile',
                                  style: AppText.labelSm.copyWith(
                                      color: AppColors.primary)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.lg),
                Text('Settings', style: AppText.headlineSm),
                const SizedBox(height: AppTheme.md),
                // Settings list
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: List.generate(
                      _settings.length,
                      (i) => Column(
                        children: [
                          _SettingsTile(item: _settings[i]),
                          if (i < _settings.length - 1)
                            Divider(
                              height: 1,
                              color: AppColors.outlineVariant
                                  .withAlpha(40),
                              indent: 64,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.xl),
                // Footer
                Column(
                  children: [
                    Text('Wellness App v1.0',
                        style: AppText.labelSm, textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text('Engineered for Human Potential',
                        style: AppText.labelSm.copyWith(
                            color: AppColors.onSurfaceVariant),
                        textAlign: TextAlign.center),
                  ],
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(activePage: 'profile'),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final String? subtitle;
  final String? trailing;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
  });
}

class _SettingsTile extends StatelessWidget {
  final _SettingsItem item;
  const _SettingsTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.md, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppTheme.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.label, style: AppText.labelMd),
                if (item.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(item.subtitle!, style: AppText.labelSm),
                ],
              ],
            ),
          ),
          if (item.trailing != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.successContainer,
                borderRadius: AppTheme.radiusFull,
              ),
              child: Text(item.trailing!,
                  style: AppText.labelSm
                      .copyWith(color: AppColors.success)),
            )
          else
            const Icon(Icons.chevron_right,
                color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}
