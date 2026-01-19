import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../models/cart_item_model.dart';
import '../../business/bloc/dashboard/dashboard_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'My Cart',
          style: TextStyle(
            color: scheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is! DashboardLoaded) return const SizedBox.shrink();
              if (state.cartItems.isEmpty) return const SizedBox.shrink();

              return TextButton(
                onPressed: () {
                  context.read<DashboardBloc>().add(const DashboardClearCart());
                },
                child: Text(
                  'Clear',
                  style: const TextStyle(
                    color: AppColors.coralRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading || state is DashboardInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.coralRed),
              );
            }

            if (state is DashboardError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    state.message,
                    style: TextStyle(color: scheme.onSurface),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (state is! DashboardLoaded) return const SizedBox.shrink();

            if (state.cartItems.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: scheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(
                          color: scheme.onSurface.withOpacity(0.85),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add some delicious food from the dashboard.',
                        style: TextStyle(
                          color: scheme.onSurface.withOpacity(0.55),
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightRed,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Browse items'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = state.cartItems[index];
                      return _CartItemTile(item: item);
                    },
                  ),
                ),
                _CartSummaryBar(
                  total: state.cartTotal,
                  itemCount: state.cartItemCount,
                  onCheckout: () {
                    // TODO: hook checkout flow
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Checkout not implemented')),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItemModel item;

  const _CartItemTile({required this.item});

  Future<bool> _confirmRemove(BuildContext context) async {
    final scheme = Theme.of(context).colorScheme;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            'Remove item?',
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Remove "${item.product.name}" from your cart?',
            style: TextStyle(color: scheme.onSurface.withOpacity(0.8)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                'Cancel',
                style: TextStyle(color: scheme.onSurface.withOpacity(0.8)),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coralRed,
                foregroundColor: scheme.onPrimary,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.product.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 64,
                  height: 64,
                  color: scheme.onSurface.withOpacity(0.08),
                  child: Icon(Icons.fastfood, color: scheme.onSurface),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.unitPrice.toStringAsFixed(2)} \$ x ${item.quantity}',
                  style: TextStyle(
                    color: scheme.onSurface.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.lineTotal.toStringAsFixed(2)} \$',
                style: const TextStyle(
                  color: AppColors.orangeRed,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.coralRed,
                  size: 20,
                ),
                onPressed: () async {
                  final confirmed = await _confirmRemove(context);
                  if (!context.mounted) return;
                  if (!confirmed) return;
                  context
                      .read<DashboardBloc>()
                      .add(DashboardRemoveCartItem(item.id));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartSummaryBar extends StatelessWidget {
  final double total;
  final int itemCount;
  final VoidCallback onCheckout;

  const _CartSummaryBar({
    required this.total,
    required this.itemCount,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          top: BorderSide(color: scheme.outline.withOpacity(0.35)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$itemCount item${itemCount == 1 ? '' : 's'}',
                  style: TextStyle(
                    color: scheme.onSurface.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${total.toStringAsFixed(2)} \$',
                  style: const TextStyle(
                    color: AppColors.orangeRed,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightRed,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

