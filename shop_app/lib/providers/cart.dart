import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  // ignore: prefer_final_fields
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach(
      (key, cartItem) {
        total += cartItem.price * cartItem.quantity;
      },
    );
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity + 1,
            price: existingCartItem.price),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (cartItem) => CartItem(
            id: cartItem.id,
            title: cartItem.title,
            quantity: cartItem.quantity - 1,
            price: cartItem.price),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void updateQuantitySingleItem({required String productId, required bool increase}) {
    if (!_items.containsKey(productId)) {
      return;
    }

    increase
        ? _items.update(
            productId,
            (cartItem) => CartItem(
                id: cartItem.id,
                title: cartItem.title,
                quantity: cartItem.quantity + 1,
                price: cartItem.price),
          )
        : (_items[productId]!.quantity > 1)
            ? _items.update(
                productId,
                (cartItem) => CartItem(
                    id: cartItem.id,
                    title: cartItem.title,
                    quantity: cartItem.quantity - 1,
                    price: cartItem.price),
              )
            : _items.remove(productId);

    notifyListeners();
  }
}
