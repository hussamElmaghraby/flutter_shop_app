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
  final String? userId;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.userId,
    required this.imageUrl,
    this.isFavorite = false,
  });
  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorite(String authToken, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      var response = await http.put(
        Uri.parse(
          'https://shop-app-58703-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken',
        ),
        body: json.encode(
          isFavorite,
        ),
      );
      print('error out');
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
        print('error if');
        throw Exception("Error changing status");
      }
    } catch (error) {
      print('error catch');
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
  final String? authToken;
  final String? userId;

  Products(this.authToken, this.userId, this._products);

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
        Uri.parse('$uri/products.json?auth=$authToken'),
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          },
        ),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          isFavorite: product.isFavorite,
          userId: '');
      _products!.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    try {
      await http.patch(
        Uri.parse('$uri/products/$id.json?auth=$authToken'),
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

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    try {
      final response = await http
          .get(Uri.parse('$uri/products.json?auth=$authToken&$filterString'));
      final extractedData = json.decode(response.body) as Map<String?, dynamic>;
      // if (extractedData == null) {
      //   return;
      // }
      final url =
          'https://shop-app-58703-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(
        Uri.parse(url),
      );
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
            imageUrl: prodData['imageUrl'],
            userId: userId,
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
