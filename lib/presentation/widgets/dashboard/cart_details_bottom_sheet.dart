import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/cart_item_model.dart';
import '../../../business/bloc/dashboard/dashboard_bloc.dart';

class CartDetailsBottomSheet extends StatelessWidget {
  final List<CartItemModel> cartItems;
  final double total;

  const CartDetailsBottomSheet({
    super.key,
    required this.cartItems,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkCharcoal,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cart Details',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.darkGrey,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                  onPressed: () {
                    context.read<DashboardBloc>().add(const DashboardHideCartDetails());
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Cart Items List
          if (cartItems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'Your cart is empty',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                ),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  return _buildCartItem(context, cartItem);
                },
              ),
            ),

          // Total and Checkout
          if (cartItems.isNotEmpty) ...[
            const Divider(color: AppColors.darkGrey),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${total.toStringAsFixed(2)} \$',
                        style: const TextStyle(
                          color: AppColors.orangeRed,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle checkout
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightRed,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Checkout',
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
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItemModel cartItem) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkGrey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              cartItem.product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: AppColors.darkGrey,
                  child: const Icon(
                    Icons.fastfood,
                    color: AppColors.white,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${cartItem.product.discountedPrice.toStringAsFixed(2)} \$ x ${cartItem.quantity}',
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity and Remove
          Column(
            children: [
              Text(
                '${cartItem.lineTotal.toStringAsFixed(2)} \$',
                style: const TextStyle(
                  color: AppColors.orangeRed,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.coralRed,
                  size: 20,
                ),
                onPressed: () {
                  context.read<DashboardBloc>().add(
                        DashboardRemoveCartItem(cartItem.id),
                      );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
