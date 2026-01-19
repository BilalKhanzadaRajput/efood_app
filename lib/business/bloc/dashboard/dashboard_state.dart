part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final List<CategoryModel> categories;
  final List<FoodItemModel> foodItems;
  final String? selectedCategoryId;
  final String selectedFilter;
  final String searchQuery;
  final List<CartItemModel> cartItems;
  final String specialNote;
  final FoodItemModel? selectedProduct;
  final int selectedQuantity;
  final bool showCartDetails;

  const DashboardLoaded({
    required this.categories,
    required this.foodItems,
    this.selectedCategoryId,
    this.selectedFilter = 'All',
    this.searchQuery = '',
    this.cartItems = const [],
    this.specialNote = '',
    this.selectedProduct,
    this.selectedQuantity = 1,
    this.showCartDetails = false,
  });

  int get cartItemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotal =>
      cartItems.fold(0.0, (sum, item) => sum + item.lineTotal);

  @override
  List<Object> get props => [
        categories,
        foodItems,
        selectedCategoryId ?? '',
        selectedFilter,
        searchQuery,
        cartItems,
        specialNote,
        selectedProduct?.id ?? '',
        selectedQuantity,
        showCartDetails,
      ];

  DashboardLoaded copyWith({
    List<CategoryModel>? categories,
    List<FoodItemModel>? foodItems,
    String? selectedCategoryId,
    String? selectedFilter,
    String? searchQuery,
    List<CartItemModel>? cartItems,
    String? specialNote,
    FoodItemModel? selectedProduct,
    int? selectedQuantity,
    bool? showCartDetails,
  }) {
    return DashboardLoaded(
      categories: categories ?? this.categories,
      foodItems: foodItems ?? this.foodItems,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      cartItems: cartItems ?? this.cartItems,
      specialNote: specialNote ?? this.specialNote,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      selectedQuantity: selectedQuantity ?? this.selectedQuantity,
      showCartDetails: showCartDetails ?? this.showCartDetails,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}

