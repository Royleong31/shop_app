import 'package:flutter/material.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/cartProvider.dart';
import 'package:shop_app/providers/productsProvider.dart';
import 'package:shop_app/screens/productDetailScreen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  final bool onlyFavourites;
  ProductItem({this.onlyFavourites});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (_, product, __) => IconButton(
              icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavouriteStatus();
                if (onlyFavourites)
                  Provider.of<Products>(context, listen: false).refresh();
                print('refreshing');
              },
            ),
          ),
          title: BorderedText(
            strokeWidth: 1.0,
            child: Text(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                decoration: TextDecoration.none,
                decorationColor: Colors.black,
              ),
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
