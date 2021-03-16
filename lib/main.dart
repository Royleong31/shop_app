import 'package:flutter/material.dart';
import 'package:shop_app/providers/cartProvider.dart';
import 'package:shop_app/providers/ordersProvider.dart';
import 'package:shop_app/screens/authScreen.dart';
import 'package:shop_app/screens/cartScreen.dart';
import 'package:shop_app/screens/editProductsScreen.dart';
import 'package:shop_app/screens/ordersScreen.dart';
import 'package:shop_app/screens/productDetailScreen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/userProductsScreen.dart';
import 'screens/productsOverviewScreen.dart';
import './providers/productsProvider.dart';
import 'package:provider/provider.dart';
import './providers/authProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: null,
            update: (ctx, auth, previousProduct) => Products(
                  auth.token,
                  auth.userId,
                  previousProduct == null ? [] : previousProduct.items,
                )),
        ChangeNotifierProvider<Cart>(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: null,
            update: (ctx, auth, previousOrder) => Orders(
                auth.token,
                auth.userId,
                previousOrder == null ? [] : previousOrder.orders)),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            // textTheme: Theme.of(context).copyWith(),
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SplashScreen();
                    } else
                      return AuthScreen();
                  }),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
