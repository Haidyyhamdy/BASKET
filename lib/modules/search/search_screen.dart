import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/modules/products/product_details_screen.dart';
import 'package:shopping_app/modules/search/cubit/cubit.dart';
import 'package:shopping_app/modules/search/cubit/states.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/style/colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var searchController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocProvider(
        create: (context) => SearchCubit(),
        child: BlocConsumer<SearchCubit, SearchStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var model = ShopCubit.get(context).homeModel;
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: TextFormField(
                  onEditingComplete: () {
                    if (searchController.text.isEmpty) {
                      return null;
                    } else {
                      SearchCubit.get(context)
                          .search(text: searchController.text);
                    }
                  },
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Search must not be empty';
                    }
                    return null;
                  },
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: IconTheme.of(context).color,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      if (searchController.text.isEmpty) {
                        return null;
                      } else {
                        SearchCubit.get(context)
                            .search(text: searchController.text);
                      }
                    },
                    icon: Icon(
                      Icons.search,
                      color: defaultColor,
                      size: 30,
                    ),
                  )
                ],
              ),
              body: SearchCubit.get(context).searchModel != null
                  ? Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            if (state is LoadingSearchState)
                              LinearProgressIndicator(
                                backgroundColor: AppColor.black,
                                color: defaultColor,
                              ),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) => InkWell(
                                        onTap: () {
                                          ShopCubit.get(context)
                                              .getProductDetailData(
                                                  id: model!.data!
                                                      .products[index].id!);
                                          navigateTo(context, ProductDetails());
                                        },
                                        child: buildProductItem(
                                            SearchCubit.get(context)
                                                .searchModel!
                                                .data!
                                                .products[index],
                                            context),
                                      ),
                                  separatorBuilder: (context, index) =>
                                      Container(),
                                  itemCount: SearchCubit.get(context)
                                      .searchModel!
                                      .data!
                                      .products
                                      .length),
                            )
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/search.png',
                            width: 200,
                            height: 200,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Oops! No Result Found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            '  Please check spelling or try different keywords',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
            );
          },
        ));
  }
}
