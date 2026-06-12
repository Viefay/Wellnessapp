import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

enum AppButtonVariant { primary, secondary, outline, ghost }

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final AppButtonVariant variant;
  final bool fullWidth;
  final IconData? icon;
  final bool loading;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = AppButtonVariant.primary,
    this.fullWidth = true,
    this.icon,
    this.loading = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  double _scale = 1.0;

  Color get _bg => switch (widget.variant) {
        AppButtonVariant.primary => AppColors.primary,
        AppButtonVariant.secondary => AppColors.secondaryContainer,
        AppButtonVariant.outline => Colors.transparent,
        AppButtonVariant.ghost => Colors.transparent,
      };

  Color get _fg => switch (widget.variant) {
        AppButtonVariant.primary => AppColors.onPrimary,
        AppButtonVariant.secondary => AppColors.onSecondaryContainer,
        AppButtonVariant.outline => AppColors.primary,
        AppButtonVariant.ghost => AppColors.primary,
      };

  List<BoxShadow> get _shadows => switch (widget.variant) {
        AppButtonVariant.primary => AppTheme.primaryShadow,
        _ => [],
      };

  Border? get _border => switch (widget.variant) {
        AppButtonVariant.outline =>
          Border.all(color: AppColors.primary, width: 1.5),
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.fullWidth ? double.infinity : null,
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: AppTheme.radiusFull,
            border: _border,
            boxShadow: _shadows,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisSize:
                widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.loading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(_fg),
                  ),
                )
              else ...[
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: _fg, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(widget.label,
                    style: AppText.labelMd.copyWith(color: _fg)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
