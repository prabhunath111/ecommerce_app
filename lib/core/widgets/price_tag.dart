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

  @override
  Widget build(BuildContext context) {
    final currency = showCurrency ? AppConstants.currencySymbol : '';
    final hasDiscount = originalPrice != null && originalPrice! > price;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '$currency${price.toStringAsFixed(2)}',
          style: priceStyle ?? AppTextStyles.priceStyle.copyWith(color: AppColors.primary),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: 6),
          Text(
            '$currency${originalPrice!.toStringAsFixed(2)}',
            style: AppTextStyles.bodySmall.copyWith(
              decoration: TextDecoration.lineThrough,
              color: AppColors.lightTextTertiary,
            ),
          ),
        ],
      ],
    );
  }
}
