import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/get_builder_ids.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/animated_scale_button.dart';
import '../../../../core/widgets/price_tag.dart';
import '../../../../core/widgets/rating_bar.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../domain/entities/product_entity.dart';
import '../controllers/product_controller.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final int index;

  const ProductCard({
    super.key,
    required this.product,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedScaleButton(
      scaleValue: 0.96,
      onTap: () {
        context.push('${AppRoutes.products}/${product.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 0.8,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(6),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Favorite Overlay & Hero
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppSpacing.radiusM),
                    ),
                    child: Hero(
                      tag: 'product_image_${product.id}',
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight,
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                          child: const Icon(Icons.broken_image_rounded, size: 32),
                        ),
                      ),
                    ),
                  ),

                  // Favorite Button listening specifically to GetBuilderIds.productFavorite(id)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GetBuilder<ProductController>(
                      id: GetBuilderIds.productFavorite(product.id),
                      builder: (controller) {
                        final currentProduct = controller.products.firstWhereOrNull((p) => p.id == product.id) ?? product;
                        final isFav = currentProduct.isFavorite;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => controller.toggleFavorite(product.id),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: (isDark ? Colors.black : Colors.white).withAlpha(200),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(25),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                size: 18,
                                color: isFav ? AppColors.accent : (isDark ? Colors.white70 : Colors.black54),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating Bar
                  RatingBar(rating: product.rating, reviewCount: product.ratingCount),
                  const SizedBox(height: AppSpacing.xs),

                  // Title
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Price and Quick Add to Cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: PriceTag(
                          price: product.price,
                          originalPrice: product.originalPrice,
                        ),
                      ),
                      // Quick Add Button with Bounce
                      AnimatedScaleButton(
                        scaleValue: 0.85,
                        onTap: () {
                          final cartController = Get.find<CartController>();
                          cartController.addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added "${product.title}" to cart!'),
                              duration: const Duration(milliseconds: 1200),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryLight],
                            ),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
