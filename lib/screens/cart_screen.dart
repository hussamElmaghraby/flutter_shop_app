import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/Cart.dart' show Carts;
import 'package:flutter_shop_app/providers/orders.dart';
import '../widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/cart_screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Carts>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            elevation: 10,
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total"),
                  const SizedBox(
                    width: 10,
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      "\$${cart.totalAmount}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed(routeName);
                      Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(), cart.totalAmount);
                      cart.clear();
                    },
                    child: const Text("ORDER NOW"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, idx) {
                final currentCart = cart.items.values.toList()[idx];
                final cartKey = cart.items.keys.toList()[idx];
                return CartItem(currentCart.id, cartKey, currentCart.title,
                    currentCart.quantity, currentCart.price);
              },
              itemCount: cart.itemCount,
            ),
          )
        ],
      ),
    );
  }
}
