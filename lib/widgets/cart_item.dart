import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/Cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem(this.id, this.productId, this.title, this.quantity, this.price);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        child: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.surface,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      ),
      direction: DismissDirection.endToStart,
      // confirmDismiss: (dd) {},
      onDismissed: (direction) {
        Provider.of<Carts>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Are Yor Sure ?"),
            content:
                const Text('Do you want to remove the item from the cart ? '),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  "No",
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  "Yes",
                ),
              )
            ],
          ),
        );
      },
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$${price.toStringAsFixed(2)}'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('\$${price * quantity}'),
            trailing: Text('${quantity} x'),
          ),
        ),
      ),
    );
  }
}
