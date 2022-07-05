import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/layout/cubit/states.dart';
import 'package:shopping_app/models/get_cart_model.dart';
import 'package:shopping_app/modules/products/products_screen.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/components/defaultTextButton.dart';
import 'package:shopping_app/shared/cubit/cubit.dart';
import '../order/order_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is SuccessChangeCartSuccessState) {
          if (state.changeCartsModel.status == true) {
            showToast(
              text: state.changeCartsModel.message.toString(),
              state: ToastStates.SUCCESS,
            );
          } else {
            showToast(
              text: state.changeCartsModel.message.toString(),
              state: ToastStates.ERROR,
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('My Cart'),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                navigateTo(context, ProductsScreen());
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
          body: ShopCubit.get(context).cartModel == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: LinearProgressIndicator(
                      color: defaultColor,
                      backgroundColor: Colors.black,
                    ),
                  ),
                )
              : ShopCubit.get(context).cartModel!.data!.cartItems!.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/empty_cart.png',
                            height: 200,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Oops!  Your Cart \n      is empty!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Add items you want to shop',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          DefaultTextButton(
                              background: ModeCubit.get(context).isDark? HexColor('22303c') :Colors.white,

                              text: 'START SHOPPING',
                              onClick: () {
                                navigateTo(context, ProductsScreen());
                              }),
                        ],
                      ),
                    )
                  : Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 16.0,
                              right: 16.0,
                              left: 16.0,
                              bottom: MediaQuery.of(context).size.height / 8,
                            ),
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => buildCarts(
                                      ShopCubit.get(context)
                                          .cartModel!
                                          .data!
                                          .cartItems![index],
                                      context,
                                      index,
                                    ),
                                    separatorBuilder: (context, index) =>
                                        Container(),
                                    itemCount: ShopCubit.get(context)
                                        .cartModel!
                                        .data!
                                        .cartItems!
                                        .length,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        buildTotalPrice(
                            ShopCubit.get(context).cartModel!.data, context),
                      ],
                    ),
        );
      },
    );
  }

  Widget buildCarts(
    CartItems model,
    context,
    index,
  ) =>
      Container(
        height: 146.0,
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
        child: Card(
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        CachedNetworkImage(
                          imageUrl: model.product!.image.toString(),
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                        if (model.product!.discount != 0)
                          Positioned.fill(
                              child: Align(
                            alignment: Alignment(1, -1),
                            child: ClipRect(
                              child: Banner(
                                location: BannerLocation.topStart,
                                color: Colors.red,
                                child: Container(
                                  height: 100.0,
                                ),
                                message: '${model.product!.discount}% OFF',
                                textStyle: TextStyle(
                                  fontFamily: 'Cardo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          )),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(model.product!.name.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              height: 1.3,
                            )
                        ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'EGP ${model.product!.price}',
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: defaultColor),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if (model.product!.discount != 0)
                          Text(
                            'EGP ${model.product!.oldPrice}',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    Row(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Spacer(),
                          RawMaterialButton(
                            elevation: 2.0,
                            shape: CircleBorder(),
                            fillColor: Colors.pinkAccent,
                            onPressed: () {
                              ShopCubit.get(context).plusQuantity(
                                  ShopCubit.get(context).cartModel!, index);
                              ShopCubit.get(context).updateCartData(
                                id: ShopCubit.get(context)
                                    .cartModel!
                                    .data!
                                    .cartItems![index]
                                    .id
                                    .toString(),
                                quantity: ShopCubit.get(context).quantity,
                              );
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20.0,
                            ),
                            constraints: BoxConstraints.tightFor(
                              width: 40.0,
                              height: 40.0,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            (ShopCubit.get(context)
                                .cartModel!
                                .data!
                                .cartItems![index]
                                .quantity
                                .toString()),
                            style: TextStyle(fontSize: 23.0),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          RawMaterialButton(
                            elevation: 2.0,
                            shape: CircleBorder(),
                            fillColor: Colors.pinkAccent,
                            onPressed: () {
                              ShopCubit.get(context).minusQuantity(
                                  ShopCubit.get(context).cartModel!, index);
                              ShopCubit.get(context).updateCartData(
                                id: ShopCubit.get(context)
                                    .cartModel!
                                    .data!
                                    .cartItems![index]
                                    .id
                                    .toString(),
                                quantity: ShopCubit.get(context).quantity,
                              );
                            },
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 20.0,
                            ),
                            constraints: BoxConstraints.tightFor(
                              width: 40.0,
                              height: 40.0,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                ShopCubit.get(context).changeCart(
                                    productId: model.product!.id as int);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.grey,
                                size: 40,
                              ))
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildTotalPrice(model, context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color:
          ModeCubit.get(context).isDark ? HexColor('22303c') : Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 1, color: Color(0xFF8D8E98), spreadRadius: 0.1),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 14.0, left: 25, bottom: 20.0, right: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'EGP ${model.total}',
                    style: TextStyle(
                      color: defaultColor,
                      fontSize: 18.0,
                      height: 1.2,
                      fontWeight: FontWeight.w900,
                      //backgroundColor: Colors.yellow,
                    ),
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  if (ShopCubit.get(context).cartModel!.data!.total != 0) {
                    navigateTo(context, OrderScreen());
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.pinkAccent),
                  width: 165.0,
                  height: 46,
                  padding: EdgeInsets.only(
                      top: 8.0, bottom: 8.0, right: 8.0, left: 24.0),
                  child: Row(
                    children: [
                      Text(
                        'Check Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14.0,
                        ),
                      ),
                      Spacer(),
                      CircleAvatar(
                        radius: 15.0,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: defaultColor,
                          size: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
