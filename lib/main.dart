import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/layout/shop__layout.dart';
import 'package:shopping_app/modules/login/cubit/cubit.dart';
import 'package:shopping_app/modules/login/login_screen.dart';
import 'package:shopping_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:shopping_app/modules/search/cubit/cubit.dart';
import 'package:shopping_app/shared/bloc_observer.dart';
import 'package:shopping_app/shared/cubit/cubit.dart';
import 'package:shopping_app/shared/cubit/states.dart';
import 'package:shopping_app/shared/network/local/cache_helper.dart';
import 'package:shopping_app/shared/network/remote/dio_helper.dart';
import 'package:shopping_app/shared/style/themes.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () async {
      DioHelper.init();
      await CacheHelper.init();
      bool? isDark = CacheHelper.getData(key: 'isDark');
      bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
      String? token = CacheHelper.getData(key: 'token');
      log(token.toString());
      Widget widget;
      if (onBoarding != null) {
        if (token != null) {
          widget = ShopLayout();
        } else {
          widget = LoginScreen();
        }
      } else {
        widget = OnBoardingScreen();
      }
   log(onBoarding.toString());
      runApp(MyApp(
        isDark: isDark,
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
 final bool? isDark;
  final Widget startWidget;

  MyApp({
     this.isDark,
    required this.startWidget});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ModeCubit()..changeAppMode(
                fromShared: isDark
            )),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => SearchCubit()),
      BlocProvider(create: (context) => ShopCubit()
       ..getHomeData()
        ..getCategories()
        ..getFavorite()
        ..getUserData()
        ..getFaqData()
        ..getSettings()
        ..getCartData()
      ),
      ],

      child: BlocConsumer<ModeCubit, ModeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
             theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ModeCubit.get(context).isDark ? ThemeMode.dark
                : ThemeMode.light,
            home: SplashScreenView(
              navigateRoute:startWidget,
              imageSrc: 'assets/images/logo.png',
              duration: 2000,
              imageSize: 170,
            )

          );
        },
      ),
    );
  }
}
