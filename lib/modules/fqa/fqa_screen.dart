import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/layout/cubit/states.dart';
import 'package:shopping_app/models/fqa_model.dart';

import '../../shared/components/constant.dart';

class FqaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Theme.of(context).iconTheme.color,

              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            title: Text(
              'FAQ',
              style: TextStyle(
                  fontFamily: 'Cardo',
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: state is FaqLoadingStates
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cubit.faqModel!.data!.data!.length,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: ExpansionTile(
                                backgroundColor: Colors.grey[50],
                                collapsedBackgroundColor: Colors.grey[50],
                                iconColor: defaultColor,
                                childrenPadding: EdgeInsets.only(
                                    left: 15.0, right: 15.0, bottom: 15.0),
                                collapsedIconColor: defaultColor,
                                tilePadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                                controlAffinity:
                                ListTileControlAffinity.trailing,
                                title: Text(
                                  cubit.faqModel!.data!.data![index].question!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 14),
                                ),
                                children: [
                                  Text(
                                    cubit.faqModel!.data!.data![index].answer!,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 10.0,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget buildFQA(FqaData? model, context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model!.question!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            Text(
              model.answer!,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      );
}
