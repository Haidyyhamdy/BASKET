import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/layout/cubit/states.dart';
import 'package:shopping_app/models/categories_model.dart';
import 'package:shopping_app/models/home_model.dart';
import 'package:shopping_app/modules/cart/cart_screen.dart';
import 'package:shopping_app/modules/categories/categories_details.dart';
import 'package:shopping_app/modules/products/product_details_screen.dart';
import 'package:shopping_app/modules/search/search_screen.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/components/defaultTextButton.dart';
import 'package:shopping_app/shared/cubit/cubit.dart';
import '../../shared/components/myDrawer.dart';
import '../categories/categories_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is SuccessChangeFavoriteState) {
          if (state.model.status == false) {
            showToast(
              text: state.model.message.toString(),
              state: ToastStates.ERROR,
            );
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
            condition: ShopCubit.get(context).homeModel != null &&
                ShopCubit.get(context).categoryModel != null &&
                ShopCubit.get(context).isHome,
            builder: (context) => Scaffold(
              appBar: AppBar(
                leading: Builder(
                  builder: (context){
                    return IconButton(
                        onPressed: (){
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(Icons.menu,
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
                  Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children:[
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
                              '${ShopCubit.get(context).cartModel!.data!.cartItems!.length}'
                              ,style: TextStyle(
                                color: Colors.white
                            ),
                            ),
                          ),
                        )
                      ]
                  ),
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
              drawer:MyDrawer(),
                  body: productBuilder(ShopCubit.get(context).homeModel,
                      ShopCubit.get(context).categoryModel, context),
                ),
            fallback: (context) =>
                Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget productBuilder(
          HomeModel? model, CategoriesModel? categoryModel, context) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model!.data!.banners
                  .map(
                    (e) => CachedNetworkImage(
                      imageUrl: e.image.toString(),
                      width: double.infinity,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 250,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
                viewportFraction: 1.0,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Cardo',
                            fontWeight: FontWeight.w700),
                      ),
                      Spacer(),
                      DefaultTextButton(
                          background: ModeCubit.get(context).isDark? HexColor('22303c') :Colors.white,

                          text: 'See All',
                          onClick: (){
                        navigateTo(context, CategoriesScreen());
                      })
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => buildCategoryItem(
                          categoryModel!.data!.data[index], context),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 5,
                      ),
                      itemCount: categoryModel!.data!.data.length,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Products',
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Cardo',
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.6,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(
                      model.data!.products.length,
                      (index) => buildGridProduct(
                            model.data!.products[index],
                            context,
                          ))),
            ),
          ],
        ),
      );

  Widget buildGridProduct(ProductModel model, context) => InkWell(
        onTap: () {
          ShopCubit.get(context).getProductDetailData(id: model.id);
          navigateTo(context, ProductDetails());
        },
        child: Card(
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
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      //fit: BoxFit.contain,
                    ),
                  ),
                  if (model.discount != 0)
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
                          message: '${model.discount}% OFF',
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
                              ShopCubit.get(context)
                                  .changeFavorites(model.id as int);
                            },
                            icon: ShopCubit.get(context).favorites[model.id]!
                                ? Icon(
                                    Icons.favorite,
                                    color: defaultColor,
                                  )
                                : Icon(Icons.favorite_border),
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     print(model.id);
                        //     ShopCubit.get(context).changeFavorites(model.id as int);
                        //   },
                        //   icon: ShopCubit.get(context).favorites[model.id]!
                        //       ? Icon(
                        //     Icons.shopping_cart_outlined,
                        //     color: defaultColor,
                        //   )
                        //       : Icon(Icons.shopping_cart),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildCategoryItem(DataModel model, context) => InkWell(
        onTap: () {
          ShopCubit.get(context).getCategoriesDetailData(model.id);
          navigateTo(context,
              CategoryDetailsScreen(nameOfCategory: model.name.toString()));
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            CachedNetworkImage(
              imageUrl: model.image.toString(),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Container(
              width: 100,
              color: Colors.black.withOpacity(.8),
              child: Text(
                "${model.name}",
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
}
