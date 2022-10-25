import 'dart:convert';

import 'package:flutter/material.dart';

import 'product.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  final String tokenAuth;
  final String userId;

  Products(this.tokenAuth, this.userId, this._items);

  List<Product> get favItems {
    return _items.where((prodItem) => prodItem.isFav).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product getProdById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchProducts(bool filterByUser) async {
    final filterString = 'https://fir-login-ad009-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$tokenAuth&orderBy="creatorId"&equalTo="$userId"';
    final notFilterString = 'https://fir-login-ad009-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$tokenAuth';
    final List<Product> loadedData = [];
    var url = Uri.parse(filterByUser ? filterString : notFilterString);
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    url = Uri.parse(
        'https://fir-login-ad009-default-rtdb.asia-southeast1.firebasedatabase.app/userFavs/$userId.json?auth=$tokenAuth');
    final responseFavorite = await http.get(url);
    final extractedDataFavorites = json.decode(responseFavorite.body);
    extractedData.forEach((prodId, prodData) {
      loadedData.add(Product(
        id: prodId,
        title: prodData['title'],
        desc: prodData['description'],
        price: prodData['price'],
        imageUrl: prodData['imageUrl'],
        isFav: extractedDataFavorites == null
            ? false
            : extractedDataFavorites[prodId] ?? false,
      ));
    });
    _items = loadedData;
    notifyListeners();
    // print(json.decode(response.body));
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://fir-login-ad009-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$tokenAuth');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.desc,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
            // 'isFavorite': product.isFav,
          }));
      // print(json.decode(response.body));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        desc: product.desc,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.insert(0, newProduct);
    } catch (err) {
      throw err;
    }

    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProd) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://fir-login-ad009-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$tokenAuth');
      http.patch(url,
          body: json.encode({
            'title': newProd.title,
            'price': newProd.price,
            'description': newProd.desc,
            'imageUrl': newProd.imageUrl,
          }));
      _items[prodIndex] = newProd;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> removeItem(String id) async {
    final url = Uri.parse(
        'https://fir-login-ad009-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$tokenAuth');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    // final Product? existingProduct = null;
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete an item.');
    }
    existingProduct = null;
  }

  // Future<void> toggleFavorite(String id) async {
  //   final existingProduct = _items.firstWhere((prod) => prod.id == id);
  //   final url = Uri.parse(
  //       'https://fir-login-ad009-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
  //   try {
  //     final response = await http.patch(
  //       url,
  //       body: json.encode(
  //         {
  //           'isFavorite': !existingProduct.isFav,
  //         },
  //       ),
  //     );
  //     notifyListeners();
  //   } catch (err) {
  //     print('Something went wrong.');
  //   }
  // }
}
