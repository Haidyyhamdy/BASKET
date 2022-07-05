import 'dart:developer';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopping_app/layout/shop__layout.dart';
import 'package:shopping_app/modules/login/login_screen.dart';
import 'package:shopping_app/modules/register/cubit/cubit.dart';
import 'package:shopping_app/modules/register/cubit/states.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/components/default_button.dart';
import 'package:shopping_app/shared/components/default_text_field.dart';
import 'package:shopping_app/shared/network/local/cache_helper.dart';

import '../../shared/components/defaultTextButton.dart';
import '../../shared/cubit/cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var phoneController = TextEditingController();
    var nameController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            if (state.model.status == true) {
              log('${state.model.message}');
              log('${state.model.data!.token}');
              CacheHelper.saveData(key: 'token', value: state.model.data!.token)
                  .then((value) {
                token = state.model.data!.token;
                navigateAndReplace(context, LoginScreen());
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
          var cubit = RegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(
            ),
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                            width: 150,
                            height: 150,
                            child: Image.asset('assets/images/logo.png')),
                      ),
                      Text(
                        'Create your Account',
                        style: TextStyle(
                            fontFamily: 'Cardo',
                            color: ModeCubit.get(context).isDark
                                ? Colors.white
                                : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Full Name',
                        style: TextStyle(
                            fontFamily: 'Cardo',
                            color: defaultColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      DefaultTextField(
                          controller: nameController,
                          text: 'Name',
                          prefix: Icons.person,
                          type: TextInputType.text,
                          validate: "Please Enter your name.."
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Phone',
                        style: TextStyle(
                            fontFamily: 'Cardo',
                            color: defaultColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      DefaultTextField(
                          controller: phoneController,
                          prefix: Icons.phone,
                          maxLength: 11,
                          text: 'Phone',
                          type: TextInputType.phone,
                          validate: "Please Enter your phone.."
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
                          prefix: Icons.email,
                          text: 'Email',
                          type: TextInputType.emailAddress,
                          validate: "Please Enter your email.."
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
                        prefix: Icons.lock,
                        text: 'Password',
                        type: TextInputType.visiblePassword,
                        validate:"Please Enter your password..",
                        isPassword: cubit.isPassword,
                        suffix: cubit.suffix,
                        suffixPressed: () {
                          cubit.changePasswordVisibility();
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ConditionalBuilder(
                        condition: state is! RegisterLoadingState,
                        builder: (context) => Container(
                          width: double.infinity,
                          child: DefaultButton(
                              onClick: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.userRegister(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              text: 'SIGN UP'),
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Have An Account?',
                          ),
                          DefaultTextButton(
                            background: ModeCubit.get(context).isDark? HexColor('22303c') :Colors.white,

                            text: 'Sign In',
                              onClick: () {
                                navigateAndReplace(context, LoginScreen()); },),
                        ],
                      )
                    ],
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
