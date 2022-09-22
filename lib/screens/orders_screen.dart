import 'package:flutter/material.dart';
import 'package:shoping_app/providers/orders.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';
  
  @override
  Widget build(BuildContext context) {
    print('building...');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: const AppDrawer(),
        //While using future builder be cautious and check whether 
        //there is a listner in the build method, which may causes the 
        //build method to rebuild everytime the notify listener is 
        //called from the data. 
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchAndsetOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return const Center(
                  child: Text('An Error Occured'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (context, orderData, child) => ListView.builder(
                    itemBuilder: (context, index) =>
                        OrderWidget(orderItem: orderData.orders[index]),
                    itemCount: orderData.orders.length,
                  ),
                );
              }
            }
          },
        ));
  }
}
