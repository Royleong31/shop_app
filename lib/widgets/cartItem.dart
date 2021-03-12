import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cartProvider.dart';

class CartItem extends StatelessWidget {
  final String itemKey;
  final String id;
  final double price;
  final int quantity;
  final String title;

  CartItem({this.itemKey, this.id, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.delete,
            size: 40,
            color: Colors.white,
          ),
        ),
        alignment: Alignment.centerRight,
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(itemKey);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
                child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('\$${price.toStringAsFixed(2)}'),
              ),
            )),
            title: Text('$title'),
            subtitle:
                Text('Total Price: \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
