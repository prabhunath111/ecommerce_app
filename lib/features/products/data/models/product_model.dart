import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    super.originalPrice,
    required super.description,
    required super.category,
    required super.image,
    required super.rating,
    required super.ratingCount,
    super.isFavorite,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final double rawPrice = (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0;
    final ratingMap = json['rating'] is Map ? json['rating'] as Map<String, dynamic> : null;
    final double rawRating = ratingMap != null && ratingMap['rate'] is num
        ? (ratingMap['rate'] as num).toDouble()
        : 4.5;
    final int rawRatingCount = ratingMap != null && ratingMap['count'] is num
        ? (ratingMap['count'] as num).toInt()
        : 120;
    final id = json['_id']?.toString() ?? json['_id']?.toString() ?? '';

    return ProductModel(
      id: id,//json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      price: rawPrice,
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : (rawPrice * 1.25),
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? 'General',
      image: json['image']?.toString() ?? '',
      rating: rawRating,
      ratingCount: rawRatingCount,
      isFavorite: json['isFavorite'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'originalPrice': originalPrice,
      'description': description,
      'category': category,
      'image': image,
      'rating': {'rate': rating, 'count': ratingCount},
      'isFavorite': isFavorite,
    };
  }

  ProductEntity toEntity() => this;
}

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    super.icon,
  });

  factory CategoryModel.fromJson(dynamic json) {
    if (json is String) {
      return CategoryModel(id: json, name: json);
    }
    final map = json as Map<String, dynamic>;
    return CategoryModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      icon: map['icon']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'icon': icon};
}
