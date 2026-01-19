import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/food_item_model.dart';
import '../../../business/bloc/dashboard/dashboard_bloc.dart';

class ProductDetailBottomSheet extends StatelessWidget {
  final FoodItemModel product;
  final int quantity;

  const ProductDetailBottomSheet({
    super.key,
    required this.product,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final discountedPrice = product.discountedPrice;
    final totalPrice = discountedPrice * quantity;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: scheme.onSurface.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: scheme.onSurface, size: 20),
              ),
              onPressed: () {
                final dashboardBloc = context.read<DashboardBloc>();
                Navigator.pop(context);
                // Clear selected product after bottom sheet is closed
                Future.delayed(const Duration(milliseconds: 50), () {
                  dashboardBloc.add(const DashboardCloseProductDetail());
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image and Info Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            product.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 100,
                                color: scheme.onSurface.withOpacity(0.08),
                                child: Icon(
                                  Icons.fastfood,
                                  color: scheme.onSurface,
                                ),
                              );
                            },
                          ),
                        ),
                        // Discount Badge
                        if (product.discount != null)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.coralRed,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Text(
                                '${product.discount!.toStringAsFixed(1)}\$ OFF',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    // Product Name and Price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              color: scheme.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '${discountedPrice.toStringAsFixed(2)} \$',
                                style: TextStyle(
                                  color: scheme.onSurface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (product.discount != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '${product.price.toStringAsFixed(2)} \$',
                                  style: TextStyle(
                                    color: scheme.onSurface.withOpacity(0.5),
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Description
                if (product.description != null) ...[
                  Text(
                    'Description',
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description!,
                    style: TextStyle(
                      color: scheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Dietary Info and Quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dietary Label
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.onSurface.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            product.isVeg ? Icons.eco : Icons.restaurant,
                            color: scheme.onSurface,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            product.isVeg ? 'Veg' : 'Non Veg',
                            style: TextStyle(
                              color: scheme.onSurface,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Quantity Selector
                    Row(
                      children: [
                        IconButton(
                          icon: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: scheme.onSurface.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.remove,
                              color: scheme.onSurface,
                              size: 20,
                            ),
                          ),
                          onPressed: quantity > 1
                              ? () {
                                  context.read<DashboardBloc>().add(
                                    DashboardUpdateQuantity(
                                      product.id,
                                      quantity - 1,
                                    ),
                                  );
                                }
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            quantity.toString(),
                            style: TextStyle(
                              color: scheme.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: scheme.onSurface.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.add,
                              color: scheme.onSurface,
                              size: 20,
                            ),
                          ),
                          onPressed: () {
                            context.read<DashboardBloc>().add(
                              DashboardUpdateQuantity(product.id, quantity + 1),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Total and Add to Cart
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Total
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${totalPrice.toStringAsFixed(2)} \$',
                              style: TextStyle(
                                color: scheme.onSurface,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (product.discount != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                '(${(product.price * quantity).toStringAsFixed(2)} \$)',
                                style: TextStyle(
                                  color: scheme.onSurface.withOpacity(0.5),
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),

                    // Add to Cart Button
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            final dashboardBloc = context.read<DashboardBloc>();
                            // Add to cart first (this clears selectedProduct),
                            // then close the sheet to avoid it reopening.
                            dashboardBloc.add(DashboardAddToCart(product.id));
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightRed,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
