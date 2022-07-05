import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/layout/cubit/states.dart';
import 'package:shopping_app/modules/about/about_us_screen.dart';
import 'package:shopping_app/modules/change_password/change_pass_screen.dart';
import 'package:shopping_app/modules/contact/contact_screen.dart';
import 'package:shopping_app/modules/order/all_orders_screen.dart';
import 'package:shopping_app/modules/products/products_screen.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/components/default_button.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../fqa/fqa_screen.dart';
import '../update_profile/update_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool value = false;
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is SuccessChangePasswordState) {
          if (state.changePasswordModel!.status == true) {
            showToast(
                text: state.changePasswordModel!.message.toString(),
                state: ToastStates.SUCCESS);
          }
        } else if (state is ErrorChangePasswordStates) {
          showToast(text: state.error, state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        var logout = ShopCubit.get(context).logoutModel;
        return Scaffold(
          appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Settings',
          ),
          leading: IconButton(
            onPressed: () {
              navigateTo(context, ProductsScreen());
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          elevation: 0,
        ),
          body: state is FaqLoadingStates
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'Account Settings',
                            style: TextStyle(color: defaultColor, fontSize: 16),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            navigateTo(context, UpdateProfileScreen());
                          },
                          dense: true,
                          horizontalTitleGap: -8,
                          minVerticalPadding: 15,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          tileColor: Colors.grey[200],
                          leading: Icon(
                            Icons.person,
                            color: defaultColor,
                            size: 26,
                          ),
                          title: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Cardo',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: defaultColor,
                            size: 26,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ListTile(
                          onTap: () {
                            bottomSheetChangePassword(
                                context: context, cubit: cubit);
                          },
                          dense: true,
                          horizontalTitleGap: -8,
                          minVerticalPadding: 15,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          tileColor: Colors.grey[200],
                          leading: Icon(
                            Icons.key,
                            color: defaultColor,
                            size: 26,
                          ),
                          title: Text(
                            'Change Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Cardo',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: defaultColor,
                            size: 26,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ListTile(
                          onTap: () {
                            navigateTo(context, AllOrdersScreen());
                            cubit.getOrders();
                          },
                          dense: true,
                          horizontalTitleGap: -8,
                          minVerticalPadding: 15,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          tileColor: Colors.grey[200],
                          leading: Icon(
                            Icons.shopping_cart_outlined,
                            color: defaultColor,
                            size: 26,
                          ),
                          title: Text(
                            'My Orders',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Cardo',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: defaultColor,
                            size: 26,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'General Settings',
                            style: TextStyle(color: defaultColor, fontSize: 16),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.QUESTION,
                              animType: AnimType.TOPSLIDE,
                              title: 'Do you want to change mode?',
                              titleTextStyle: TextStyle(
                                  color: ModeCubit.get(context).isDark
                                      ? Colors.white
                                      : Colors.black),
                              btnOkOnPress: () {
                                ModeCubit.get(context).changeAppMode();
                              },
                              btnCancelOnPress: () {},
                            ).show();
                          },
                          dense: true,
                          horizontalTitleGap: -8,
                          minVerticalPadding: 15,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          tileColor: Colors.grey[200],
                          leading: Icon(
                            Icons.brightness_2_outlined,
                            color: defaultColor,
                            size: 26,
                          ),
                          title: Text(
                            'Theme Mode',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Cardo',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Switch(
                            value: value,
                            onChanged: (value) {
                              ModeCubit.get(context).changeAppMode();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'Support',
                            style: TextStyle(color: defaultColor, fontSize: 16),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            navigateTo(context, FqaScreen());
                          },
                          dense: true,
                          horizontalTitleGap: -8,
                          minVerticalPadding: 15,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          tileColor: Colors.grey[200],
                          leading: Icon(
                            Icons.flag_outlined,
                            color: defaultColor,
                            size: 26,
                          ),
                          title: Text(
                            'FQA',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Cardo',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: defaultColor,
                            size: 26,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ListTile(
                          onTap: () {
                            navigateTo(context, AboutUsScreen());
                          },
                          dense: true,
                          horizontalTitleGap: -8,
                          minVerticalPadding: 15,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          tileColor: Colors.grey[200],
                          leading: Icon(
                            Icons.error_outline,
                            color: defaultColor,
                            size: 26,
                          ),
                          title: Text(
                            'About US',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Cardo',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: defaultColor,
                            size: 26,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ListTile(
                          onTap: () {
                            navigateTo(context, ContactUsScreen());
                          },
                          dense: true,
                          horizontalTitleGap: -8,
                          minVerticalPadding: 15,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          tileColor: Colors.grey[200],
                          leading: Icon(
                            Icons.call,
                            color: defaultColor,
                            size: 26,
                          ),
                          title: Text(
                            'Contact US',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Cardo',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: defaultColor,
                            size: 26,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        DefaultButton(
                            icon: Icons.exit_to_app,
                            onClick: () {
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
                                    if (state is LogoutSuccessState)
                                      showToast(
                                          text: logout!.message.toString(),
                                          state: ToastStates.SUCCESS);
                                    ShopCubit.get(context)
                                        .logOutUser(context: context);
                                  }).show();
                            },
                            text: 'SignOut')
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
