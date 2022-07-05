import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/layout/cubit/states.dart';
import 'package:shopping_app/models/categories_details_model.dart';
import 'package:shopping_app/modules/products/product_details_screen.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/cubit/cubit.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final String nameOfCategory;
  CategoryDetailsScreen({required this.nameOfCategory});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              nameOfCategory,
              style: TextStyle(
                fontFamily: 'Cardo',
                fontWeight: FontWeight.bold,
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
          body: state is! CategoryDetailsLoadingStates
              ? SingleChildScrollView(
            physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.68,
                          shrinkWrap: true,
                          physics:NeverScrollableScrollPhysics(),
                          children: List.generate(
                              ShopCubit.get(context)
                                  .categoriesDetailModel!
                                  .data!
                                  .productData!
                                  .length,
                              (index) => buildProduct(
                                  ShopCubit.get(context)
                                      .categoriesDetailModel!
                                      .data!
                                      .productData![index],
                                  context)),
                        ),
                      )
                    ],
                  ),
                )
              : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: LinearProgressIndicator(
                    color: defaultColor,
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
        );
      },
    );
  }

  Widget buildProduct(ProductData model, context) => InkWell(
    onTap: (){
      ShopCubit.get(context).getProductDetailData(id:model.id);
      navigateTo(context, ProductDetails());
    },
    child: Card(
      color: ModeCubit.get(context).isDark?   HexColor('22303c'):Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
         color:ModeCubit.get(context).isDark?   HexColor('22303c'):defaultColor,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: model.image.toString(),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.fitHeight,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),

                ),

              ),
              if (model.discount != 0)
                Positioned.fill(
                    child: Align(
                      alignment: Alignment(1,-1),
                      child: ClipRect(
                        child: Banner(
                          location: BannerLocation.topStart,
                          color: Colors.red,
                          child: Container(
                            height: 100.0,
                          ),
                          message: '${model.discount}% OFF',
                          textStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),

                        ),
                      ),
                    )
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.name}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(height: 1.2, fontSize: 14),
                ),
                Row(
                  children: [
                    Text(
                      'EGP ${model.price.round()}',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: defaultColor,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    if (model.discount != 0)
                      Text(
                        'EGP ${model.oldPrice.round()}',
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Spacer(),
                    Expanded(
                      child: IconButton(
                        // padding: EdgeInsets.zero,
                        onPressed: () {
                          print(model.id);
                          ShopCubit.get(context).changeFavorites(model.id as int);
                        },
                        icon: ShopCubit.get(context).favorites[model.id]!
                            ? Icon(
                          Icons.favorite,
                          color: defaultColor,
                        )
                            : Icon(Icons.favorite_border),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
