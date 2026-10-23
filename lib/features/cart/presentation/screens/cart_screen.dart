import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/get_builder_ids.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/price_tag.dart';
import '../controllers/cart_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          GetBuilder<CartController>(
            id: GetBuilderIds.cartList,
            builder: (controller) {
              if (controller.isEmpty) return const SizedBox.shrink();
              return TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Clear Cart'),
                      content: const Text('Are you sure you want to remove all items from your cart?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.clearCart();
                            Navigator.pop(ctx);
                          },
                          child: const Text('Clear', style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete_sweep_rounded, size: 20, color: AppColors.error),
                label: const Text('Clear', style: TextStyle(color: AppColors.error)),
              );
            },
          ),
        ],
      ),
      body: GetBuilder<CartController>(
        id: GetBuilderIds.cartList,
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (controller.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.shopping_bag_outlined,
              title: 'Your Cart is Empty',
              message: 'Looks like you haven\'t added any items to your bag yet.',
              buttonText: 'Start Shopping',
              onButtonPressed: () => context.go(AppRoutes.home),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  itemCount: controller.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.m),
                  itemBuilder: (context, index) {
                    final item = controller.items[index];

                    return Dismissible(
                      key: Key('dismiss_${item.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                        ),
                        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
                      ),
                      onDismissed: (_) {
                        controller.removeItem(item.id);
                      },
                      child: AppCard(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Row(
                          children: [
                            // Product Image Thumbnail
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                              child: Container(
                                height: 75,
                                width: 75,
                                color: isDark ? AppColors.darkSurface : Colors.grey.shade100,
                                child: CachedNetworkImage(
                                  imageUrl: item.product.image,
                                  fit: BoxFit.cover,
                                  placeholder: (_, _) => const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  ),
                                  errorWidget: (_, _, _) => const Icon(Icons.broken_image_rounded),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.m),

                            // Title & Price
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.labelLarge,
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  PriceTag(price: item.product.price),
                                ],
                              ),
                            ),

                            // Quantity Adjuster with granular GetBuilder ID
                            GetBuilder<CartController>(
                              id: GetBuilderIds.cartItemQuantity(item.id),
                              builder: (ctrl) {
                                final currentItem = ctrl.items.firstWhereOrNull((i) => i.id == item.id) ?? item;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                                    border: Border.all(
                                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove, size: 16),
                                        onPressed: () => ctrl.decrementQuantity(currentItem.id),
                                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                        padding: EdgeInsets.zero,
                                      ),
                                      Text(
                                        '${currentItem.quantity}',
                                        style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add, size: 16),
                                        onPressed: () => ctrl.incrementQuantity(currentItem.id),
                                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Order Summary Sheet
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
                      color: Colors.black.withAlpha(8),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Promo Code Input listening to promoCodeSection ID
                      GetBuilder<CartController>(
                        id: GetBuilderIds.promoCodeSection,
                        builder: (ctrl) {
                          if (ctrl.appliedPromo != null) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: AppSpacing.m),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.success.withAlpha(20),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                                border: Border.all(color: AppColors.success.withAlpha(80)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                                  const SizedBox(width: AppSpacing.s),
                                  Text(
                                    'Coupon "${ctrl.appliedPromo}" applied',
                                    style: AppTextStyles.labelMedium.copyWith(color: AppColors.success),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: ctrl.removePromo,
                                    child: const Icon(Icons.close_rounded, size: 18, color: AppColors.error),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.m),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _promoController,
                                    textCapitalization: TextCapitalization.characters,
                                    decoration: const InputDecoration(
                                      hintText: 'Promo code (try TRENDY30)',
                                      prefixIcon: Icon(Icons.local_offer_outlined, size: 18),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.s),
                                ElevatedButton(
                                  onPressed: () {
                                    final success = ctrl.applyPromo(_promoController.text);
                                    if (!success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Invalid code! Try TRENDY30 or SAVE10'),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                  child: const Text('Apply'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // Order Summary Breakdown listening to cartSummary ID
                      GetBuilder<CartController>(
                        id: GetBuilderIds.cartSummary,
                        builder: (ctrl) {
                          return Column(
                            children: [
                              _buildSummaryRow('Subtotal', '${AppConstants.currencySymbol}${ctrl.subtotal.toStringAsFixed(2)}'),
                              if (ctrl.discountAmount > 0)
                                _buildSummaryRow(
                                  'Discount',
                                  '-${AppConstants.currencySymbol}${ctrl.discountAmount.toStringAsFixed(2)}',
                                  valueColor: AppColors.success,
                                ),
                              _buildSummaryRow('Estimated Tax (5%)', '${AppConstants.currencySymbol}${ctrl.taxAmount.toStringAsFixed(2)}'),
                              _buildSummaryRow(
                                'Shipping',
                                ctrl.shippingAmount == 0.0 ? 'FREE' : '${AppConstants.currencySymbol}${ctrl.shippingAmount.toStringAsFixed(2)}',
                                valueColor: ctrl.shippingAmount == 0.0 ? AppColors.success : null,
                              ),
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Amount', style: AppTextStyles.titleMedium),
                                  Text(
                                    '${AppConstants.currencySymbol}${ctrl.total.toStringAsFixed(2)}',
                                    style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: AppSpacing.m),

                      // Checkout CTA
                      AppButton(
                        text: 'Proceed to Checkout',
                        icon: Icons.lock_outline_rounded,
                        onPressed: () => context.push(AppRoutes.checkout),
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

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.labelMedium.copyWith(color: valueColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
