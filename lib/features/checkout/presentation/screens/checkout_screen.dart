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
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../domain/entities/order_entity.dart';
import '../controllers/checkout_controller.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  void _showOrderSuccessDialog(BuildContext context, OrderEntity order) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'OrderPlaced',
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (ctx, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.elasticOut),
          child: child,
        );
      },
      pageBuilder: (ctx, anim1, anim2) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          contentPadding: const EdgeInsets.all(AppSpacing.xl),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Checkmark Icon Container
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 54,
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                'Order Placed!',
                style: AppTextStyles.displayMedium.copyWith(fontSize: 22),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Your payment was verified via Razorpay.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                  border: Border.all(color: AppColors.lightBorder),
                ),
                child: Column(
                  children: [
                    Text('Order Reference', style: AppTextStyles.labelSmall),
                    const SizedBox(height: 2),
                    Text(
                      order.orderId,
                      style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                    ),
                    if (order.paymentId != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Payment ID: ${order.paymentId}',
                        style: AppTextStyles.labelSmall.copyWith(fontSize: 10),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                text: 'Back to Home',
                onPressed: () {
                  Navigator.pop(ctx);
                  context.go(AppRoutes.home);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cartCtrl = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Delivery Address Section with GetBuilder
            Text('Shipping Address', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.s),
            GetBuilder<CheckoutController>(
              id: GetBuilderIds.addressSelector,
              builder: (ctrl) {
                final addr = ctrl.address;
                return AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                        ),
                        child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(addr.fullName, style: AppTextStyles.labelLarge),
                            const SizedBox(height: 4),
                            Text(
                              addr.formattedAddress,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Phone: ${addr.phone}',
                              style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: () {
                          // Quick address edit prompt
                          final streetController = TextEditingController(text: addr.street);
                          showDialog(
                            context: context,
                            builder: (dialogCtx) => AlertDialog(
                              title: const Text('Edit Delivery Address'),
                              content: TextField(
                                controller: streetController,
                                decoration: const InputDecoration(labelText: 'Street Address'),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogCtx),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    ctrl.updateShippingAddress(
                                      ShippingAddressEntity(
                                        fullName: addr.fullName,
                                        phone: addr.phone,
                                        street: streetController.text,
                                        city: addr.city,
                                        state: addr.state,
                                        postalCode: addr.postalCode,
                                      ),
                                    );
                                    Navigator.pop(dialogCtx);
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: AppSpacing.l),

            // 2. Payment Method Selector with GetBuilder
            Text('Payment Method', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.s),
            GetBuilder<CheckoutController>(
              id: GetBuilderIds.paymentMethodSelector,
              builder: (ctrl) {
                return Column(
                  children: [
                    _buildPaymentOption(
                      context: context,
                      title: 'Razorpay Gateway',
                      subtitle: 'UPI, Credit/Debit Cards, NetBanking, Wallets',
                      icon: Icons.credit_card_rounded,
                      method: PaymentMethod.razorpay,
                      selectedMethod: ctrl.selectedPaymentMethod,
                      onTap: () => ctrl.selectPaymentMethod(PaymentMethod.razorpay),
                      badgeText: 'RECOMMENDED',
                    ),
                    const SizedBox(height: AppSpacing.s),
                    _buildPaymentOption(
                      context: context,
                      title: 'Cash on Delivery',
                      subtitle: 'Pay with cash upon package receipt',
                      icon: Icons.payments_outlined,
                      method: PaymentMethod.cod,
                      selectedMethod: ctrl.selectedPaymentMethod,
                      onTap: () => ctrl.selectPaymentMethod(PaymentMethod.cod),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: AppSpacing.l),

            // 3. Order Items Quick Review
            Text('Items in Order (${cartCtrl.totalQuantity})', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.s),
            AppCard(
              child: Column(
                children: cartCtrl.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text('${item.quantity}x ', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                        Expanded(
                          child: Text(
                            item.product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                        Text(
                          '${AppConstants.currencySymbol}${item.totalPrice.toStringAsFixed(2)}',
                          style: AppTextStyles.labelMedium,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: AppSpacing.l),

            // 4. Price Breakdown
            AppCard(
              child: Column(
                children: [
                  _buildRow(context, 'Subtotal', '${AppConstants.currencySymbol}${cartCtrl.subtotal.toStringAsFixed(2)}'),
                  if (cartCtrl.discountAmount > 0)
                    _buildRow(
                      context, 'Discount',
                      '-${AppConstants.currencySymbol}${cartCtrl.discountAmount.toStringAsFixed(2)}',
                      color: AppColors.success,
                    ),
                  _buildRow(context, 'Tax (GST)', '${AppConstants.currencySymbol}${cartCtrl.taxAmount.toStringAsFixed(2)}'),
                  _buildRow(context, 'Shipping', cartCtrl.shippingAmount == 0 ? 'FREE' : '${AppConstants.currencySymbol}${cartCtrl.shippingAmount.toStringAsFixed(2)}'),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Payable', style: AppTextStyles.titleMedium),
                      Text(
                        '${AppConstants.currencySymbol}${cartCtrl.total.toStringAsFixed(2)}',
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // 5. Place Order Action Button with GetBuilder
            GetBuilder<CheckoutController>(
              id: GetBuilderIds.placeOrderButton,
              builder: (ctrl) => AppButton(
                text: ctrl.selectedPaymentMethod == PaymentMethod.razorpay
                    ? 'Pay with Razorpay (${AppConstants.currencySymbol}${cartCtrl.total.toStringAsFixed(2)})'
                    : 'Confirm & Place Order',
                icon: Icons.verified_user_rounded,
                isLoading: ctrl.isProcessing,
                onPressed: () {
                  ctrl.startCheckout(
                    onSuccess: () {
                      if (ctrl.lastCompletedOrder != null) {
                        _showOrderSuccessDialog(context, ctrl.lastCompletedOrder!);
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required PaymentMethod method,
    required PaymentMethod selectedMethod,
    required VoidCallback onTap,
    String? badgeText,
  }) {
    final isSelected = method == selectedMethod;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : Colors.black54),
              size: 28,
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: AppTextStyles.labelLarge),
                      if (badgeText != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(25),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badgeText,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : (isDark ? Colors.white38 : Colors.black26),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          Text(value, style: AppTextStyles.labelMedium.copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
