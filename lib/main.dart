import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/Cart.dart';
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/screens/orders_screen.dart';
import 'package:flutter_shop_app/screens/product_detail_screen.dart';
import 'package:flutter_shop_app/screens/products_overview_widgets.dart';
import 'package:flutter_shop_app/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // only child widget which are listenning will rebuild.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Carts(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.purple,
          ).copyWith(secondary: Colors.deepOrange, surface: Colors.white),
          fontFamily: 'Lato',
          textTheme: const TextTheme(
            headline1: TextStyle(
                fontFamily: 'Lato', fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.namedRoute: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrdersScreen.namedRoute: (context) => OrdersScreen(),
          UserProductScreen.namedRoute: (context) => UserProductScreen(),
          EditProductScreen.namedRoute: (context) => EditProductScreen(),
        },
      ),
    );
  }
}
