import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders_provider.dart';
import '../widget/order_item.dart';
import '../widget/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;

  Future _obtainOrdersFuture() async {
    return await Provider.of<Orders>(context, listen: false).fetchOrder();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (_, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(child: Text('An error occured'));
            } else {
              return Consumer<Orders>(builder: (_, orders, child) {
                return ListView.builder(
                  itemCount: orders.orders.length,
                  itemBuilder: (ctx, i) => OrderItems(
                    order: orders.orders[i],
                  ),
                );
              });
            }
          }
        },
      ),
    );
  }
}
