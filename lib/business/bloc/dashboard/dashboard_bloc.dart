import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/category_model.dart';
import '../../../models/food_item_model.dart';
import '../../../models/cart_item_model.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardInitial()) {
    on<DashboardLoadData>(_onLoadData);
    on<DashboardSelectCategory>(_onSelectCategory);
    on<DashboardSelectFilter>(_onSelectFilter);
    on<DashboardSearch>(_onSearch);
    on<DashboardAddToCart>(_onAddToCart);
    on<DashboardOpenProductDetail>(_onOpenProductDetail);
    on<DashboardCloseProductDetail>(_onCloseProductDetail);
    on<DashboardUpdateQuantity>(_onUpdateQuantity);
    on<DashboardShowCartDetails>(_onShowCartDetails);
    on<DashboardHideCartDetails>(_onHideCartDetails);
    on<DashboardRemoveCartItem>(_onRemoveCartItem);
    on<DashboardClearCart>(_onClearCart);
    on<DashboardUpdateSpecialNote>(_onUpdateSpecialNote);
  }

  /// Mock API call to get dashboard data
  Future<({
  List<CategoryModel> categories,
  List<FoodItemModel> foodItems,
  List<CartItemModel> cartItems,
  })> _getDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final categories = [
      const CategoryModel(id: '1', name: 'Set Menu', iconUrl: 'assets/images/kfc.png'),
      const CategoryModel(id: '2', name: 'Hot Item', iconUrl: 'assets/images/burger.jpg'),
      const CategoryModel(id: '3', name: 'Biriyani', iconUrl: 'assets/images/biryani.jpg'),
      const CategoryModel(id: '4', name: 'Drinks', iconUrl: 'assets/images/cold_coffee.jpg'),
      const CategoryModel(id: '5', name: 'Pizza', iconUrl: 'assets/images/burger.jpg'),
      const CategoryModel(id: '6', name: 'Sandwich', iconUrl: 'assets/images/burger.jpg'),
    ];

    final foodItems = [
      FoodItemModel(
        id: '1',
        name: 'Ice Cream',
        imageUrl: 'assets/images/ice_cream.jpg',
        price: 300.00,
        discount: 30.0,
        category: '4',
        isVeg: true,
        description: 'Cup ice cream for all.',
      ),
      const FoodItemModel(
        id: '2',
        name: 'Special Cold Coffee',
        imageUrl: 'assets/images/cold_coffee.jpg',
        price: 180.00,
        quantity: 1,
        category: '4',
        isVeg: true,
      ),
      const FoodItemModel(
        id: '3',
        name: 'Buddy Zinger Combo',
        imageUrl: 'assets/images/burger.jpg',
        price: 200.00,
        category: '2',
        isVeg: false,
        isHalal: true,
      ),
      const FoodItemModel(
        id: '4',
        name: 'Fresh Lime',
        imageUrl: 'assets/images/lime.jpg',
        price: 20.00,
        category: '4',
        isVeg: true,
      ),
      const FoodItemModel(
        id: '5',
        name: 'Set Menu 2',
        imageUrl: 'assets/images/kfc.png',
        price: 250.00,
        category: '1',
        isVeg: false,
        isHalal: true,
      ),
      const FoodItemModel(
        id: '6',
        name: 'Beef Biriyani With Spice',
        imageUrl: 'assets/images/biryani.jpg',
        price: 350.00,
        category: '3',
        isVeg: false,
        isHalal: true,
      ),
      const FoodItemModel(
        id: '7',
        name: 'Cake',
        imageUrl: 'assets/images/cake.webp',
        price: 400.00,
        category: '1',
        isVeg: true,
      ),
    ];

    return (categories: categories, foodItems: foodItems, cartItems: <CartItemModel>[]);
  }

  Future<void> _onLoadData(DashboardLoadData event, Emitter<DashboardState> emit) async {
    emit(const DashboardLoading());
    try {
      final data = await _getDashboardData();
      emit(DashboardLoaded(categories: data.categories, foodItems: data.foodItems, cartItems: data.cartItems));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onSelectCategory(DashboardSelectCategory event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final data = await _getDashboardData();
      final filteredItems = data.foodItems.where((item) => item.category == event.categoryId).toList();
      emit(currentState.copyWith(
        selectedCategoryId: event.categoryId,
        foodItems: filteredItems,
        selectedProduct: null,
        selectedQuantity: 1,
      ));
    }
  }

  Future<void> _onSelectFilter(DashboardSelectFilter event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final data = await _getDashboardData();
      List<FoodItemModel> filteredItems;
      switch (event.filter.toLowerCase()) {
        case 'veg':
          filteredItems = data.foodItems.where((item) => item.isVeg).toList();
          break;
        case 'non veg':
          filteredItems = data.foodItems.where((item) => !item.isVeg).toList();
          break;
        case 'halal':
          filteredItems = data.foodItems.where((item) => item.isHalal).toList();
          break;
        default:
          filteredItems = data.foodItems;
      }
      emit(currentState.copyWith(
        selectedFilter: event.filter,
        foodItems: filteredItems,
        selectedProduct: null,
        selectedQuantity: 1,
      ));
    }
  }

  Future<void> _onSearch(DashboardSearch event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final data = await _getDashboardData();
      final results = event.query.isEmpty
          ? data.foodItems
          : data.foodItems.where((item) => item.name.toLowerCase().contains(event.query.toLowerCase())).toList();
      emit(currentState.copyWith(
        searchQuery: event.query,
        foodItems: results,
        selectedProduct: null,
        selectedQuantity: 1,
      ));
    }
  }

  Future<void> _onAddToCart(DashboardAddToCart event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final product = currentState.selectedProduct;
      if (product == null) return;

      final quantity = currentState.selectedQuantity;
      final existingIndex = currentState.cartItems.indexWhere((item) => item.product.id == product.id);
      List<CartItemModel> updatedCart = List.from(currentState.cartItems);

      if (existingIndex >= 0) {
        final existing = updatedCart[existingIndex];
        updatedCart[existingIndex] = existing.copyWith(quantity: existing.quantity + quantity);
      } else {
        updatedCart.add(CartItemModel(id: '${product.id}_${DateTime.now().millisecondsSinceEpoch}', product: product, quantity: quantity));
      }

      emit(currentState.copyWith(cartItems: updatedCart, selectedProduct: null, selectedQuantity: 1));
    }
  }

  Future<void> _onOpenProductDetail(DashboardOpenProductDetail event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final product = currentState.foodItems.firstWhere(
            (item) => item.id == event.foodItemId,
        orElse: () => currentState.foodItems.first,
      );
      emit(currentState.copyWith(selectedProduct: product, selectedQuantity: product.quantity ?? 1));
    }
  }

  Future<void> _onCloseProductDetail(DashboardCloseProductDetail event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(selectedProduct: null, selectedQuantity: 1));
    }
  }

  Future<void> _onUpdateQuantity(DashboardUpdateQuantity event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded && event.quantity > 0) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(selectedQuantity: event.quantity));
    }
  }

  Future<void> _onShowCartDetails(DashboardShowCartDetails event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(showCartDetails: true));
    }
  }

  Future<void> _onHideCartDetails(DashboardHideCartDetails event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(showCartDetails: false));
    }
  }

  Future<void> _onRemoveCartItem(DashboardRemoveCartItem event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(cartItems: currentState.cartItems.where((item) => item.id != event.cartItemId).toList()));
    }
  }

  Future<void> _onClearCart(DashboardClearCart event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(cartItems: const []));
    }
  }

  Future<void> _onUpdateSpecialNote(DashboardUpdateSpecialNote event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(specialNote: event.note));
    }
  }
}