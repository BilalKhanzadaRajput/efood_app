import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business/bloc/dashboard/dashboard_bloc.dart';
import '../widgets/dashboard/dashboard_header_widget.dart';
import '../widgets/dashboard/search_bar_widget.dart';
import '../widgets/dashboard/category_item_widget.dart';
import '../widgets/dashboard/filter_button_widget.dart';
import '../widgets/dashboard/food_item_card_widget.dart';
import '../widgets/dashboard/product_detail_bottom_sheet.dart';
import 'cart_page.dart';
import '../../core/constants/app_colors.dart';
import '../../models/food_item_model.dart';
import '../widgets/settings/theme_settings_bottom_sheet.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchController = TextEditingController();

  // Bottom sheet is UI-driven (not state-driven)
  bool _isBottomSheetShowing = false;
  String? _currentSheetProductId;

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const DashboardLoadData());
  }

  Future<void> _openProductSheet(FoodItemModel product) async {
    // Prevent multiple opens / double taps
    if (_isBottomSheetShowing) return;

    setState(() {
      _isBottomSheetShowing = true;
      _currentSheetProductId = product.id;
    });

    // Keep existing bloc events for quantity + add-to-cart,
    // but DO NOT trigger opening from bloc state changes.
    context.read<DashboardBloc>().add(DashboardOpenProductDetail(product.id));

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final qty =
              (state is DashboardLoaded && state.selectedProduct?.id == product.id)
                  ? state.selectedQuantity
                  : 1;

          return ProductDetailBottomSheet(
            product: product,
            quantity: qty,
          );
        },
      ),
    );

    if (!mounted) return;

    // Always clear selection when sheet closes (close button, back swipe, add-to-cart)
    context.read<DashboardBloc>().add(const DashboardCloseProductDetail());

    setState(() {
      _isBottomSheetShowing = false;
      _currentSheetProductId = null;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.coralRed),
            );
          }

          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DashboardBloc>().add(const DashboardLoadData());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is! DashboardLoaded) return const SizedBox.shrink();

          return SafeArea(
            child: Column(
              children: [
                // Header
                DashboardHeaderWidget(
                  cartItemCount: state.cartItemCount,
                  onCartTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartPage()),
                    );
                  },
                ),

                // Search Bar
                SearchBarWidget(
                  controller: _searchController,
                  onChanged: (query) {
                    context.read<DashboardBloc>().add(DashboardSearch(query));
                  },
                ),

                // Categories
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return CategoryItemWidget(
                        category: category,
                        isSelected: state.selectedCategoryId == category.id,
                        onTap: () {
                          context
                              .read<DashboardBloc>()
                              .add(DashboardSelectCategory(category.id));
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Filters
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      FilterButtonWidget(
                        label: 'All',
                        isSelected: state.selectedFilter == 'All',
                        onTap: () {
                          context
                              .read<DashboardBloc>()
                              .add(const DashboardSelectFilter('All'));
                        },
                      ),
                      FilterButtonWidget(
                        label: 'Non Veg',
                        isSelected: state.selectedFilter == 'Non Veg',
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 16,
                        ),
                        onTap: () {
                          context
                              .read<DashboardBloc>()
                              .add(const DashboardSelectFilter('Non Veg'));
                        },
                      ),
                      FilterButtonWidget(
                        label: 'Veg',
                        isSelected: state.selectedFilter == 'Veg',
                        icon: Icon(
                          Icons.eco,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 16,
                        ),
                        onTap: () {
                          context
                              .read<DashboardBloc>()
                              .add(const DashboardSelectFilter('Veg'));
                        },
                      ),
                      FilterButtonWidget(
                        label: 'Halal',
                        isSelected: state.selectedFilter == 'Halal',
                        icon: Icon(
                          Icons.verified,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 16,
                        ),
                        onTap: () {
                          context
                              .read<DashboardBloc>()
                              .add(const DashboardSelectFilter('Halal'));
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Food Items Grid
                Expanded(
                  child: state.foodItems.isEmpty
                      ? Center(
                          child: Text(
                            'No items found',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: state.foodItems.length,
                          itemBuilder: (context, index) {
                            final foodItem = state.foodItems[index];
                            return FoodItemCardWidget(
                              foodItem: foodItem,
                              onTap: () async {
                                // Only UI opens the sheet (no state-driven auto-open)
                                if (_currentSheetProductId == foodItem.id &&
                                    _isBottomSheetShowing) {
                                  return;
                                }
                                await _openProductSheet(foodItem);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (_) => const ThemeSettingsBottomSheet(),
          );
        },
        backgroundColor: AppColors.coralRed,
        child: const Icon(Icons.settings, color: AppColors.white),
      ),
    );
  }
}