import 'package:flutter/material.dart';
import 'package:shoping_app/providers/cart.dart';
import 'package:shoping_app/providers/product_data.dart';
import 'package:shoping_app/screens/cart_screen.dart';
import 'package:shoping_app/widgets/app_drawer.dart';
import 'package:shoping_app/widgets/product_grid.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/widgets/badge.dart';
import '../providers/product_data.dart';

enum FilterOptions {
  favourites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFav = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<ProductData>(context).fetchProducts(); //Wont work

    //This Workd
    // Future.delayed(Duration.zero)
    //     .then((value) => Provider.of<ProductData>(context, listen: false).fetchProducts());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      if (_isInit) {
        _isLoading = true;
        Provider.of<ProductData>(context)
            .fetchProducts()
            .then((_) => _isLoading = false);
      }
    });
      _isInit = false;
      super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<ProductData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Humari Dukan'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selected) {
              setState(() {
                if (selected == FilterOptions.favourites) {
                  _showOnlyFav = true;
                } else {
                  _showOnlyFav = false;
                }
              });
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              size: 25,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favourites,
                child: Text('Favorites'),
              ),
              const PopupMenuItem(
                  value: FilterOptions.all, child: Text('Show All')),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              value: cart.itemCount.toString(),
              color: Colors.white,
              child: child!,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                size: 25,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showOnlyFav:_showOnlyFav),
    );
  }
}