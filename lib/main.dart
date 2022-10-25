import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screen/splash_screen.dart';
import './screen/product_items_screen.dart';
import './screen/product_detail_screen.dart';
import './screen/orders_screen.dart';
import './screen/cart_screen.dart';
import './screen/user_product_screen.dart';
import './screen/edit_product_screen.dart';
import './screen/auth_screen.dart';
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './providers/auth.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (ctx) => Products('', '', []),
              update: (ctx, authData, prevProd) => Products(
                    authData.token,
                    authData.userId,
                    prevProd == null ? [] : prevProd.items,
                  )),
          ChangeNotifierProvider(create: (_) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders('', '', []),
            update: (ctx, auth, prevOrders) => Orders(
              auth.token,
              auth.userId,
              prevOrders == null ? [] : prevOrders.orders,
            ),
          )
        ],
        child: Consumer<Auth>(
          builder: (context, authData, ch) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "MyShop",
              theme: ThemeData(
                  textTheme:
                      TextTheme(headline6: TextStyle(color: Colors.green)),
                  primarySwatch: Colors.deepOrange,
                  accentColor: Colors.green,
                  fontFamily: 'Lato'),
              home: authData.isAuth
                  ? ProductItemsScreen()
                  : FutureBuilder(
                      future: authData.tryAutoLogin(),
                      builder: (ctx, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductScreen.routeName: (ctx) => UserProductScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              },
            );
          },
        ));
  }
}
