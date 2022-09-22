import 'package:flutter/material.dart';
import 'package:shoping_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders extends ChangeNotifier {
   List<OrderItem> _orderItems = [];

  List<OrderItem> get orders {
    return [..._orderItems];
  }

  Future<void> fetchAndsetOrders() async {
    final url = Uri.parse(
        'https://flutter-shop-app-48226-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(url);
    List<OrderItem> loadedOrders = [];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>?;
    if(extractedData == null){
      return;
    }
    extractedData.forEach((key, value) {
      loadedOrders.add(OrderItem(
        id: key,
        amount: value['amount'],
        dateTime: DateTime.parse(value['dateTime']),
        products: (value['products'] as List<dynamic>)
            .map((e) => CartItem(
                id: e['id'], title: e['title'], quantity: e['quantity'], price: e['price']))
            .toList(),
      ),
      );
    });
    _orderItems = loadedOrders.reversed.toList();
    notifyListeners();
    // print(jsonDecode(response.body));
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flutter-shop-app-48226-default-rtdb.firebaseio.com/orders.json');
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantity': e.quantity,
                      'price': e.price
                    })
                .toList()
          }));
      print(jsonDecode(response.body));
      _orderItems.insert(
        0,
        OrderItem(
            id: jsonDecode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: DateTime.now()),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
