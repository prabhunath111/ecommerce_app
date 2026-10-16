import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double starSize;

  const RatingBar({
    super.key,
    required this.rating,
    this.reviewCount,
    this.starSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          color: AppColors.amber,
          size: starSize,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.lightTextTertiary),
          ),
        ],
      ],
    );
  }
}
