import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/components/default_button.dart';
import 'package:shopping_app/shared/components/default_text_field.dart';

var formState = GlobalKey<FormState>();
TextEditingController currentPasswordController = TextEditingController();
TextEditingController newPasswordController = TextEditingController();
void bottomSheetChangePassword({
  required BuildContext context,
  required ShopCubit cubit,
}) {
  showBarModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (context) => Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Change Password',
                      style: TextStyle(
                        color: defaultColor,
                        fontFamily: 'Cardo',
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0, bottom: 25),
                      child: Form(
                        key: formState,
                        child: Column(
                          children: [
                            DefaultTextField(
                                controller: currentPasswordController,
                                type: TextInputType.visiblePassword,
                                isPassword: cubit.isCurrentPassword,
                                prefix: Icons.lock_open_outlined,
                                suffix: cubit.suffix,
                                suffixPressed: () {
                                  cubit.changeCurrentPasswordVisibility();
                                },
                                validate: 'Please enter your current password',
                                text: 'current Password'),
                            SizedBox(
                              height: 10,
                            ),
                            DefaultTextField(
                                controller: newPasswordController,
                                type: TextInputType.visiblePassword,
                                isPassword: cubit.isNewPassword,
                                suffix: cubit.newPasswordSuffix,
                                suffixPressed: () {
                                  cubit.changeNewPasswordVisibility();
                                },
                                prefix: Icons.lock_open_outlined,
                                validate: 'Please enter your New password',
                                text: 'new Password'),
                            SizedBox(
                              height: 20,
                            ),
                            DefaultButton(
                              context: context,
                              text: 'Change Password',
                              onClick: () {
                                if (formState.currentState!.validate()) {
                                  cubit.changePassword(
                                      currentPassword:
                                          currentPasswordController.text,
                                      newPassword: newPasswordController.text);
                                  currentPasswordController.text = '';
                                  newPasswordController.text = '';
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}
