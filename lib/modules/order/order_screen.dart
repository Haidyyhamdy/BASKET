
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/layout/cubit/states.dart';
import 'package:shopping_app/shared/components/default_button.dart';
import 'package:shopping_app/shared/components/default_text_field.dart';

import '../../shared/components/constant.dart';
import '../../shared/cubit/cubit.dart';

class OrderScreen extends StatelessWidget {
  var formState = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Order',
              style: TextStyle(
                fontFamily: 'Cardo',
                fontWeight: FontWeight.bold,
              ),
            ),


          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formState,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: defaultColor,
                            thickness: 1.2,
                            indent: 10.0,
                            endIndent: 10.0,
                          ),
                        ),
                        Text(
                          'Enter Your Address',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: defaultColor,
                            thickness: 1.2,
                            indent: 10.0,
                            endIndent: 10.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
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
                        prefix: Icons.person_outline,
                        controller: nameController,
                        type: TextInputType.text,
                        validate: 'Please enter your name',
                        text: 'Name'),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'City',
                      style: TextStyle(
                          fontFamily: 'Cardo',
                          color: defaultColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    DefaultTextField(
                      text: 'City',
                      prefix: Icons.location_on_outlined,
                      controller: cityController,
                      type: TextInputType.text,
                      validate: 'Please enter your city',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Region',
                      style: TextStyle(
                          fontFamily: 'Cardo',
                          color: defaultColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    DefaultTextField(
                        prefix: Icons.location_on_outlined,
                        controller: regionController,
                        type: TextInputType.text,
                        validate: 'Please enter your region',
                        text: 'Region'),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Details',
                      style: TextStyle(
                          fontFamily: 'Cardo',
                          color: defaultColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    DefaultTextField(
                        prefix: Icons.note_add_outlined,
                        controller: detailsController,
                        type: TextInputType.text,
                        validate: 'Please enter your details',
                        text: 'Details'),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Notes',
                      style: TextStyle(
                          fontFamily: 'Cardo',
                          color: defaultColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    DefaultTextField(
                        prefix: Icons.note_outlined,
                        controller: notesController,
                        type: TextInputType.text,
                        validate: 'Please enter your notes',
                        text: 'Notes'),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            elevation: 0.0,
            child: Container(
              height: 125,
              width: double.infinity,
              decoration: BoxDecoration(
               color: ModeCubit.get(context).isDark
                    ? HexColor('22303c')
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 1,
                      color: Color(0xFF8D8E98),
                      spreadRadius: 0.1),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 14.0, left: 25, bottom: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'EGP ${cubit.cartModel!.data!.total}',
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
                    DefaultButton(
                        onClick: () {
                          if (formState.currentState!.validate()) {
                            cubit.addAddress(
                              name: nameController.text,
                              city: cityController.text,
                              region: regionController.text,
                              details: detailsController.text,
                              notes: notesController.text,
                            );
                          }
                        },
                        text: 'Confirm'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
