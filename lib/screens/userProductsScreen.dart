import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/productsProvider.dart';
import 'package:shop_app/screens/editProductsScreen.dart';
import 'package:shop_app/widgets/userProductItem.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user_products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 10, right: 0, bottom: 10),
          child: Consumer<Products>(
            builder: (_, productsData, __) => ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (_, i) {
                var currentItem = productsData.items[i];
                return Column(
                  children: [
                    UserProductItem(
                      currentItem.imageUrl,
                      currentItem.title,
                      currentItem.id,
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
