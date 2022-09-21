import 'package:flutter/material.dart';
import 'package:shoping_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product_data.dart';

class UserProductItem extends StatelessWidget {
  final String title, imageUrl, id;
  const UserProductItem(
      {Key? key, required this.id, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final productData = Provider.of<ProductData>(context, listen: false);
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
                  Navigator.of(context)
                      .pushNamed(EditProducts.routeName, arguments: id);
                },
                icon: const Icon(Icons.edit),
                color: Colors.green,
              ),
              IconButton(
                onPressed: () async {
                  try {
                    await productData.deleteProducts(id);
                  } catch (error) {
                    //cant access context in async methos. So need to use scaffoldMessenger variable.
                    scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Deleting Failed!', textAlign: TextAlign.center,)));
                    // AlertDialog(title: Text(error.toString()),);
                  }
                },
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
