import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/screens/cart_screen.dart';
import 'package:shoping_app/screens/edit_product_screen.dart';
import 'package:shoping_app/screens/products_overview_screen.dart';
import 'package:shoping_app/models/product_data.dart';
import 'package:shoping_app/screens/product_detail_screen.dart';
import 'package:shoping_app/models/cart.dart';
import 'models/orders.dart';
import 'screens/orders_screen.dart';
import 'screens/user_products_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductData()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Orders()),
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan)
              .copyWith(secondary: Colors.red),
        ),
        home: const ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrdersScreen.routeName: (context) => const OrdersScreen(),
          UserProductsScreen.routeName: (context) => const UserProductsScreen(),
          EditProducts.routeName: (context) => const EditProducts(),
        },
      ),
    );
  }
}
