import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/layout/cubit/states.dart';
import 'package:shopping_app/shared/components/constant.dart';



class AboutUsScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context,  state) {
      },
      builder: (context,  state) {
        ShopCubit cubit = ShopCubit.get(context);
        return Scaffold(

          appBar: AppBar(
            centerTitle: true,
            title: Text('About Us',
              style: TextStyle(
                fontFamily: 'Cardo'
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Theme.of(context).iconTheme.color,

              ),
              onPressed: () => Navigator.of(context).pop(),
            ),

          ),
          body:  ShopCubit.get(context).settingsModel !=null ?
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                child:Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200]!.withOpacity(0.8),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0, bottom: MediaQuery.of(context).size.height / 12,),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('About Us :',style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20
                              ),),
                              Text(cubit.settingsModel!.data!.about.toString(),style: TextStyle(color: Colors.black)),
                              SizedBox(height: 20,),
                              Text('Terms :',style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20
                              ),),
                              Text(cubit.settingsModel!.data!.terms.toString(),style: TextStyle(color: Colors.black)),
                            ],
                          ),)
                    ),
                  ],
                ),
              ),
            ),
          ): Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: LinearProgressIndicator(color: defaultColor,
                backgroundColor: Colors.black,),
            ),),



        );
      },
    );
  }
}