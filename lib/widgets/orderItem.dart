import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ordersProvider.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem({this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.order.amount}'),
          subtitle: Text(
            DateFormat('dd/MM/yyyy H:m').format(widget.order.dateTime),
          ),
          trailing: IconButton(
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
        ),
        if (_expanded)
          Container(
            height: min(widget.order.products.length * 20.0 + 10, 180),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              children: widget.order.products
                  .map(
                    (item) => Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.title,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Spacer(),
                        Text('${item.quantity} x \$${item.price}')
                      ],
                    ),
                  )
                  .toList(),
            ),
          )
      ]),
    );
  }
}
