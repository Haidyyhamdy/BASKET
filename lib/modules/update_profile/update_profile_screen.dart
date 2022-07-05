import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/layout/cubit/states.dart';
import 'package:shopping_app/models/login_model.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/components/default_button.dart';
import 'package:shopping_app/shared/components/default_text_field.dart';

class UpdateProfileScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();

  var base64Image;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is UpdateProfileSuccessState) {
          showToast(
            text: state.model.message.toString(),
            state: ToastStates.SUCCESS,
          );
        }else if(state is UpdateProfileErrorState){
          showToast(
            text: state.error.toString(),
            state: ToastStates.ERROR,
          );
        }
      },
      builder: (context, state) {
        LoginModel? model = ShopCubit.get(context).userData;
        emailController.text = model!.data!.email!;
        phoneController.text = model.data!.phone!;
        nameController.text = model.data!.name!;
        return ConditionalBuilder(
            condition: ShopCubit.get(context).userData != null,
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: Text(
                      ' Profile',
                      style: TextStyle(
                        fontFamily: 'Cardo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (state is UpdateProfileLoadingState)
                              LinearProgressIndicator(
                                backgroundColor: Colors.black,
                                color: Colors.pink,
                              ),
                            SizedBox(
                              height: 20,
                            ),
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
                              ShopCubit.get(context)
                                  .userData!
                                  .data!
                                  .name
                                  .toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              ShopCubit.get(context)
                                  .userData!
                                  .data!
                                  .email
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                'Full Name',
                                style: TextStyle(
                                  color: defaultColor,
                                  fontFamily: 'Cardo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DefaultTextField(
                              controller: nameController,
                              text: 'Name',
                              prefix: Icons.person,
                              type: TextInputType.text,
                              validate: "Please Enter your name..",
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  fontFamily: 'Cardo',
                                  color: defaultColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DefaultTextField(
                                controller: emailController,
                                prefix: Icons.email,
                                text: 'Email',
                                type: TextInputType.emailAddress,
                                validate: "Please Enter your email.."),
                            SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                'Phone',
                                style: TextStyle(
                                  fontFamily: 'Cardo',
                                  color: defaultColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DefaultTextField(
                              maxLength: 11,
                              controller: phoneController,
                              prefix: Icons.phone,
                              text: 'Phone',
                              type: TextInputType.phone,
                              validate: "Please Enter your phone..",
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            DefaultButton(
                                onClick: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopCubit.get(context).updateUserData(
                                        name: nameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                      //  image: base64Image.toString()
                                    );
                                  }
                                },
                                text: 'UPDATE')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            fallback: (context) => Center(
                  child: LinearProgressIndicator(
                    color: defaultColor,
                    backgroundColor: Colors.black,
                  ),
                ));
      },
    );
  }
}
