import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/get_builder_ids.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/product_controller.dart';

class CategoryPills extends StatelessWidget {
  const CategoryPills({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      id: GetBuilderIds.categorySelector,
      builder: (controller) {
        if (controller.categories.isEmpty) {
          return const SizedBox(height: 40);
        }

        return SizedBox(
          height: 42,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s),
            itemBuilder: (context, index) {
              final cat = controller.categories[index];
              final isSelected = controller.selectedCategory == cat.id;

              return FilterChip(
                selected: isSelected,
                label: Text(cat.name),
                labelStyle: AppTextStyles.labelMedium.copyWith(
                  color: isSelected ? Colors.white : null,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
                backgroundColor: Theme.of(context).cardTheme.color,
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                onSelected: (_) => controller.selectCategory(cat.id),
              );
            },
          ),
        );
      },
    );
  }
}
