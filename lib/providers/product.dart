import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String desc;
  final double price;
  final String imageUrl;
  bool isFav;

  Product({
    required this.id,
    required this.title,
    required this.desc,
    required this.price,
    required this.imageUrl,
    this.isFav = false,
  });

  void _setFavValue(bool isFavOld) {
    isFav = isFavOld;
  }

  Future<void> toggleFavStatus(String token, String userId) async {
    final oldStatus = isFav;
    isFav = !isFav;
    notifyListeners();

    final url = Uri.parse(
        'https://fir-login-ad009-default-rtdb.asia-southeast1.firebasedatabase.app/userFavs/$userId/$id.json?auth=$token');
    try {
      final response =
          await http.put(url, body: json.encode(isFav));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
        notifyListeners();
      }
    } catch (err) {
      _setFavValue(oldStatus);
      notifyListeners();
    }
  }
}
