import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen/cart_screen.dart';
import '../widget/badge.dart';
import '../widget/products_grid.dart';
import '../widget/app_drawer.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';

enum FilterOptions { Favorites, All }

class ProductItemsScreen extends StatefulWidget {
  @override
  State<ProductItemsScreen> createState() => _ProductItemsScreenState();
}

class _ProductItemsScreenState extends State<ProductItemsScreen> {
  var _showFavs = false;
  var _isInit = true;
  var _loading = false;
  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchProducts();
    // });
    
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit){
      setState(() {
        _loading = true;
      });
      Provider.of<Products>(context).fetchProducts(false). then((_) {
        _loading= false;
      });
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MySHOP"),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showFavs = true;
                  } else {
                    _showFavs = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("Favorites"),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text("All Products"),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch!, value: cart.itemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _loading ? Center(child: CircularProgressIndicator()) : ProductGrid(_showFavs),
    );
  }
}
