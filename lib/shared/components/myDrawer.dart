import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/modules/cart/cart_screen.dart';
import 'package:shopping_app/modules/categories/categories_screen.dart';
import 'package:shopping_app/modules/favorite/favorite_screen.dart';
import 'package:shopping_app/modules/products/products_screen.dart';
import 'package:shopping_app/modules/search/search_screen.dart';
import 'package:shopping_app/modules/settings/settings_screen.dart';
import 'package:shopping_app/modules/update_profile/update_profile_screen.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/cubit/cubit.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          InkWell(
            child: Container(
              height: 340,
              child: DrawerHeader(
                child: Center(
                  child: Column(
                    children: [
                       Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 88,
                            backgroundColor: defaultColor,
                            child: CircleAvatar(
                              radius: 84,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundImage: ShopCubit.get(context)
                                    .profileImage !=
                                    null
                                    ? Image.file(
                                  ShopCubit.get(context)
                                      .profileImage!,
                                  fit: BoxFit.cover,
                                ).image
                                    : NetworkImage(
                                    'https://icon-library.com/images/no-profile-picture-icon/no-profile-picture-icon-6.jpg'),
                                radius: 80,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              child: IconButton(
                                splashRadius: 22,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          actions: <Widget>[
                                            Center(
                                              child: Column(
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      ShopCubit.get(context)
                                                          .getImageFromCamera()
                                                          .then((value) {
                                                        Navigator.pop(
                                                            context);
                                                      });
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Icon(
                                                            Icons.camera_alt),
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Text('Camera'),
                                                      ],
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      ShopCubit.get(context)
                                                          .getImageFromGallery()
                                                          .then((value) {
                                                        Navigator.pop(
                                                            context);
                                                      });
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Icon(Icons.camera),
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Text('Gallery'),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                  );
                                },
                                icon: Icon(Icons.camera_alt),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Hi, ${ShopCubit.get(context).userData!.data!.name}🤚',
                        style: TextStyle(fontSize: 24, fontFamily: 'Cardo',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${ShopCubit.get(context).userData!.data!.email}',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Cardo',
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              "Home",
              style:
                  TextStyle(fontFamily: 'Cardo', fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.home),
            onTap: () {
              navigateTo(context, ProductsScreen());
            },
            selected: true,
          ),
          ListTile(
            title: Text(
              "Profile",
              style:
                  TextStyle(fontFamily: 'Cardo', fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.person_outline),
            onTap: () {
              navigateTo(context, UpdateProfileScreen());
            },
            selected: true,
          ),
          ListTile(
            title: Text(
              "My WishList",
              style:
                  TextStyle(fontFamily: 'Cardo', fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.favorite_border),
            onTap: () {
              navigateTo(context, FavoriteScreen());
            },
            selected: true,
          ),
          ListTile(
            title: Text(
              "Cart",
              style:
                  TextStyle(fontFamily: 'Cardo', fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.shopping_cart_outlined),
            onTap: () {
              navigateTo(context, CartScreen());
            },
            selected: true,
          ),
          ListTile(
            title: Text(
              "Categories",
              style:
                  TextStyle(fontFamily: 'Cardo', fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.apps),
            onTap: () {
              navigateTo(context, CategoriesScreen());
            },
            selected: true,
          ),
          ListTile(
            title: Text(
              "Search",
              style:
                  TextStyle(fontFamily: 'Cardo', fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.search),
            onTap: () {
              navigateTo(context, SearchScreen());
            },
            selected: true,
          ),
          ListTile(
            title: Text(
              "Settings",
              style:
                  TextStyle(fontFamily: 'Cardo', fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.settings),
            onTap: () {
              navigateTo(context, SettingsScreen());
            },
            selected: true,
          ),
          Divider(),
          ListTile(
            title: Text(
              "SignOut",
              style:
                  TextStyle(fontFamily: 'Cardo', fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.QUESTION,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Do you want to Logout?',
                  titleTextStyle: TextStyle(
                      color: ModeCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black),
                  desc: "Please, Login soon 🤚",
                  descTextStyle: TextStyle(
                      color: ModeCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black),
                  btnOkOnPress: () {
                    ShopCubit.get(context)
                        .logOutUser(context: context);
                  }).show();
            },
            selected: true,
          ),
        ],
      ),
    );
  }
}
