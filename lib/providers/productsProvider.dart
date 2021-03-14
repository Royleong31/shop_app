import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/httpException.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> get favouriteItems {
    return _items.where((el) => el.isFavourite == true).toList();
  }

  void refresh() {
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.https(
        'shop-app-9d267-default-rtdb.firebaseio.com', '/products.json');

    try {
      var response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavourite': product.isFavourite,
          }));

      print('-----------------');
      print(json.decode(response.body)['name']);

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      print(newProduct.id);
      print(newProduct.title);
      _items.add(newProduct);

      print(json.decode(response.body)['name']);
      notifyListeners();
    } catch (err) {
      print('==================================');
      throw err;
    }
  }

  Future<void> updateProducts(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex < 0) throw Error();

    var url = Uri.https(
        'shop-app-9d267-default-rtdb.firebaseio.com', '/products/$id.json');

    try {
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          },
        ),
      );

      _items[prodIndex] = newProduct;
      print(_items[prodIndex].title);
      notifyListeners();
      print('patching');
    } catch (err) {
      print(err);
    }
  }

  Future<void> deleteProduct(String id) async {
    var url = Uri.https(
        'shop-app-9d267-default-rtdb.firebaseio.com', '/products/$id.json');

    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      // fetchAndSetProduct();
      throw HttpException('Could not delete message');
    }
    existingProduct = null;
    print('deleted');
    notifyListeners();
  }

  Future<void> fetchAndSetProduct() async {
    final url = Uri.https(
        'shop-app-9d267-default-rtdb.firebaseio.com', '/products.json');
    final response = await http.get(url);
    final resMap = json.decode(response.body) as Map<String, dynamic>;
    final List<Product> loadedProducts = [];

    if (resMap == null) {
      return;
    }

    resMap.forEach((key, value) {
      loadedProducts.add(
        Product(
          id: key,
          description: value['description'],
          imageUrl: value['imageUrl'],
          price: value['price'],
          title: value['title'],
          isFavourite: value['isFavourite'],
        ),
      );
    });
    print(resMap);

    _items = loadedProducts;

    notifyListeners();
  }

  // bool showFavourites = false;

  // void setOnlyFavourites() {
  //   showFavourites = true;
  //   notifyListeners();
  // }

  // void setShowAll() {
  //   showFavourites = false;
  //   notifyListeners();
  // }

  List<Product> get items {
    // if (showFavourites) {
    //   return _items.where((item) => item.isFavourite == true).toList();
    // }
    return [..._items];
  }
}
