import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool _showOnlyFavourite;

  ProductGrid(this._showOnlyFavourite);
  @override
  Widget build(BuildContext context) {
    // Listen here to change it that class.
    //generic ->  to let it know which type of data you wanna listen.
    final providerData = Provider.of<Products>(context);
    final productsData = _showOnlyFavourite
        ? providerData.favoriteProduct
        : providerData.products;
    return GridView.builder(
      itemBuilder: (ctx, idx) {
        final product = productsData[idx];
        return ChangeNotifierProvider.value(
          value: product,
          child: ProductItem(),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      padding: const EdgeInsets.all(10),
      itemCount: productsData.length,
    );
  }
}
