import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  UserProductItem(this.id, this.title, this.imageUrl);
  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: 100,
          // decoration: BoxDecoration(border: Border.all()),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.namedRoute, arguments: id);
                },
                color: Theme.of(context).colorScheme.primary,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                },
                color: Theme.of(context).colorScheme.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
