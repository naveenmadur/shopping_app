import 'package:flutter/material.dart';
import 'package:shoping_app/models/http_exception.dart';
import 'package:shoping_app/providers/product.dart';
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

//Fetching products using http GET request
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

//Adding Products using http POST
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

//Updating products using http PATCH
  Future<void> updateProduct(String? id, Product p) async {
    final url = Uri.parse(
        'https://flutter-shop-app-48226-default-rtdb.firebaseio.com/products/$id.json');
    await http.patch(url,
        body: json.encode({
          'title': p.title,
          'description': p.description,
          'imageUrl': p.imageUrl,
          'price': p.price,
        }));
    final prodIndex = _products.indexWhere((element) => element.id == id);

    _products[prodIndex] = p;
    notifyListeners();
  }

//Deleting products using http
  Future<void> deleteProducts(String id) async {
    final url = Uri.parse(
        'https://flutter-shop-app-48226-default-rtdb.firebaseio.com/products/$id.json');
    final existingProdIndex =
        _products.indexWhere((element) => element.id == id);
    Product? existingProduct = _products[existingProdIndex];
    _products.removeAt(existingProdIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _products.insert(existingProdIndex, existingProduct);
      notifyListeners();
      throw HttpException(message: 'Couldn\'t delete item');
    }
    existingProduct = null;
  }
}
