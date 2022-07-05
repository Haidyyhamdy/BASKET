import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/modules/login/cubit/cubit.dart';
import 'package:shopping_app/modules/login/login_screen.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/network/local/cache_helper.dart';
import '../cubit/cubit.dart';



void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );

void navigateAndReplace(context, widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (Route<dynamic> route) =>
        false); //de navigator bt3ml push w msh bt5liny a3ml back ll page lle 2blha

void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum lma ykon 3ndy kza a5tyar mn 7aga
enum ToastStates { SUCCESS, ERROR, WARNING }

Color? chooseToastColor(ToastStates state) {
  Color? color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.black.withOpacity(.9);

      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}


//use button signOut
void signOut(context) {
  CacheHelper.removeData(key: 'token');
  token = '';
  var model = LoginCubit.get(context).model;
  model!.data!.id = '' as int?;
  model.data!.name = '';
  model.data!.email = '';
  model.data!.phone = '';

  navigateAndReplace(context, LoginScreen());
  ShopCubit.get(context).currentIndex = 2;
}


Widget buildProductItem(model, context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color:
          ModeCubit.get(context).isDark ? HexColor('22303c') : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    CachedNetworkImage(
                      imageUrl: model!.image.toString(),
                      width: 120,
                      height: 120,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(height: 1.2, fontSize: 14),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          'EGP ${model.price}',
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: defaultColor,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            print(model.id);
                            ShopCubit.get(context)
                                .changeFavorites(model.id as int);
                          },
                          icon: ShopCubit.get(context).favorites[model.id]!
                              ? Icon(
                                  Icons.favorite,
                                  color: defaultColor,
                                )
                              : Icon(Icons.favorite_border),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );


