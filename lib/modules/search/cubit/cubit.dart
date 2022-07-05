import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/models/search_model.dart';
import 'package:shopping_app/modules/search/cubit/states.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/network/end_points.dart';
import 'package:shopping_app/shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates>{
  SearchCubit() : super(InitialSearchState());

  static SearchCubit get(context) => BlocProvider.of(context);


  SearchModel? searchModel;
  var searchController = TextEditingController();
  void search({String? text}){
    emit(LoadingSearchState());
    DioHelper.postData(url: SEARCH,
        token: token,
        data: {
      'text': text,
        }).then((value) {
          searchModel = SearchModel.fromJson(value.data);
          print(value.data);
          emit(SuccessSearchState());
    }).catchError((error){
      print(error.toString());
      emit(ErrorSearchState());
    });
}

  void clearSearchData() {
    searchController.clear();

  }
  }