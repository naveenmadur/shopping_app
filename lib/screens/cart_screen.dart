import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/models/cart.dart' show Cart;
import 'package:shoping_app/widgets/cart_item.dart';
import 'package:shoping_app/models/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15.0),
            color: Colors.lightBlue[300],
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text('\$${cart.totalAmount.toStringAsFixed(2)}'),
                    backgroundColor: Colors.greenAccent,
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(), cart.totalAmount);
                      cart.clearCart();
                    },
                    child: const Text(
                      'OrderNow',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) => CartObj(
              id: cart.items.values.toList()[index].id,
              title: cart.items.values.toList()[index].title,
              price: cart.items.values.toList()[index].price,
              quantity: cart.items.values.toList()[index].quantity,
              productId: cart.items.keys.toList()[index],
            ),
            itemCount: cart.itemCount,
          ))
        ],
      ),
    );
  }
}
