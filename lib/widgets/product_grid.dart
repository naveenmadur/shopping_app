import 'package:flutter/material.dart';
import 'package:shoping_app/providers/product_data.dart';
import 'package:shoping_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showOnlyFav;
  const ProductGrid({Key? key, required this.showOnlyFav}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider
        .of<ProductData>(context);
    final products = showOnlyFav ? productsData.fav : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index) =>
          ChangeNotifierProvider.value(
            value: products[index],
            child: const ProductItem(),
          ),
    );
  }
}