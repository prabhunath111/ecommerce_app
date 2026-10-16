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
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/price_tag.dart';
import '../../../../core/widgets/rating_bar.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../controllers/product_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedQuantity = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProductController>().loadProductDetail(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Favorite button listening to ID
          GetBuilder<ProductController>(
            id: GetBuilderIds.productFavorite(widget.productId),
            builder: (controller) {
              final prod = controller.products.firstWhereOrNull((p) => p.id == widget.productId) ?? controller.selectedProduct;
              final isFav = prod?.isFavorite ?? false;

              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFav ? AppColors.accent : null,
                ),
                onPressed: () => controller.toggleFavorite(widget.productId),
              );
            },
          ),
          // Cart badge
          GetBuilder<CartController>(
            id: GetBuilderIds.cartBadge,
            builder: (cartCtrl) => Padding(
              padding: const EdgeInsets.only(right: AppSpacing.m),
              child: IconButton(
                icon: AppBadge(
                  count: cartCtrl.totalQuantity,
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
                onPressed: () => context.push(AppRoutes.cart),
              ),
            ),
          ),
        ],
      ),
      body: GetBuilder<ProductController>(
        id: GetBuilderIds.productDetail,
        builder: (controller) {
          final product = controller.selectedProduct;
          if (product == null) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Image container
                      Container(
                        height: 320,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
                          child: Hero(
                            tag: 'product_image_${product.id}',
                            child: CachedNetworkImage(
                              imageUrl: product.image,
                              fit: BoxFit.contain,
                              placeholder: (_, _) => const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              errorWidget: (_, _, _) => const Icon(
                                Icons.broken_image_rounded,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.l),

                      // Category Pill and Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(25),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            ),
                            child: Text(
                              product.category.toUpperCase(),
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          RatingBar(
                            rating: product.rating,
                            reviewCount: product.ratingCount,
                            starSize: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Product Title
                      Text(product.title, style: AppTextStyles.titleLarge),
                      const SizedBox(height: AppSpacing.sm),

                      // Pricing
                      PriceTag(
                        price: product.price,
                        originalPrice: product.originalPrice,
                        priceStyle: AppTextStyles.displayMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.m),
                      const Divider(),
                      const SizedBox(height: AppSpacing.m),

                      // Description
                      Text('Product Details', style: AppTextStyles.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        product.description,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),

              // Bottom Checkout / Add to Cart Bar
              Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      // Quantity Selector
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: _selectedQuantity > 1
                                  ? () => setState(() => _selectedQuantity--)
                                  : null,
                            ),
                            Text(
                              '$_selectedQuantity',
                              style: AppTextStyles.labelLarge,
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () => setState(() => _selectedQuantity++),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),

                      // Add to Cart Action Button
                      Expanded(
                        child: AnimatedScaleButton(
                          onTap: () {
                            final cartController = Get.find<CartController>();
                            cartController.addToCart(product, quantity: _selectedQuantity);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Added $_selectedQuantity x "${product.title}" to cart!',
                                ),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                action: SnackBarAction(
                                  label: 'View Cart',
                                  textColor: Colors.white,
                                  onPressed: () => context.push(AppRoutes.cart),
                                ),
                              ),
                            );
                          },
                          child: AppButton(
                            text: 'Add to Cart',
                            icon: Icons.shopping_bag_outlined,
                            onPressed: () {
                              final cartController = Get.find<CartController>();
                              cartController.addToCart(product, quantity: _selectedQuantity);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Added $_selectedQuantity x "${product.title}" to cart!',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  action: SnackBarAction(
                                    label: 'View Cart',
                                    textColor: Colors.white,
                                    onPressed: () => context.push(AppRoutes.cart),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
