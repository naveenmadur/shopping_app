import 'package:flutter/material.dart';
import 'package:shoping_app/models/orders.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderWidget extends StatefulWidget {
  final OrderItem orderItem;
  const OrderWidget({Key? key, required this.orderItem}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    var item = widget.orderItem.products;
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.orderItem.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height:
                  min(widget.orderItem.products.length * 20.0 + 20 , 100.0),
              child: ListView.builder(
                itemCount: item.length,
                itemBuilder: (context, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item[index].title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${item[index].quantity} x \$${item[index].price}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
