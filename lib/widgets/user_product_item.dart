import 'package:flutter/material.dart';
import 'package:shoping_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title, imageUrl, id;
  const UserProductItem({Key? key, required this.id, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 35,
        ),
        title: Text(title),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProducts.routeName, arguments: id);
                },
                icon: const Icon(Icons.edit),
                color: Colors.green,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
