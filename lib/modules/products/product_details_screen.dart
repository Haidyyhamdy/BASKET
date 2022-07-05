import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/layout/cubit/cubit.dart';
import 'package:shopping_app/layout/cubit/states.dart';
import 'package:shopping_app/models/product_details_model.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:shopping_app/shared/components/default_button.dart';
import 'package:shopping_app/shared/style/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../cart/cart_screen.dart';
import '../search/search_screen.dart';


class ProductDetails extends StatelessWidget {
  var pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is SuccessChangeCartSuccessState){
          showToast(
            text: state.changeCartsModel.message.toString(),
            state: ToastStates.SUCCESS,
          );
        }
      },
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Scaffold(
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
          body: state is ProductDetailsLoadingStates
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: LinearProgressIndicator(
                      color: defaultColor,
                      backgroundColor: Colors.black,
                    ),
                  ),
                )
              : cubit.productDetailsModel == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: LinearProgressIndicator(
                          color: defaultColor,
                          backgroundColor: Colors.black,
                        ),
                      ),
                    )
                  : buildBody(
                      ShopCubit.get(context).productDetailsModel, context),
        );
      },
    );
  }

  Widget buildBody(ProductDetailsModel? model, context) {
    return ShopCubit.get(context).productDetailsModel == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Stack(children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      child: PageView.builder(
                        controller: pageController,
                        itemBuilder: (context, index) =>
                            CachedNetworkImage(
                              imageUrl:ShopCubit.get(context)
                                  .productDetailsModel!
                                  .data!
                                  .images![index].toString(),
                              width: 120,
                              height: 120,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.contain,

                            ),

                        itemCount: ShopCubit.get(context)
                            .productDetailsModel!
                            .data!
                            .images!
                            .length,
                      ),
                    ),

                    if (model!.data!.discount != 0)
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
                                message: '${model.data!.discount}% OFF',
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
                  ]),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: ShopCubit.get(context)
                          .productDetailsModel!
                          .data!
                          .images!
                          .length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: defaultColor,
                        dotColor: AppColor.grey,
                        dotHeight: 15,
                        dotWidth: 15,
                        spacing: 5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    model.data!.name.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    children: [
                      Text(
                        'EGP ${model.data!.price}',
                        style:
                            const TextStyle(fontSize: 20, color: defaultColor),
                      ),
                      SizedBox(width: 5,),
                      if (model.data!.discount != 0)
                        Text(
                          'EGP ${model.data!.oldPrice!.round()}',
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            print(model.data!.id);
                            ShopCubit.get(context)
                                .changeFavorites(model.data!.id);
                          },
                          icon: ShopCubit.get(context).favorites[model.data!.id]!
                              ? Icon(
                            Icons.favorite,
                            color: defaultColor,
                          )
                              : Icon(Icons.favorite_border),
                        ),
                      ),
                    ],
                  ),
                  DefaultButton(onClick: () {
                    ShopCubit.get(context).changeCart(
                        productId:ShopCubit.get(context).productDetailsModel!.data!.id! );
                  },
                      text: (ShopCubit.get(context).productDetailsModel!.data!.inCart.toString() == "true")?
                      "REMOVE FROM CART" :"ADD TO CART",),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Divider(
                      height: 2,
                      color: defaultColor,
                      endIndent: 10,
                      indent: 10,
                    ),
                  ),
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(model.data!.description.toString()),
                ],
              ),
            ),
          );
  }
}


