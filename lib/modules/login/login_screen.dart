import 'dart:developer';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopping_app/layout/shop__layout.dart';
import 'package:shopping_app/modules/login/cubit/cubit.dart';
import 'package:shopping_app/modules/login/cubit/states.dart';
import 'package:shopping_app/modules/register/register_screen.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/components/default_button.dart';
import 'package:shopping_app/shared/components/defaultTextButton.dart';
import 'package:shopping_app/shared/network/local/cache_helper.dart';

import '../../shared/components/default_text_field.dart';
import '../../shared/cubit/cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
      ],
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (BuildContext context, Object? state) {
          if (state is LoginSuccessState) {
            if (state.model.status == true) {
              log('${state.model.message}');
              log('${state.model.data!.token}');
              CacheHelper.saveData(key: 'token', value: state.model.data!.token)
                  .then((value) {
                token = state.model.data!.token;
                navigateAndReplace(context, ShopLayout());
              });
              showToast(
                text: state.model.message.toString(),
                state: ToastStates.SUCCESS,
              );
            } else {
              log('${state.model.message}');
              showToast(
                text: state.model.message.toString(),
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                              width: 150,
                              height: 150,
                              child: Image.asset('assets/images/logo.png')),
                        ),
                        Text(
                          'Login to your Account',
                          style: TextStyle(
                              fontFamily: 'Cardo',
                                  color: ModeCubit.get(context).isDark? Colors.white : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Email',
                          style: TextStyle(
                              fontFamily: 'Cardo',
                              color: defaultColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        DefaultTextField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: 'email must not empty..',
                          text: ' Email ',
                          prefix: Icons.email,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Password',
                          style: TextStyle(
                              fontFamily: 'Cardo',
                              color: defaultColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        DefaultTextField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: 'password must not empty..',
                            isPassword: cubit.isPassword,
                            text: ' Password ',
                            prefix: Icons.lock,
                            suffix: LoginCubit.get(context).suffix,
                            suffixPressed: () {
                              cubit.changePasswordVisibility();
                            },
                            onSubmit: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            }),
                        SizedBox(
                          height: 40,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (BuildContext context) => Center(
                            child: DefaultButton(
                                onClick: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                },
                                text: 'SIGN IN'),
                          ),
                          fallback: (BuildContext context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                            ),
                            DefaultTextButton(
                                background: ModeCubit.get(context).isDark? HexColor('22303c') :Colors.white,

                                text: 'Sign Up',
                                onClick: () {
                                  navigateAndReplace(context, RegisterScreen());
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
