import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class DashboardHeaderWidget extends StatelessWidget {
  final int cartItemCount;
  final VoidCallback? onCartTap;

  const DashboardHeaderWidget({
    super.key,
    required this.cartItemCount,
    this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // eFood Logo
          Row(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Text(
                    'e',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.coralText,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  Positioned(
                    top: -4,
                    child: Icon(
                      Icons.restaurant_menu,
                      color: scheme.onSurface,
                      size: 16,
                    ),
                  ),
                ],
              ),
              Text(
                'Food',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orangeRed,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),

          // Shopping Cart
          GestureDetector(
            onTap: onCartTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: scheme.onSurface,
                  size: 28,
                ),
                if (cartItemCount > 0)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.coralRed,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        cartItemCount.toString(),
                        style: TextStyle(
                          color: scheme.onPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
