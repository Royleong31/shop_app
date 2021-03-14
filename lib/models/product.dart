import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/httpException.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavouriteStatus() async {
    final url = Uri.https(
        'shop-app-9d267-default-rtdb.firebaseio.com', '/products/$id.json');

    isFavourite = !isFavourite;
    notifyListeners();
    final res = await http.patch(
      url,
      body: json.encode(
        {
          'isFavourite': isFavourite,
        },
      ),
    );

    if (res.statusCode >= 400) {
      isFavourite = !isFavourite;
      notifyListeners();
      throw HttpException('Error updating favourite status');
    }
  }

  Product copyWith({
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
    bool isFavourite,
  }) {
    return Product(
      id: id ?? this.id,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      title: title ?? this.title,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
