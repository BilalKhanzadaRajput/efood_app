import 'package:equatable/equatable.dart';
import 'food_item_model.dart';

class CartItemModel extends Equatable {
  final String id;
  final FoodItemModel product;
  final int quantity;
  final List<String> modifiers;

  const CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    this.modifiers = const [],
  });

  CartItemModel copyWith({
    String? id,
    FoodItemModel? product,
    int? quantity,
    List<String>? modifiers,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      modifiers: modifiers ?? this.modifiers,
    );
  }

  double get unitPrice => product.discountedPrice;

  double get lineTotal => unitPrice * quantity;

  double get originalLineTotal => product.price * quantity;

  double get lineDiscount => originalLineTotal - lineTotal;

  @override
  List<Object> get props => [
    id,
    product.id,
    product.name,
    product.price,
    product.discount ?? 0,
    quantity,
    modifiers,
  ];
}
