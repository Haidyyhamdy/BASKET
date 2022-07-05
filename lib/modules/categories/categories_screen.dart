import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/layout/cubit/states.dart';
import 'package:shopping_app/models/categories_model.dart';
import 'package:shopping_app/modules/categories/categories_details.dart';
import 'package:shopping_app/shared/components/components.dart';
import '../../shared/components/myDrawer.dart';
import '../cart/cart_screen.dart';
import '../search/search_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) {
                return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Icon(
                      Icons.menu,
                      color: Theme.of(context).iconTheme.color,
                    ));
              },
            ),
            title: Text(
              'BASKET',
              style: TextStyle(
                fontFamily: 'Cardo',
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Stack(alignment: AlignmentDirectional.topEnd, children: [
                IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: IconTheme.of(context).color,
                    ),
                    onPressed: () {
                      navigateTo(context, CartScreen());
                    }),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${ShopCubit.get(context).cartModel!.data!.cartItems!.length}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ]),
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: IconTheme.of(context).color,
                  ),
                  onPressed: () {
                    navigateTo(context, SearchScreen());
                  }),
            ],
          ),
          drawer: MyDrawer(),
          body: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => buildAllCategories(
                  ShopCubit.get(context).categoryModel!.data!.data[index],
                  context),
              separatorBuilder: (context, index) => Container(),
              itemCount:
                  ShopCubit.get(context).categoryModel!.data!.data.length),
        );
      },
    );
  }

  Widget buildAllCategories(DataModel? model, context) => InkWell(
        onTap: () {
          ShopCubit.get(context).getCategoriesDetailData(model!.id);
          navigateTo(
              context, CategoryDetailsScreen(nameOfCategory: model.name!));
        },
        child: Container(
          width: double.infinity,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Card(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: CachedNetworkImage(
                      imageUrl: model!.image.toString(),
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(.5),
                    ),
                    width: double.infinity,
                    height: 200,
                    child: Center(
                      child: Text(
                        '${model.name}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
