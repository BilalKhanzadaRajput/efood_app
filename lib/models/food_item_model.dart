class FoodItemModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int? quantity;
  final String? category;
  final bool isVeg;
  final bool isHalal;
  final double? discount;
  final String? description;

  const FoodItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity,
    this.category,
    this.isVeg = false,
    this.isHalal = false,
    this.discount,
    this.description,
  });

  FoodItemModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
    String? category,
    bool? isVeg,
    bool? isHalal,
    double? discount,
    String? description,
  }) {
    return FoodItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      isVeg: isVeg ?? this.isVeg,
      isHalal: isHalal ?? this.isHalal,
      discount: discount ?? this.discount,
      description: description ?? this.description,
    );
  }

  double get discountedPrice {
    if (discount != null) {
      return price - discount!;
    }
    return price;
  }
}
