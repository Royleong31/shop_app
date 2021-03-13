import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {
    // 'sfad': CartItem(id: 'sfad', price: 34223.2, quantity: 3, title: 'sfad')
  };

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          title: title,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return total;
  }

  int get itemCount {
    return _items.length == null ? 0 : _items.length;
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (item) => CartItem(
          id: item.id,
          price: item.price,
          quantity: item.quantity - 1,
          title: item.title,
        ),
      );
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
