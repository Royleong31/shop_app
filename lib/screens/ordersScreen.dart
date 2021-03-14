import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/ordersProvider.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/orderItem.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    print('building orders');
    return Scaffold(
        appBar: AppBar(title: Text('Your Orders')),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Consumer<Orders>(
                builder: (_, ordersData, __) => ListView.builder(
                  itemCount: ordersData.count,
                  itemBuilder: (_, i) => OrderItem(
                    order: ordersData.orders[i],
                  ),
                ),
              );
            }
          },
        ));
  }
}
