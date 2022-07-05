
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopping_app/shared/components/constant.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/components/defaultTextButton.dart';
import '../../shared/cubit/cubit.dart';
import '../products/products_screen.dart';

class AllOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Orders',
            ),
            leading: IconButton(
              onPressed: () {
               Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            elevation: 0,
          ),
          body:ShopCubit.get(context).ordersModel == null?
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: LinearProgressIndicator(
                    color: defaultColor,
                    backgroundColor: Colors.black,
                  ),
                ),
              ):
          ShopCubit.get(context).ordersModel!.data!.ordersDetails!.isEmpty
              ?  Center(
                child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Image.asset(
                  'assets/images/orders.png',
                  height: 200,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'You Haven\'t Placed \n    Any Orders Yet.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'when you do, their status\n      will appear hear',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                DefaultTextButton(
                    background: ModeCubit.get(context).isDark? HexColor('22303c') :Colors.white,
                    text: 'START SHOPPING',
                    onClick: () {
                      navigateTo(context, ProductsScreen());
                    }),
            ],
          ),
              )
          :(state is! ShopLoadingGetOrdersState)
              ? ListView.separated(
                  padding: const EdgeInsets.all(15.0),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Slidable(
                      key: ValueKey(index),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              cubit.cancelOrder(
                                  id: cubit.ordersModel!.data!
                                      .ordersDetails![index].id!);
                              cubit.getOrders();
                            },
                            foregroundColor: Colors.red,
                            label: 'Cancel',
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ],
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey[50],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('Date:'),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        cubit.ordersModel!.data!
                                            .ordersDetails![index].date!,
                                        style: TextStyle(color: defaultColor),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Total:'),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text( 'EGP ${cubit.ordersModel!.data!
                                              .ordersDetails![index].total}',

                                        style: TextStyle(color: defaultColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                cubit.ordersModel!.data!.ordersDetails![index]
                                    .status!,
                                style: TextStyle(
                                    color: cubit.ordersModel!.data!
                                                .ordersDetails![index].status ==
                                            'New'
                                        ? defaultColor
                                        : Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10.0,
                    );
                  },
                  itemCount: cubit.ordersModel!.data!.ordersDetails!.length,
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }
}
