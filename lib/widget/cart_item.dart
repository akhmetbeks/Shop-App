import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(
      {required this.id,
      required this.productId,
      required this.price,
      required this.quantity,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: Center(child: Text('Confirm')),
                  content: Text('Do you really want to delete the item from the cart?'),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.of(context).pop(false);
                    }, child: Text("No")),
                    TextButton(onPressed: (){
                      Navigator.of(context).pop(true);
                    }, child: Text("Yes")),
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 4,
        ),
        child: Icon(
          Icons.delete,
          size: 40,
          color: Theme.of(context).errorColor,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: ListTile(
            leading: CircleAvatar(
                child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FittedBox(
                child: Text(
                  '\$$price',
                ),
              ),
            )),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
