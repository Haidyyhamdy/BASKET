import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/layout/cubit/states.dart';
import 'package:shopping_app/models/contact_model.dart';
import 'package:shopping_app/shared/components/constant.dart';


class ContactUsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> ShopCubit()..getContactUs(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ShopCubit.get(context).contactUsModel;
          return state is LoadingGetContactUsState?
           Scaffold(
             appBar: AppBar(
               centerTitle: true,
               title: Text('Contact Us',
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
             body: Center(
               child: Padding(
                 padding: const EdgeInsets.all(10.0),
                 child: LinearProgressIndicator(
                   color: defaultColor,
                   backgroundColor:Colors.black,
                 ),
               ),
             ),
           )
          :Scaffold(

            appBar: AppBar(
              centerTitle: true,
              title: Text('Contact Us',
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

            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        SizedBox(
                          height: 40.0,
                        ),
                        Container(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>buildContacts(
                            cubit!.data!.data[index], index,context,
                            ),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 20.0,
                            ),
                            itemCount: 5,
                          ),
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

List<String> website = ['Facebook', 'Instagram', 'Twitter', 'Gmail', 'Phone'];
Widget buildContacts(ContactData model, index,context)=> Container(
    height: 70,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),
      border: Border.all(
          width: 1,
          color:Colors.grey
      ),),
    child: Row(children: [
      SizedBox(width: 10),
      CachedNetworkImage(
        imageUrl: model.image.toString(),
        color: defaultColor,
        width: 40.0,
        height: 40.0,
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      ),

      SizedBox(width: 15),
      Text(website[index]),
      Spacer(),
      Icon(
        Icons.navigate_next,
        color:defaultColor ,
        size: 30,
      ),
    ],)
);
