import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/Cart.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/badge.dart';
import 'package:flutter_shop_app/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FiltersOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _onlyShowFavorite = false;
  @override
  Widget build(BuildContext context) {
    final _productsData = Provider.of<Products>(
      context,
      listen: false,
    );

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FiltersOptions selectedValue) {
              setState(() {
                if (selectedValue == FiltersOptions.Favorites) {
                  _onlyShowFavorite = true;
                } else {
                  _onlyShowFavorite = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Only Favorites'),
                value: FiltersOptions.Favorites,
              ),
              const PopupMenuItem(
                child: Text('Show All'),
                value: FiltersOptions.All,
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Carts>(
            builder: (_, cart, child) => Badge(
              value: cart.itemCount.toString(),
              color: Colors.red,
              child: child!,
            ),
            //this child does not rebuild.
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: ProductGrid(_onlyShowFavorite),
    );
  }
}
