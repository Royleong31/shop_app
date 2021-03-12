import 'package:flutter/material.dart';
import 'package:shop_app/providers/cartProvider.dart';
import 'package:shop_app/providers/ordersProvider.dart';
import 'package:shop_app/screens/cartScreen.dart';
import 'package:shop_app/screens/ordersScreen.dart';
import 'package:shop_app/screens/productDetailScreen.dart';
import 'screens/productsOverviewScreen.dart';
import './providers/productsProvider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products>(create: (ctx) => Products()),
        ChangeNotifierProvider<Cart>(create: (ctx) => Cart()),
        ChangeNotifierProvider<Orders>(create: (ctx) => Orders()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          // textTheme: Theme.of(context).copyWith(),
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
        },
      ),
    );
  }
}
