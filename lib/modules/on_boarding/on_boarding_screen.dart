import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopping_app/modules/login/login_screen.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/components/default_button.dart';
import 'package:shopping_app/shared/cubit/cubit.dart';
import 'package:shopping_app/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../shared/components/defaultTextButton.dart';

class PagesModel {
  final String image;
  final String title;
  final String body;
  PagesModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController controller = PageController();
  bool isLast = false;
  List onBoardingPages = [
    PagesModel(
        image: 'assets/images/board1.png',
        title: 'Hello To Shop App',
        body: ' You can now shop online and whenever you want .'),
    PagesModel(
        image: 'assets/images/board2.png',
        title: 'Choose and checkout',
        body: 'Choose your products and pay for the product \n  '
            '                     you puy safely and easily.'),
    PagesModel(
        image: 'assets/images/board3.png',
        title: 'Get it delivered',
        body: 'Your products is  delivered to your home\n    '
            '                  safely and securely.'),
  ];
  void submit() {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        navigateAndReplace(context, LoginScreen());
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: 'BAS',
              style: TextStyle(
                fontSize: 28,
                color: defaultColor,
                fontFamily: 'Cardo',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'KET',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontFamily: 'Cardo',
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ])),
          Expanded(
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: controller,
              itemBuilder: (context, index) =>
                  buildOnBoardingItem(onBoardingPages[index]),
              itemCount: onBoardingPages.length,
              onPageChanged: (int index) {
                if (index == onBoardingPages.length - 1) {
                  setState(() {
                    isLast = true;
                  });
                } else {
                  setState(() {
                    isLast = false;
                  });
                }
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SmoothPageIndicator(
            controller: controller,
            count: onBoardingPages.length,
            effect: const JumpingDotEffect(
                activeDotColor: defaultColor,
                dotColor: Colors.grey,
                dotWidth: 25.0,
                dotHeight: 8.0,
                spacing: 5.0),
          ),
          const SizedBox(
            height: 20.0,
          ),
          if (!isLast)
            Row(
              children: [
                DefaultTextButton(
                  background: ModeCubit.get(context).isDark? HexColor('22303c') :Colors.white,
                    text: 'Skip',
                    onClick: () {
                      submit();
                    }),
                Spacer(),
                DefaultTextButton(
                  background: ModeCubit.get(context).isDark? HexColor('22303c') :Colors.white,
                  text: 'Next',
                  onClick: () {
                    controller.nextPage(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: Duration(milliseconds: 500));
                  },
                )
              ],
            ),
          if (isLast)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DefaultButton(
                  onClick: () {
                    submit();
                  },
                  text: 'Get Start'),
            ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget buildOnBoardingItem(PagesModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image(
              image: AssetImage(model.image),
              fit: BoxFit.fitWidth,
            ),
          ),
          Text(
            model.title,
            style: const TextStyle(
              fontSize: 22,
              color: defaultColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            model.body,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
