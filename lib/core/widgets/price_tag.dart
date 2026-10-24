import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class PriceTag extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final TextStyle? priceStyle;
  final bool showCurrency;

  const PriceTag({
    super.key,
    required this.price,
    this.originalPrice,
    this.priceStyle,
    this.showCurrency = true,
  });

  String _formatPrice(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currency = showCurrency ? AppConstants.currencySymbol : '';
    final hasDiscount = originalPrice != null && originalPrice! > price;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            '$currency${_formatPrice(price)}',
            style: priceStyle ?? AppTextStyles.priceStyle.copyWith(color: AppColors.primary),
          ),
          if (hasDiscount) ...[
            const SizedBox(width: 6),
            Text(
              '$currency${_formatPrice(originalPrice!)}',
              style: AppTextStyles.bodySmall.copyWith(
                decoration: TextDecoration.lineThrough,
                color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
