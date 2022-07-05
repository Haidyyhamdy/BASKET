import 'package:shopping_app/models/login_model.dart';

abstract class RegisterStates {}

class RegisterInitialStates extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {
  final LoginModel model;

  RegisterSuccessState(this.model);
}

class RegisterErrorState extends RegisterStates {
  final error;

  RegisterErrorState(this.error);
}

class RegisterChangePasswordVisibility extends RegisterStates {}

class RegisterChangeConfirmPasswordVisibility extends RegisterStates {}
