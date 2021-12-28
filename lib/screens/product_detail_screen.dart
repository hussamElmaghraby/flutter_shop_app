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
      // appBar: AppBar(
      //   title: Text(product.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                product.title,
              ),
              background: Hero(
                tag: product.id!,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '\$${product.price}',
                  textAlign: TextAlign.center,
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
          SizedBox(
            height: 800,
          )
        ],
        // child: Column(
        //   children: [],
      ),
    );
    // );
  }
}
