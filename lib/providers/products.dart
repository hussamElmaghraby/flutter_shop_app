import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/http_exception.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      var response = await http.patch(
        Uri.parse(
            'https://shop-app-58703-default-rtdb.firebaseio.com/products/$id.json'),
        body: json.encode(
          {'isFavorite': isFavorite},
        ),
      );

      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
        throw Exception("Error changing status");
      }
    } catch (error) {
      _setFavValue(oldStatus);
      rethrow;
    }
    notifyListeners();
  }
}

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product>? _products = [];
  var _showFavoritesOnly = false;

  List<Product> get products {
    return [..._products!];
  }

  final uri = 'https://shop-app-58703-default-rtdb.firebaseio.com/';

  List<Product> get favoriteProduct {
    return _products!.where((product) => product.isFavorite == true).toList();
  }

  Product findById(String id) {
    return products.firstWhere((product) => product.id == id);
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/products.json'),
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
            // 'creatorId': "",
          },
        ),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          isFavorite: product.isFavorite);
      _products!.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    try {
      await http.patch(
        Uri.parse('$uri/products/$id.json'),
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            // 'isFavourite': newProduct.isFavorite,
          },
        ),
      );
      final prodIndex =
          _products!.indexWhere((prod) => prod.id == newProduct.id);
      if (prodIndex >= 0) {
        _products![prodIndex] = newProduct;
        notifyListeners();
      } else {
        print("...");
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$uri/products.json'));
      final extractedData = json.decode(response.body) as Map<String?, dynamic>;
      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite'],
          ),
        );
        _products = loadedProduct;
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
    {}
  }

  Future<void> deleteProduct(String id) async {
    final existingProductIndex = _products!.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _products![existingProductIndex];
    // ignore: argument_type_not_assignable_to_error_handler
    _products!.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse('$uri/$id.json'));

    if (response.statusCode >= 400) {
      //something is wrong.
      _products!.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product");
    }

    existingProduct = null;
  }
}
