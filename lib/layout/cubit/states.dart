import 'package:shopping_app/models/change_favorites_model.dart';
import 'package:shopping_app/models/change_cart_model.dart';
import 'package:shopping_app/models/login_model.dart';

import '../../models/change_password_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

//bottom nav
class ChangeNavState extends ShopStates {}

//home data
class LoadingHomeDataState extends ShopStates {}

class SuccessHomeDataState extends ShopStates {}

class ErrorHomeDataState extends ShopStates {}

//get category
class SuccessCategoriesState extends ShopStates {}

class ErrorCategoriesState extends ShopStates {}

//change fav
class ChangeFavoriteState extends ShopStates {}

class SuccessChangeFavoriteState extends ShopStates {
  late final ChangeFavoritesModel model;

  SuccessChangeFavoriteState(this.model);
}

class ErrorChangeFavoriteState extends ShopStates {}

//get fav
class LoadingGetFavState extends ShopStates {}

class SuccessGetFavState extends ShopStates {}

class ErrorGetFavState extends ShopStates {}

//product details
class ProductDetailsLoadingStates extends ShopStates {}

class ProductDetailsSuccessStates extends ShopStates {}

class ProductDetailsErrorStates extends ShopStates {}

//categories details
class CategoryDetailsLoadingStates extends ShopStates {}

class CategoryDetailsSuccessStates extends ShopStates {}

class CategoryDetailsErrorStates extends ShopStates {}

//update user data
class UpdateProfileLoadingState extends ShopStates {}

class UpdateProfileSuccessState extends ShopStates {
  final LoginModel model;

  UpdateProfileSuccessState(this.model);
}

class UpdateProfileErrorState extends ShopStates {
  final error;

  UpdateProfileErrorState(this.error);
}

//get user data
class LoadingUserDataState extends ShopStates {}

class SuccessUserDataState extends ShopStates {}

class ErrorUserDataState extends ShopStates {
  final error;
  ErrorUserDataState(this.error);
}

//fqa
class FaqLoadingStates extends ShopStates {}

class GetFaqSuccessStates extends ShopStates {}

class GetFaqErrorStates extends ShopStates {}

//contact us
class LoadingGetContactUsState extends ShopStates {}

class SuccessGetContactUsState extends ShopStates {}

class ErrorGetContactUsState extends ShopStates {}

//log out
class LogoutLoadingState extends ShopStates {}

class LogoutSuccessState extends ShopStates {
  final LoginModel model;

  LogoutSuccessState(this.model);
}

//About Us
class ShopLoadingGetSettingsState extends ShopStates {}

class ShopSuccessGetSettingsState extends ShopStates {}

class ShopErrorGetSettingsState extends ShopStates {
  final String error;
  ShopErrorGetSettingsState(this.error);
}

//select Cart product
class LoadingsChangeCartStates extends ShopStates {}

class SuccessChangeCartSuccessState extends ShopStates {
  ChangeCartsModel changeCartsModel;

  SuccessChangeCartSuccessState(this.changeCartsModel);
}

class ErrorChangeCartStates extends ShopStates {
  final String error;
  ErrorChangeCartStates(this.error);
}

//Cart screen
class LoadingGetCartStates extends ShopStates {}

class SuccessGetCartState extends ShopStates {}

class ErrorGetCartStates extends ShopStates {
  final String error;
  ErrorGetCartStates(this.error);
}

//Plus and mins product in cart
class ShopPlusQuantityState extends ShopStates {}

class ShopMinusQuantityState extends ShopStates {}

//calculate price
class ShopLoadingCountCartsState extends ShopStates {}

class ShopSuccessCountCartsState extends ShopStates {}

class ShopErrorCountCartsState extends ShopStates {}

//image
class ShopProfileImagePickedSuccessState extends ShopStates {}

class ShopProfileImagePickedErrorState extends ShopStates {}

//change password
class LoadingsChangePasswordStates extends ShopStates {}

class SuccessChangePasswordState extends ShopStates {
  ChangePasswordModel? changePasswordModel;

  SuccessChangePasswordState(this.changePasswordModel);
}

class ErrorChangePasswordStates extends ShopStates {
  final String error;
  ErrorChangePasswordStates(this.error);
}

//password visibility
class ChangeCurrentPasswordVisibility extends ShopStates {}

class ChangeNewPasswordVisibility extends ShopStates {}

//address
class ShopLoadingAddAddressState extends ShopStates {}

class ShopSuccessAddAddressState extends ShopStates {}

class ShopErrorAddAddressState extends ShopStates {
  final String error;

  ShopErrorAddAddressState(this.error);
}

//add order
class ShopLoadingAddOrderState extends ShopStates {}

class ShopSuccessAddOrderState extends ShopStates {}

class ShopErrorAddOrderState extends ShopStates {
  final String error;

  ShopErrorAddOrderState(this.error);
}

//get order
class ShopLoadingGetOrdersState extends ShopStates {}

class ShopSuccessGetOrdersState extends ShopStates {}

class ShopErrorGetOrdersState extends ShopStates {
  final String error;

  ShopErrorGetOrdersState(this.error);
}

//cancel order
class ShopSuccessCancelOrderState extends ShopStates {}

class ShopErrorCancelOrderState extends ShopStates {}
