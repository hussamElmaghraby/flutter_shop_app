import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/Cart.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/splash_screen.dart';
import 'package:flutter_shop_app/screens/auth_screen.dart';
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
          create: (ctx) => Auth(),
        ),
        // this provider will rebuild when auth rebuilt.
        // if auth were to update, then 'Product' will be able to update accordingly.
        // Creates products object with our list
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (_, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.products),
          create: (context) => Products(null, null, []),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Carts(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (_, auth, previousOrders) => Orders(auth.token, auth.userId,
              previousOrders == null ? [] : previousOrders.orders),
          create: (ctx) => Orders(null, null, []),
        ),
      ],
      // Material app will rebuild when ever Auth rebuilds.
      child: Consumer<Auth>(
          // auth -> is the latest object of auth
          builder: (context, auth, _) => MaterialApp(
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.purple,
                    accentColor: Colors.deepOrange,
                  ).copyWith(
                      secondary: Colors.deepOrange, surface: Colors.white),
                  fontFamily: 'Lato',
                  textTheme: const TextTheme(
                    headline1: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                home: auth.isAuth
                    ? ProductsOverviewScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (_, snapshot) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? SplashScreen()
                                : AuthScreen()),
                routes: {
                  ProductDetailScreen.namedRoute: (context) =>
                      ProductDetailScreen(),
                  CartScreen.routeName: (context) => const CartScreen(),
                  OrdersScreen.namedRoute: (context) => const OrdersScreen(),
                  UserProductScreen.namedRoute: (context) =>
                      const UserProductScreen(),
                  EditProductScreen.namedRoute: (context) =>
                      const EditProductScreen(),
                },
              )),
    );
  }
}
