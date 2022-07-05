import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shopping_app/layout/cubit/states.dart';
import 'package:shopping_app/models/categories_details_model.dart';
import 'package:shopping_app/models/categories_model.dart';
import 'package:shopping_app/models/change_favorites_model.dart';
import 'package:shopping_app/models/change_cart_model.dart';
import 'package:shopping_app/models/change_password_model.dart';
import 'package:shopping_app/models/contact_model.dart';
import 'package:shopping_app/models/favorites_model.dart';
import 'package:shopping_app/models/fqa_model.dart';
import 'package:shopping_app/models/get_cart_model.dart';
import 'package:shopping_app/models/home_model.dart';
import 'package:shopping_app/models/login_model.dart';
import 'package:shopping_app/models/logout_model.dart';
import 'package:shopping_app/models/product_details_model.dart';
import 'package:shopping_app/models/setting_model.dart';
import 'package:shopping_app/modules/cart/cart_screen.dart';
import 'package:shopping_app/modules/categories/categories_screen.dart';
import 'package:shopping_app/modules/favorite/favorite_screen.dart';
import 'package:shopping_app/modules/login/login_screen.dart';
import 'package:shopping_app/modules/products/products_screen.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/network/end_points.dart';
import 'package:shopping_app/shared/network/local/cache_helper.dart';
import 'package:shopping_app/shared/network/remote/dio_helper.dart';
import '../../models/orders_model.dart';
import '../../modules/settings/settings_screen.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());


  static ShopCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      bottomNav(icon: Icons.apps, text: "Categories"),
      bottomNav(icon: Icons.shopping_cart_outlined, text: "Cart"),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.home,
          color: Colors.pinkAccent,
          size: 40,
        ),
        title: ("home"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white,
      ),
      bottomNav(
        icon: Icons.favorite,
        text: "WishList",
      ),
      bottomNav(icon: Icons.settings, text: "Settings"),
    ];
  }

  List<Widget> screens = [
    CategoriesScreen(),
    CartScreen(),
    ProductsScreen(),
    FavoriteScreen(),
    SettingsScreen(),
  ];

  bottomNav({required IconData icon, required String text}) {
    return PersistentBottomNavBarItem(
      icon: Icon(
        icon,
      ),
      title: (text),
      activeColorPrimary: Colors.black54,
      inactiveColorPrimary: Colors.white,
    );
  }

  changeIndex(int index) {
    currentIndex = index;
     if(index==0) CategoriesScreen();
     if (index == 1) getCartData();
     if (index == 2) getHomeData();
     if(index ==3) getFavorite();
    emit(ChangeNavState());
  }

  LoginModel? userData;

  void getUserData() {
    emit(LoadingUserDataState());
    DioHelper.getData(url: PROFILE, token: token).then((value) {
      userData = LoginModel.fromJson(value.data);
      emit(SuccessUserDataState());
    }).catchError((error) {
      emit(ErrorUserDataState(error.toString()));
      log(error.toString());
    });
  }

  void updateUserData({
  required String name,
  required String email,
  required String phone,
 // required String image,
}) {
    emit(UpdateProfileLoadingState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name' : name,
        'email' : email,
        'phone' : phone,
      //  'image' : image,
      },
    ).then((value) {
      userData = LoginModel.fromJson(value.data);
      print('Image: ${userData!.data!.image}');
      emit(UpdateProfileSuccessState(userData!));
    }).catchError((error) {
      emit(UpdateProfileErrorState(error));
    print(error.toString());
    });
  }


  bool isHome = false;
  HomeModel? homeModel;
  void getHomeData() {
    emit(LoadingHomeDataState());
    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      isHome = true;
      homeModel = HomeModel.fromJson(value.data);
    //  print(homeModel?.data?.banners[0].image);
      print('home ${homeModel!.status}');
      homeModel!.data!.products.forEach((element) {
        favorites.addAll({element.id as int: element.inFavorites as bool});
      });
homeModel!.data!.products.forEach((element) {
  cartList.addAll({element.id as int: element.inCart as bool});
});
      //print(favorites.toString());
      emit(SuccessHomeDataState());
    }).catchError((error) {
      log(error.toString());
      emit(ErrorHomeDataState());
    });
  }

  CategoriesModel? categoryModel;
  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoryModel = CategoriesModel.fromJson(value.data);
      // print( categoryModel?.data?.banners[0].image);
     // print(categoryModel!.status);
      emit(SuccessCategoriesState());
    }).catchError((error) {
      log(error.toString());
      emit(ErrorCategoriesState());
    });
  }

  Map<int, bool> favorites = {};
  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int? productId) {
    favorites[productId!] = !favorites[productId]!;
    emit(ChangeFavoriteState());
    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      //print(changeFavoritesModel?.message);

      //print(value.data);

      if (!(changeFavoritesModel!.status)!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorite();
       // getProductDetailData(id: productId);
      }

      emit(SuccessChangeFavoriteState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      print(error.toString());
      emit(ErrorChangeFavoriteState());
    });
  }

  FavoritesModel? favoritesModel;
  void getFavorite() {
    emit(LoadingGetFavState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      //print(value.data);
      emit(SuccessGetFavState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetFavState());
    });
  }

  CategoryDetailModel? categoriesDetailModel;
  void getCategoriesDetailData(int? categoryID) {
    emit(CategoryDetailsLoadingStates());
    DioHelper.getData(url: CATEGORIES_DETAIL, query: {
      'category_id': '$categoryID',
    }).then((value) {
      categoriesDetailModel = CategoryDetailModel.fromJson(value.data);
      categoriesDetailModel!.data!.productData!.forEach((element) {});
      //print('categories Detail ${categoriesDetailModel!.status}');
      emit(CategoryDetailsSuccessStates());
    }).catchError((error) {
      emit(CategoryDetailsErrorStates());
      print(error.toString());
    });
  }

  ProductDetailsModel? productDetailsModel;
  void getProductDetailData(  { required int? id}) {
    productDetailsModel = null;
    emit(ProductDetailsLoadingStates());
    DioHelper.getData(url: 'products/$id', token: token).then((value) {
      productDetailsModel = ProductDetailsModel.fromJson(value.data);
  //    print('Product Detail ' + productDetailsModel!.status.toString());
      emit(ProductDetailsSuccessStates());
    }).catchError((error) {
      emit(ProductDetailsErrorStates());
      print(error.toString());
    });
  }

  // int value = 0;
  //
  // void changeVal(val) {
  //   value = val;
  //   emit(ChangeIndicatorState());
  // }

  FaqModel? faqModel;
  void getFaqData() {
    emit(FaqLoadingStates());
    DioHelper.getData(url: FQAs, token: token).then((value) {
      faqModel = FaqModel.fromJson(value.data);
      emit(GetFaqSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(GetFaqErrorStates());
    });
  }


  LogoutModel? logoutModel;
  void logOutUser( {required context}) {
    emit(LogoutLoadingState());
    DioHelper.postData(url: LOGOUT, data: {"token": token}).then((value) {
      Navigator.pop(context);
      logoutModel = LogoutModel.fromJson(value.data);
      CacheHelper.sharedPreferences.remove('token');
      CacheHelper.sharedPreferences.remove('id');
      Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  ContactUsModel? contactUsModel;
  void getContactUs() async{
     emit(LoadingGetContactUsState());
    await DioHelper.getData(
        url: CONTACT,
        token: token
    ).then((value) {
      contactUsModel = ContactUsModel.fromJson(value.data);
      emit(SuccessGetContactUsState());
    }).catchError((error) {
      emit(ErrorGetContactUsState());
    });
  }

  SettingsModel? settingsModel;
  void getSettings() {
    emit(ShopLoadingGetSettingsState());
    DioHelper.getData(
        url: SETTINGS,
        token: token
    ).then((value) {
      settingsModel = SettingsModel.fromJson(value.data);
      emit(ShopSuccessGetSettingsState());
    //  print("abut as ${settingsModel!.data!.about}");
    }).catchError((error) {
      //printFullText('ERROR SETTINGS ' + error.toString());
      emit(ShopErrorGetSettingsState(error.toString()));
    });
  }

  Map<int,bool> cartList={};
  ChangeCartsModel? changeCartsModel;
  void changeCart({required int productId}){
    emit(LoadingsChangeCartStates());
    DioHelper.postData(
      url: CART,
      data:{
        'product_id':productId,
      },
      token: token,
    ).then((value) {
      changeCartsModel=  ChangeCartsModel.fromJson(value.data);
     // print(value.data);
      getCartData();
      getProductDetailData(id:productId);

      emit(SuccessChangeCartSuccessState(changeCartsModel!));
    }).catchError((error){
      cartList[productId] = !cartList[productId]!;
      print(error.toString());
      emit(ErrorChangeCartStates(error.toString()));
    });
  }

  CartModel? cartModel;
  void getCartData(){
    emit(LoadingGetCartStates());
    DioHelper.getData(
      url: CART,
      token: token,
    ).then((value) {
      cartModel = CartModel.fromJson(value.data);
     // printFullText(value.data.toString());
     // print('get cart token${token}');

      emit(SuccessGetCartState());

    }).catchError((error){
      print(error.toString());
      emit(ErrorGetCartStates(error.toString()));


    });

  }

  //Plus and minus product in cart
  int quantity = 1;

  void plusQuantity(CartModel model, index) {
    quantity = model.data!.cartItems![index].quantity!;
    quantity++;
    emit(ShopPlusQuantityState());
  }

  void minusQuantity(CartModel model, index) {
    quantity = model.data!.cartItems![index].quantity!;
    if (quantity > 1) quantity--;
    emit(ShopMinusQuantityState());
  }


//calculate price
  void updateCartData({ required String? id, int? quantity,
  }) {
    emit(ShopLoadingCountCartsState());
    DioHelper.putData(
      url: '${UPDATE_CART + id!}',
      data: {
        'quantity': quantity,
      },
      token: token,
    ).then((value) {
      emit(ShopSuccessCountCartsState());
      getCartData();
    }).catchError((error) {
   //   printFullText('ERROR UPDATE CARTS DATA' + error.toString());
      emit(ShopErrorCountCartsState());
    });
  }

  File? profileImage;

  final  picker = ImagePicker();

  // Implementing the image picker
  Future<void> getImageFromGallery() async {
    final XFile?  pickedImage =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      List<int> imageBytes = profileImage!.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      print(base64Image);
      emit(ShopProfileImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(ShopProfileImagePickedErrorState());
    }
  }

  Future<void> getImageFromCamera() async {
    final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 1800, maxWidth: 1800);
    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      //List<int> imageBytes = profileImage!.readAsBytesSync();
     //var  base64Image = base64Encode(imageBytes);
      emit(ShopProfileImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(ShopProfileImagePickedErrorState());
    }
  }

  ChangePasswordModel? changePasswordModel;

  void changePassword({
  required String currentPassword,
  required String newPassword,
}){
    emit(LoadingsChangePasswordStates());
    DioHelper.postData(url: CHANGE_PASSWORD,
        token: token,
        data: {
      'current_password':currentPassword,
      'new_password':newPassword,
        }).then((value) {
          changePasswordModel = ChangePasswordModel.fromJson(value.data);
          emit(SuccessChangePasswordState(changePasswordModel));
    }).catchError((error){
      print(error);
      emit(ErrorChangePasswordStates(error));

    });
  }

  IconData suffix = Icons.visibility;
  bool isCurrentPassword = true;
  void changeCurrentPasswordVisibility() {
    isCurrentPassword = !isCurrentPassword;
    suffix =
    isCurrentPassword ? Icons.visibility : Icons.visibility_off;
    emit(ChangeCurrentPasswordVisibility());
  }


  bool isNewPassword = true;
  IconData newPasswordSuffix = Icons.visibility;
  void changeNewPasswordVisibility() {
    isNewPassword = !isNewPassword;
    newPasswordSuffix =
    isNewPassword ? Icons.visibility : Icons.visibility_off;
    emit(ChangeNewPasswordVisibility());
  }

  void addAddress({
    required String name,
    required String city,
    required String region,
    required String details,
    required String notes,
  }) {
    emit(ShopLoadingAddAddressState());
    DioHelper.postData(
      url: ADDRESS,
      token: token,
      data: {
        'name': name,
        'city': city,
        'region': region,
        'details': details,
        'notes': notes,
        'latitude': '3123123',
        'longitude': '2121545',
      },
    ).then((value) {
      addOrder(idAddress: value.data['data']['id']);
      emit(ShopSuccessAddAddressState());
    }).catchError((error) {
      emit(ShopErrorAddAddressState(error.toString()));
      print(error.toString());
    });
  }
  void addOrder({
    required int idAddress,
  }) {
    emit(ShopLoadingAddOrderState());
    DioHelper.postData(
      url: ORDERS,
      token: token,
      data: {
        'address_id': idAddress,
        'payment_method': 1,
        'use_points': false,
      },
    ).then((value) {
      getCartData();
      emit(ShopSuccessAddOrderState());
    }).catchError((error) {
      emit(ShopErrorAddOrderState(error.toString()));
    });
  }


  OrdersModel? ordersModel;

  void getOrders() {
    emit(ShopLoadingGetOrdersState());
    DioHelper.getData(
      url: ORDERS,
      token: token,
    ).then((value) {
      ordersModel = OrdersModel.fromJson(value.data);
      emit(ShopSuccessGetOrdersState());
    }).catchError((error) {
      emit(ShopErrorGetOrdersState(error.toString()));
    });
  }

  void cancelOrder({required int id}) {
    DioHelper.getData(
      url: 'orders/$id/cancel',
      token: token,
    ).then((value) {
      emit(ShopSuccessCancelOrderState());
    }).catchError((error) {
      emit(ShopErrorCancelOrderState());
    });
  }
}
