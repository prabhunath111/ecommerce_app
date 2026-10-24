import '../../../products/data/models/product_model.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.product,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
    );
  }

  factory CartItemModel.fromApiResponse(
    Map<String, dynamic> json, {
    ProductEntity? fallbackProduct,
  }) {
    final rawProduct = json['product'];
    ProductModel parsedProduct;
    if (rawProduct is Map<String, dynamic>) {
      final pModel = ProductModel.fromJson(rawProduct);
      if (fallbackProduct != null && (pModel.id == fallbackProduct.id || pModel.id.isEmpty)) {
        parsedProduct = ProductModel(
          id: pModel.id.isNotEmpty ? pModel.id : fallbackProduct.id,
          title: pModel.title.isNotEmpty ? pModel.title : fallbackProduct.title,
          price: pModel.price > 0 ? pModel.price : fallbackProduct.price,
          originalPrice: pModel.originalPrice ?? fallbackProduct.originalPrice,
          description: pModel.description.isNotEmpty ? pModel.description : fallbackProduct.description,
          category: pModel.category.isNotEmpty ? pModel.category : fallbackProduct.category,
          image: pModel.image.isNotEmpty ? pModel.image : fallbackProduct.image,
          rating: pModel.rating > 0 ? pModel.rating : fallbackProduct.rating,
          ratingCount: pModel.ratingCount > 0 ? pModel.ratingCount : fallbackProduct.ratingCount,
          isFavorite: fallbackProduct.isFavorite,
        );
      } else {
        parsedProduct = pModel;
      }
    } else if (fallbackProduct != null) {
      parsedProduct = ProductModel(
        id: fallbackProduct.id,
        title: fallbackProduct.title,
        price: fallbackProduct.price,
        originalPrice: fallbackProduct.originalPrice,
        description: fallbackProduct.description,
        category: fallbackProduct.category,
        image: fallbackProduct.image,
        rating: fallbackProduct.rating,
        ratingCount: fallbackProduct.ratingCount,
        isFavorite: fallbackProduct.isFavorite,
      );
    } else {
      parsedProduct = const ProductModel(
        id: '',
        title: 'Product',
        price: 0.0,
        description: '',
        category: 'General',
        image: '',
        rating: 0.0,
        ratingCount: 0,
      );
    }

    final id = json['id']?.toString() ?? json['_id']?.toString() ?? 'cart_${parsedProduct.id}';
    final qty = (json['quantity'] as num?)?.toInt() ?? 1;

    return CartItemModel(
      id: id,
      product: parsedProduct,
      quantity: qty,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': (product is ProductModel)
          ? (product as ProductModel).toJson()
          : ProductModel(
              id: product.id,
              title: product.title,
              price: product.price,
              originalPrice: product.originalPrice,
              description: product.description,
              category: product.category,
              image: product.image,
              rating: product.rating,
              ratingCount: product.ratingCount,
              isFavorite: product.isFavorite,
            ).toJson(),
      'quantity': quantity,
    };
  }
}
