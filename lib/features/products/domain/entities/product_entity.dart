import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final double price;
  final double? originalPrice;
  final String description;
  final String category;
  final String image;
  final double rating;
  final int ratingCount;
  final bool isFavorite;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    this.originalPrice,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required this.ratingCount,
    this.isFavorite = false,
  });

  ProductEntity copyWith({
    String? id,
    String? title,
    double? price,
    double? originalPrice,
    String? description,
    String? category,
    String? image,
    double? rating,
    int? ratingCount,
    bool? isFavorite,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        price,
        originalPrice,
        description,
        category,
        image,
        rating,
        ratingCount,
        isFavorite,
      ];
}

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String? icon;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.icon,
  });

  @override
  List<Object?> get props => [id, name, icon];
}
