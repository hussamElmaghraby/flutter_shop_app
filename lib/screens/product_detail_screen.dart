import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // const ProductDetailScreen(this.title);

  static const namedRoute = '/product_screen';

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<Products>(
      context,
      // you should do that if you only need data one time.
      //false: it means that it is not an active listener.
      listen: false,
    );
    String productId = ModalRoute.of(context)!.settings.arguments as String;
    final product = providerData.findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 2,
            ),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '\$${product.price}',
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(product.description, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
