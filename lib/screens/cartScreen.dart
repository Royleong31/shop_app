import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cartProvider.dart' show Cart;
import 'package:shop_app/providers/ordersProvider.dart';
import 'package:shop_app/screens/ordersScreen.dart';
import '../widgets/cartItem.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Text('Total',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(),
                          cart.totalAmount,
                        );
                        cart.clear();
                      },
                      child: Text('Order Now'))
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) {
                var cartList = cart.items.values.toList();
                return CartItem(
                  id: cartList[i].id,
                  itemKey: cart.items.keys.toList()[i],
                  title: cartList[i].title,
                  price: cartList[i].price,
                  quantity: cartList[i].quantity,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
