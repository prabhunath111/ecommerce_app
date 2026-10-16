import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/get_builder_ids.dart';
import '../../../../core/services/payment_service.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/checkout_usecases.dart';

class CheckoutController extends GetxController {
  final PlaceOrderUseCase placeOrderUseCase;
  final PaymentService paymentService;

  CheckoutController({
    required this.placeOrderUseCase,
    required this.paymentService,
  });

  ShippingAddressEntity _address = const ShippingAddressEntity(
    fullName: 'Alex Morgan',
    phone: '+91 98765 43210',
    street: '42 High Street, Suite 4B',
    city: 'Bangalore',
    state: 'Karnataka',
    postalCode: '560038',
  );

  PaymentMethod _selectedPaymentMethod = PaymentMethod.razorpay;
  bool _isProcessing = false;
  String? _lastPaymentId;
  OrderEntity? _lastCompletedOrder;

  ShippingAddressEntity get address => _address;
  PaymentMethod get selectedPaymentMethod => _selectedPaymentMethod;
  bool get isProcessing => _isProcessing;
  OrderEntity? get lastCompletedOrder => _lastCompletedOrder;

  @override
  void onInit() {
    super.onInit();
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    paymentService.initialize(
      onSuccess: (successResult) {
        _lastPaymentId = successResult.paymentId;
        _finalizeOrderPlacement();
      },
      onError: (errorResult) {
        _isProcessing = false;
        update([GetBuilderIds.placeOrderButton]);
        Get.snackbar(
          'Payment Incomplete',
          errorResult.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      },
      onExternalWallet: (walletName) {
        debugPrint('[Checkout] Selected external wallet: $walletName');
      },
    );
  }

  void selectPaymentMethod(PaymentMethod method) {
    _selectedPaymentMethod = method;
    update([GetBuilderIds.paymentMethodSelector]);
  }

  void updateShippingAddress(ShippingAddressEntity newAddress) {
    _address = newAddress;
    update([GetBuilderIds.addressSelector]);
  }

  VoidCallback? _onSuccessCallback;

  Future<void> startCheckout({required VoidCallback onSuccess}) async {
    final cartController = Get.find<CartController>();
    if (cartController.isEmpty) {
      Get.snackbar('Cart is empty', 'Add items before proceeding to checkout');
      return;
    }

    _isProcessing = true;
    _onSuccessCallback = onSuccess;
    update([GetBuilderIds.placeOrderButton]);

    final authController = Get.find<AuthController>();
    final user = authController.currentUser;

    if (_selectedPaymentMethod == PaymentMethod.razorpay) {
      // Launch Razorpay gateway
      final request = PaymentRequest(
        amount: cartController.total,
        orderId: 'order_${DateTime.now().millisecondsSinceEpoch}',
        description: 'Trendify Fashion Purchase',
        userEmail: user?.email ?? 'customer@trendify.com',
        userContact: _address.phone,
      );

      await paymentService.openCheckout(request);
    } else {
      // COD or Mock instant payment
      await Future.delayed(const Duration(milliseconds: 900));
      _lastPaymentId = 'pay_${_selectedPaymentMethod.name}_${DateTime.now().millisecondsSinceEpoch}';
      await _finalizeOrderPlacement();
    }
  }

  Future<void> _finalizeOrderPlacement() async {
    final cartController = Get.find<CartController>();

    final order = OrderEntity(
      orderId: 'ORD-#${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
      items: List.from(cartController.items),
      totalAmount: cartController.total,
      shippingAddress: _address,
      paymentMethod: _selectedPaymentMethod,
      paymentId: _lastPaymentId,
      createdAt: DateTime.now(),
      status: 'Confirmed',
    );

    final result = await placeOrderUseCase(order);
    result.fold(
      (failure) {
        _isProcessing = false;
        update([GetBuilderIds.placeOrderButton]);
        Get.snackbar('Order Error', failure.message);
      },
      (placedOrder) async {
        _lastCompletedOrder = placedOrder;
        await cartController.clearCart();
        _isProcessing = false;
        update([GetBuilderIds.placeOrderButton]);
        _onSuccessCallback?.call();
      },
    );
  }

  @override
  void onClose() {
    paymentService.dispose();
    super.onClose();
  }
}
