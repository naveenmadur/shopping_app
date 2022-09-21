import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/providers/cart.dart';

class CartObj extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String productId;

  const CartObj({
    Key? key,
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red[500],
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          size: 30,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) =>
          Provider.of<Cart>(context, listen: false).removeItem(productId),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) =>  AlertDialog(
            title: const Text('Are You Sure?'),
            content: const Text('Do you want to remove the item form the cart?'),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop(false);
              }, child: const Text('No'),),
              TextButton(onPressed: (){
                Navigator.of(context).pop(true);
              }, child: const Text('Yes'),),
            ],
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(title[0]),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
