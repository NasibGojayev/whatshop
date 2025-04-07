import 'package:share_plus/share_plus.dart';

import '../d_product_bloc/d_product_bloc.dart';

abstract class FavoriteStates{}

class ShareInitial extends FavoriteStates {}

class ProductsCapturedState extends FavoriteStates{
  final List<XFile> capturedProducts;
  ProductsCapturedState(this.capturedProducts);
}

class ShareLoadingState extends FavoriteStates {
  final List<dynamic> products;

  ShareLoadingState(this.products);
}
class FavoriteLoadingState extends FavoriteStates {}


class ShareSuccess extends FavoriteStates {
  final List<XFile> capturedProducts;
  ShareSuccess(this.capturedProducts);
}
class FavoriteUpdatedState extends FavoriteStates {
  final List<Product> updatedFavorites;
  FavoriteUpdatedState(this.updatedFavorites);
}

class ShareFailure extends FavoriteStates {
  final String error;
  ShareFailure(this.error);
}