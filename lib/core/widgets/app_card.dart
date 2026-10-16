import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final double? borderRadius;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.cardPadding,
    this.onTap,
    this.color,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultRadius = BorderRadius.circular(borderRadius ?? AppSpacing.radiusM);

    final cardWidget = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? (isDark ? theme.cardTheme.color : Colors.white),
        borderRadius: defaultRadius,
        border: border ??
            Border.all(
              color: isDark ? Colors.white.withAlpha(20) : Colors.black.withAlpha(15),
              width: 1,
            ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: defaultRadius,
          onTap: onTap,
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }
}
