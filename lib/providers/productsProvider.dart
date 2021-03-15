import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/httpException.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];
  String _authToken;
  String _userId;
  Products(this._authToken, this._userId, this._items);

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
      'shop-app-9d267-default-rtdb.firebaseio.com',
      '/products.json',
      {
        'auth': '$_authToken',
      },
    );

    try {
      var response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'userId': _userId,
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
      'shop-app-9d267-default-rtdb.firebaseio.com',
      '/products/$id.json',
      {
        'auth': '$_authToken',
      },
    );

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
      'shop-app-9d267-default-rtdb.firebaseio.com',
      '/products/$id.json',
      {
        'auth': '$_authToken',
      },
    );

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

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    var filteredParams = filterByUser
        ? {
            'orderBy': '"userId"',
            'equalTo': '"$_userId"',
          }
        : {};

    var url = Uri.https(
      'shop-app-9d267-default-rtdb.firebaseio.com',
      '/products.json',
      {
        'auth': '$_authToken',
        ...filteredParams,
      },
    );
    final response = await http.get(url);
    final resMap = json.decode(response.body) as Map<String, dynamic>;
    print('resMap');
    print(resMap);
    print('==========================================');
    final List<Product> loadedProducts = [];

    if (resMap == null) return;
    url = Uri.https('shop-app-9d267-default-rtdb.firebaseio.com',
        '/userFavourites/$_userId.json', {
      'auth': '$_authToken',
    });

    final favouriteResponse = await http.get(url);

    print(json.decode(favouriteResponse.body));
    final favMap = json.decode(favouriteResponse.body);

    resMap.forEach((key, value) {
      loadedProducts.add(
        Product(
          id: key,
          description: value['description'],
          imageUrl: value['imageUrl'],
          price: value['price'],
          title: value['title'],
          isFavourite: (favMap == null) ? false : (favMap[key] ?? false),
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
