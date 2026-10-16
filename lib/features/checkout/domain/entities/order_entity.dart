import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';

class ShippingAddressEntity extends Equatable {
  final String fullName;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  const ShippingAddressEntity({
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    this.country = 'India',
  });

  String get formattedAddress => '$street, $city, $state - $postalCode, $country';

  @override
  List<Object?> get props => [fullName, phone, street, city, state, postalCode, country];
}

enum PaymentMethod { razorpay, upi, card, cod }

class OrderEntity extends Equatable {
  final String orderId;
  final List<CartItemEntity> items;
  final double totalAmount;
  final ShippingAddressEntity shippingAddress;
  final PaymentMethod paymentMethod;
  final String? paymentId;
  final DateTime createdAt;
  final String status;

  const OrderEntity({
    required this.orderId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.paymentMethod,
    this.paymentId,
    required this.createdAt,
    this.status = 'Confirmed',
  });

  @override
  List<Object?> get props => [
        orderId,
        items,
        totalAmount,
        shippingAddress,
        paymentMethod,
        paymentId,
        createdAt,
        status,
      ];
}
