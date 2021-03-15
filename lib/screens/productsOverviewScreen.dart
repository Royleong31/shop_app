import 'package:flutter/material.dart';
import 'package:shop_app/providers/cartProvider.dart';
import 'package:shop_app/providers/productsProvider.dart';
import 'package:shop_app/screens/cartScreen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/productsGrid.dart';
import '../models/product.dart';
import '../widgets/productItem.dart';
import '../widgets/productsGrid.dart';
import 'package:provider/provider.dart';

enum selectedValue { showAll, onlyFavourites }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = 'products-overview';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool onlyFavourites = false;
  bool isInit = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // var productsObj = Provider.of<Products>(context);
    var cartObj = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            // icon: Icon(Icons.more_vert),
            onSelected: (val) {
              setState(() {
                if (val == selectedValue.onlyFavourites)
                  onlyFavourites = true;
                else if (val == selectedValue.showAll) onlyFavourites = false;
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favourites'),
                  value: selectedValue.onlyFavourites),
              PopupMenuItem(
                  child: Text('Show All'), value: selectedValue.showAll),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cartObj.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(onlyFavourites: onlyFavourites),
    );
  }
}
