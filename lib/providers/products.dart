import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
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
  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _products = [
    Product(
      id: 'a1',
      title: 'Product1',
      description: 'desc desc desc',
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZHVjdHxlbnwwfHwwfHw%3D&w=1000&q=80',
      price: 2.6,
      isFavorite: false,
    ),
    Product(
      id: 'a2',
      title: 'Product2',
      description: 'desc desc desc',
      imageUrl:
          'https://images.pexels.com/photos/90946/pexels-photo-90946.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      price: 2.6,
      isFavorite: false,
    ),
    Product(
      id: 'a3',
      title: 'Product3',
      description: 'desc desc desc',
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZHVjdHxlbnwwfHwwfHw%3D&w=1000&q=80',
      price: 2.6,
      isFavorite: false,
    ),
    Product(
      id: 'a4',
      title: 'Product4',
      description: 'desc desc desc',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSreAlx8vw_nSEP7lJzvHzk__lcXehVxw02kQ&usqp=CAU',
      price: 2.6,
      isFavorite: false,
    ),
  ];
  var _showFavoritesOnly = false;

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favoriteProduct {
    return _products.where((product) => product.isFavorite == true).toList();
  }

  Product findById(String id) {
    return products.firstWhere((product) => product.id == id);
  }

  void result() {
    notifyListeners();
  }
}
