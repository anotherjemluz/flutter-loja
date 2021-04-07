import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
import '../data/dummy_data.dart';

class Products with ChangeNotifier {
  List<Product> _items = dummyProductsData;

  //retorna uma copia
  List<Product> get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  int get itemsCount {
    return _items.length;
  }

  // retorna a referencia (a variavel propriamente dita)
  // List<Product> get items => _items;

  Future<void> addProduct(Product newProduct) {
    const url = 'https://flutter-loja-41af1-default-rtdb.firebaseio.com/products';
    return http.post(
      url,
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite,
      }),
    ).then((response) { 
      _items.add(Product(
        id:  json.decode(response.body)['name'],
        title: newProduct.title,
        description: newProduct.description,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl,
      ));
      notifyListeners();
    }).then((_) => null);
  }

  void updateProduct(Product product) {
    if (product != null && product.id != null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    }
  }

  // -----------------------------------
  // SHOW ALL OR FAVORITES GLOBAL CONTROL

  // bool _showFavoriteOnly = false;

  // List<Product> get items {
  //   if(_showFavoriteOnly) {
  //     return _items.where((product) => product.isFavorite).toList();
  //   }
  //   return [ ..._items ];
  // }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }
}
