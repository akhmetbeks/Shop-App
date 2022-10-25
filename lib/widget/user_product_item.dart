import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../screen/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({required this.id, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffoldContext = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: FittedBox(
        fit: BoxFit.contain,
        child: Row(children: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id);
          }, icon: Icon(Icons.edit, color: Theme.of(context).accentColor,)),
          IconButton(onPressed: () async {
            try{
              await Provider.of<Products>(context, listen: false).removeItem(id);
            } catch(_){
              scaffoldContext.showSnackBar(SnackBar(content: Text('Deleting failed', textAlign: TextAlign.center,),));
            }
            
          }, icon: Icon(Icons.delete_outline, color: Theme.of(context).errorColor,)),
        ],),
      ),
    );
  }
}
