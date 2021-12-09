import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/user_product_item.dart';
import 'package:provider/provider.dart';
// import '';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const namedRoute = '/user_product';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.namedRoute);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (_, idx) {
            final prod = products.products[idx];
            return UserProductItem(prod.id!, prod.title, prod.imageUrl);
          },
          itemCount: products.products.length,
        ),
      ),
    );
  }
}
