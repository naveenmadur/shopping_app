import 'package:flutter/material.dart';
import 'package:shoping_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductData extends ChangeNotifier {
   List<Product> _products = [];

  List<Product> get items {
    return [..._products];
  }

  List<Product> get fav {
    return [..._products].where((element) => element.isFavourite).toList();
  }

  Product find(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

//Fetching products from http GET request
  Future<void> fetchProducts() async {
    final url = Uri.parse(
        'https://flutter-shop-app-48226-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      final List<Product> loadedProducts = [];
      // print(json.decode(response.body));
      final data = json.decode(response.body) as Map<String, dynamic>;
      data.forEach((key, value) {
        loadedProducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            isFavourite: value['isFavourite'],
            imageUrl: value['imageUrl']));
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

//Adding Products from http POST
  Future<void> addProducts(Product p) async {
    final url = Uri.parse(
        'https://flutter-shop-app-48226-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': p.title,
            'description': p.description,
            'imageUrl': p.imageUrl,
            'price': p.price,
            'isFavourite': p.isFavourite
          }));
      // print(json.decode(value.body));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: p.title,
        description: p.description,
        imageUrl: p.imageUrl,
        price: p.price,
      );
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

//Updating products from http PATCH
  Future<void> updateProduct(String? id, Product p) async {
    final url = Uri.parse(
        'https://flutter-shop-app-48226-default-rtdb.firebaseio.com/products/$id.json');
        await http.patch(url, body: json.encode({
          'title': p.title,
          'description': p.description,
          'imageUrl': p.imageUrl,
          'price': p.price,
        }));
    final prodIndex = _products.indexWhere((element) => element.id == id);

    _products[prodIndex] = p;
    notifyListeners();
  }

}