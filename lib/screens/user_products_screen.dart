import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/providers/product_data.dart';
import 'package:shoping_app/widgets/app_drawer.dart';
import 'package:shoping_app/widgets/user_product_item.dart';
import 'package:shoping_app/screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const routeName = '/UserProduct';

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<ProductData>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductData>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProducts.routeName);
            },
          )
        ],
        centerTitle: false,
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: (() => _refresh(context)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (context, index) => Column(
              children: [
                UserProductItem(
                    id: productsData.items[index].id,
                    title: productsData.items[index].title,
                    imageUrl: productsData.items[index].imageUrl),
                const Divider(
                  thickness: 1.0,
                )
              ],
            ),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
