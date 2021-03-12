import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/ordersProvider.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/orderItem.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: ordersData.count,
        itemBuilder: (_, i) => OrderItem(
          order: ordersData.orders[i],
        ),
      ),
    );
  }
}
