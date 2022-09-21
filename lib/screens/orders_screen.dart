import 'package:flutter/material.dart';
import 'package:shoping_app/providers/orders.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => Provider.of<Orders>(context, listen: false).fetchAndsetOrders());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemBuilder: (context, index) =>
            OrderWidget(orderItem: orderData.orders[index]),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
