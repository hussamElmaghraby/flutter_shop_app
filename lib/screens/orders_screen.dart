import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/orders.dart' show Orders;
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const namedRoute = '/order_screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _obtainFutureOrders() async {
    await Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: FutureBuilder(
        future: _obtainFutureOrders(),
        builder: (context, snapshot) {
          // final orders = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              // do error handling
              print(snapshot.error);
              print(snapshot.data);
              return const Center(
                child: Text("An Error Occurs !"),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orders, _) => ListView.builder(
                  itemBuilder: (ctx, idx) => OrderItem(orders.orders[idx]),
                  itemCount: orders.orders.length,
                ),
              );
            }
          }
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}
