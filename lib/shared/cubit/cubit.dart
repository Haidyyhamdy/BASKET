import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/shared/cubit/states.dart';
import 'package:shopping_app/shared/network/local/cache_helper.dart';

class ModeCubit extends Cubit<ModeStates> {
  ModeCubit() : super(AppInitialStates());

  static ModeCubit get(context) => BlocProvider.of(context);

  bool isDark = true;
  Color backgroundColor = Colors.white;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
    } else {
      isDark = !isDark;
      CacheHelper.putData(key: 'isDark', value: isDark).then((value) {
        if (isDark) {
          emit(AppChangeMode());
        } else {
          emit(AppChangeMode());
        }
        emit(AppChangeMode());
      });
    }
  }
}
