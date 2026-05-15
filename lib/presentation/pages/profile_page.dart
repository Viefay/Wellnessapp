import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/user_profile.dart';
import '../providers/profile_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/custom_app_bar.dart';

/// Editable subject profile. No login/account — values are stored locally
/// and reused as analysis input (age, height, weight, BMI, gender).
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  String _gender = 'M';
  bool _seeded = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  void _seed(UserProfile p) {
    _nameCtrl.text = p.name;
    if (p.age > 0) _ageCtrl.text = p.age.toString();
    if (p.heightM > 0) _heightCtrl.text = p.heightM.toString();
    if (p.weightKg > 0) _weightCtrl.text = p.weightKg.toString();
    _gender = p.gender.isEmpty ? 'M' : p.gender;
    _seeded = true;
  }

  /// Height in metres. Accepts either metres (1.66) or centimetres (166):
  /// any value above 3 is treated as cm and converted, so BMI stays correct
  /// regardless of how the user types it.
  double get _heightM {
    final raw = double.tryParse(_heightCtrl.text.trim()) ?? 0;
    if (raw <= 0) return 0;
    return raw > 3 ? raw / 100.0 : raw;
  }

  double get _weightKg => double.tryParse(_weightCtrl.text.trim()) ?? 0;

  double get _liveBmi {
    final h = _heightM;
    if (h <= 0) return 0;
    return _weightKg / (h * h);
  }

  ({String label, Color color}) _bmiCategory(double bmi) {
    if (bmi <= 0) {
      return (label: 'Enter height & weight', color: AppColors.onSurfaceVariant);
    }
    if (bmi < 18.5) return (label: 'Underweight', color: AppColors.warning);
    if (bmi < 25) return (label: 'Normal', color: AppColors.success);
    if (bmi < 30) return (label: 'Overweight', color: AppColors.warning);
    return (label: 'Obese', color: AppColors.error);
  }

  Future<void> _save() async {
    final profile = UserProfile(
      name: _nameCtrl.text.trim(),
      gender: _gender,
      age: int.tryParse(_ageCtrl.text.trim()) ?? 0,
      heightM: _heightM, // normalised to metres
      weightKg: _weightKg,
    );
    await context.read<ProfileProvider>().update(profile);
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pp = context.watch<ProfileProvider>();
    if (!_seeded && pp.loaded) _seed(pp.profile);

    final bmi = _liveBmi;

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
                // Avatar + name header
                AppCard(
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondaryContainer,
                        ),
                        child: const Icon(Icons.person,
                            size: 32, color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(width: AppTheme.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nameCtrl.text.trim().isEmpty
                                  ? 'Your Profile'
                                  : _nameCtrl.text.trim(),
                              style: AppText.headlineSm,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              pp.profile.isComplete
                                  ? '${pp.profile.gender == 'M' ? 'Male' : 'Female'} · ${pp.profile.age} yrs'
                                  : 'Complete your details below',
                              style: AppText.bodySm,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.lg),
                Text('Subject Details', style: AppText.headlineSm),
                const SizedBox(height: 4),
                Text(
                  'Used as input for gait analysis. No account needed.',
                  style: AppText.bodySm
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: AppTheme.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Field(
                        label: 'Name (optional)',
                        controller: _nameCtrl,
                        keyboardType: TextInputType.name,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppTheme.md),
                      Text('Gender', style: AppText.labelSm),
                      const SizedBox(height: 6),
                      _GenderSelector(
                        value: _gender,
                        onChanged: (g) => setState(() => _gender = g),
                      ),
                      const SizedBox(height: AppTheme.md),
                      _Field(
                        label: 'Age (years)',
                        controller: _ageCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(height: AppTheme.md),
                      Row(
                        children: [
                          Expanded(
                            child: _Field(
                              label: 'Height (m)',
                              controller: _heightCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [_decimalFormatter],
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: AppTheme.md),
                          Expanded(
                            child: _Field(
                              label: 'Weight (kg)',
                              controller: _weightCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [_decimalFormatter],
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.md),
                // Live BMI — recomputes as you type height/weight
                Builder(builder: (_) {
                  final cat = _bmiCategory(bmi);
                  return AppCard(
                    color: AppColors.primaryContainer.withAlpha(40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Body Mass Index',
                                  style: AppText.labelSm),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: cat.color.withAlpha(30),
                                  borderRadius: AppTheme.radiusFull,
                                ),
                                child: Text(
                                  cat.label,
                                  style: AppText.labelSm.copyWith(
                                      color: cat.color,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppTheme.sm),
                        Text(
                          bmi > 0 ? bmi.toStringAsFixed(1) : '—',
                          style: AppText.dataLg.copyWith(color: cat.color),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: AppTheme.lg),
                GestureDetector(
                  onTap: _save,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppTheme.radiusFull,
                      boxShadow: AppTheme.primaryShadow,
                    ),
                    child: Text(
                      'Save Profile',
                      style: AppText.labelMd
                          .copyWith(color: AppColors.onPrimary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.xl),
                Center(
                  child: Text('Wellness App v1.0',
                      style: AppText.labelSm,
                      textAlign: TextAlign.center),
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

final _decimalFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'));

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  const _Field({
    required this.label,
    required this.controller,
    required this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.labelSm),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: AppTheme.radiusDefault,
            border: Border.all(
                color: AppColors.outlineVariant.withAlpha(80)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            style: AppText.bodyMd,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _GenderSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _opt('M', 'Male')),
        const SizedBox(width: AppTheme.sm),
        Expanded(child: _opt('F', 'Female')),
      ],
    );
  }

  Widget _opt(String code, String label) {
    final selected = value == code;
    return GestureDetector(
      onTap: () => onChanged(code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withAlpha(20)
              : AppColors.surfaceContainerLowest,
          borderRadius: AppTheme.radiusDefault,
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.outlineVariant.withAlpha(80),
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppText.labelMd.copyWith(
            color:
                selected ? AppColors.primary : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
