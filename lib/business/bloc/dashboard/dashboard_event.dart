part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class DashboardLoadData extends DashboardEvent {
  const DashboardLoadData();
}

class DashboardSelectCategory extends DashboardEvent {
  final String categoryId;

  const DashboardSelectCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class DashboardSelectFilter extends DashboardEvent {
  final String filter;

  const DashboardSelectFilter(this.filter);

  @override
  List<Object> get props => [filter];
}

class DashboardSearch extends DashboardEvent {
  final String query;

  const DashboardSearch(this.query);

  @override
  List<Object> get props => [query];
}

class DashboardAddToCart extends DashboardEvent {
  final String foodItemId;

  const DashboardAddToCart(this.foodItemId);

  @override
  List<Object> get props => [foodItemId];
}

class DashboardClearCart extends DashboardEvent {
  const DashboardClearCart();
}

class DashboardUpdateSpecialNote extends DashboardEvent {
  final String note;

  const DashboardUpdateSpecialNote(this.note);

  @override
  List<Object> get props => [note];
}

class DashboardOpenProductDetail extends DashboardEvent {
  final String foodItemId;

  const DashboardOpenProductDetail(this.foodItemId);

  @override
  List<Object> get props => [foodItemId];
}

class DashboardCloseProductDetail extends DashboardEvent {
  const DashboardCloseProductDetail();
}

class DashboardUpdateQuantity extends DashboardEvent {
  final String foodItemId;
  final int quantity;

  const DashboardUpdateQuantity(this.foodItemId, this.quantity);

  @override
  List<Object> get props => [foodItemId, quantity];
}

class DashboardShowCartDetails extends DashboardEvent {
  const DashboardShowCartDetails();
}

class DashboardHideCartDetails extends DashboardEvent {
  const DashboardHideCartDetails();
}

class DashboardRemoveCartItem extends DashboardEvent {
  final String cartItemId;

  const DashboardRemoveCartItem(this.cartItemId);

  @override
  List<Object> get props => [cartItemId];
}

