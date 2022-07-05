import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/layout/cubit/states.dart';
import '../shared/components/myDrawer.dart';

class ShopLayout extends StatefulWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  _ShopLayoutState createState() => _ShopLayoutState();
}

class _ShopLayoutState extends State<ShopLayout> {
  PersistentTabController controller = PersistentTabController(initialIndex: 2);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        if (cubit.isHome)
        {
          return Scaffold(
            drawer:MyDrawer(),
            body: PersistentTabView(
              context,
              controller: controller,
              onItemSelected: (int value) {
                setState(() {
                  cubit.currentIndex = value;
                });
                cubit.changeIndex(value);
              },
              screens: cubit.screens,
              navBarHeight: 60,
              items: cubit.navBarsItems(),
              confineInSafeArea: true,
              backgroundColor: Colors.pinkAccent,
              // Default is Colors.white.
              handleAndroidBackButtonPress: true,
              // Default is true.
              resizeToAvoidBottomInset: true,
              // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
              stateManagement: true,
              // Default is true.
              hideNavigationBarWhenKeyboardShows: true,
              // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
              decoration: const NavBarDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                colorBehindNavBar: Colors.white,
              ),
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              itemAnimationProperties: const ItemAnimationProperties(
                // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: const ScreenTransitionAnimation(
                // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                curve: Curves.easeInOutCirc,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle
                  .style15, // Choose the nav bar style with this property.
            ),
          );
        }
        else
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 250,
                      height: 250,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'LOADING...',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    LinearProgressIndicator(
                      backgroundColor: Colors.black,
                      color: Colors.pink,
                    ),
                  ],
                ),
              ),
            ),
          );
     },
    );
  }
}
