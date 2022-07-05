import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/layout/cubit/states.dart';
import 'package:shopping_app/models/favorites_model.dart';
import 'package:shopping_app/modules/products/products_screen.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/components/defaultTextButton.dart';

import '../../shared/cubit/cubit.dart';
import '../products/product_details_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is SuccessChangeFavoriteState){
          showToast(
              text: state.model.message.toString(),
              state: ToastStates.SUCCESS,
          );
        }
      },
      builder: (context, state) {
        var model = ShopCubit.get(context).homeModel;
        return ShopCubit.get(context).favoritesModel!.data!.data!.isEmpty
            ? Scaffold(
          appBar: AppBar(
            title: Text('My WishList'),
            centerTitle: true,
            leading: IconButton(
              onPressed: (){
                navigateTo(context, ProductsScreen());
              },
              icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).iconTheme.color,
              ),
            ),

          ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/empty_fav.png',
                      width: 200,),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Oops! Your WishList \n        is empty!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Save your favorite items here',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      DefaultTextButton(
                          background: ModeCubit.get(context).isDark? HexColor('22303c') :Colors.white,

                          text: 'START SHOPPING',
                          onClick: (){
                            navigateTo(context, ProductsScreen());
                          }),
                    ],
                  ),
                ),
              )
            : Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: (){
                navigateTo(context, ProductsScreen());
              },
              icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            centerTitle: true,
            title: Text(
              'My WishList',
              style: TextStyle(
                fontFamily: 'Cardo',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                ShopCubit.get(context).getProductDetailData(id: model!.data!.products[index].id );
                navigateTo(context, ProductDetails());
              },
              child: buildFavoriteItem(
                  ShopCubit.get(context)
                      .favoritesModel!
                      .data!
                      .data![index],
                  context),
            ),
            separatorBuilder: (context, index) => Container(),
            itemCount: ShopCubit.get(context)
                .favoritesModel!
                .data!
                .data!
                .length,
          ),
        );
      },
    );
  }

  Widget buildFavoriteItem(FavoriteData model, context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Card(
            child: Container(
              width: 120,
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        CachedNetworkImage(
                          imageUrl:model.product!.image.toString(),
                          width: 120,
                          height: 120,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.cover,

                        ),

                        if (model.product!.discount != 0)
                          Positioned.fill(
                              child: Align(
                            alignment: Alignment(1, -1),
                            child: ClipRect(
                              child: Banner(
                                location: BannerLocation.topStart,
                                color: Colors.red,
                                child: Container(
                                  height: 100.0,
                                ),
                                message: '${model.product!.discount}% OFF',
                                textStyle: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          )),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model.product!.name}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(height: 1.2, fontSize: 14),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              'EGP ${model.product!.price}',
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: defaultColor,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            if (model.product!.discount != 0)
                              Text(
                                'EGP ${model.product!.oldPrice}',
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Spacer(),

                            IconButton(
                              onPressed: () {

                                print(model.id);
                                ShopCubit.get(context)
                                    .changeFavorites(model.product!.id as int);
                              },
                              icon: ShopCubit.get(context)
                                      .favorites[model.product!.id]!
                                  ? Icon(
                                      Icons.favorite,
                                      color: defaultColor,
                                    )
                                  : Icon(Icons.favorite_border),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
