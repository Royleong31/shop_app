import 'package:flutter/material.dart';
import 'package:shop_app/widgets/productItem.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';
import '../providers/productsProvider.dart';

class ProductsGrid extends StatelessWidget {
  final bool onlyFavourites;
  ProductsGrid({this.onlyFavourites});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        onlyFavourites ? productsData.favouriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(onlyFavourites: onlyFavourites),
      ),
    );
  }
}
