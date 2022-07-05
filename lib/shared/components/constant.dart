
import 'package:flutter/material.dart';
import 'package:shopping_app/shared/network/local/cache_helper.dart';

String? token = CacheHelper.getData(key: 'token');
const Color defaultColor = Colors.pink;

void NavigateTo({context,router})=>  Navigator.push(context,MaterialPageRoute(builder: (context) => router));