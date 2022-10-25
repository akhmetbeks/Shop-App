import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart_provider.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  Order(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<Order> _orders = [];
  final String token;
  final String userId;

  Orders(this.token, this.userId, this._orders);

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchOrder() async {
    final url = Uri.parse(
        'https://fir-login-ad009-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$token');
    final response = await http.get(url);
    final List<Order> loadedData = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedData.add(
        Order(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: DateTime.now().toString(),
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity'],
                  ))
              .toList(),
        ),
      );
    });
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProds, double total) async {
    final dateTime = DateTime.now();
    final url = Uri.parse(
        'https://fir-login-ad009-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$token');
    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': dateTime.toIso8601String(),
          'products': cartProds.map((item) {
            return {
              'title': item.title,
              'quantity': item.quantity,
              'price': item.price
            };
          }).toList()
        },
      ),
    );
    _orders.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProds,
        dateTime: dateTime,
      ),
    );
    notifyListeners();
  }
}
