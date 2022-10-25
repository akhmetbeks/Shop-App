// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../providers/auth.dart';
import '../screen/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final selectedProd = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: selectedProd.id,
            );
          },
          child: Image.network(
            selectedProd.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: FittedBox(
            child: Text(selectedProd.title),
            fit: BoxFit.scaleDown,
          ),
          leading: Consumer<Product>(
            builder: (ctx, selectedProd, child) => IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(
                  selectedProd.isFav ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                // Provider.of<Products>(context, listen: false).toggleFavorite(selectedProd.id);
                selectedProd.toggleFavStatus(authData.token, authData.userId);
              },
            ),
          ),
          trailing: IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.add_circle),
            onPressed: () {
              cart.addItem(
                  selectedProd.id, selectedProd.price, selectedProd.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added item to cart.'),
                  duration: Duration(seconds: 1),
                  action: SnackBarAction(label: "UNDO", onPressed: (){
                    cart.removeSingleItem(selectedProd.id);
                  }) 
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
