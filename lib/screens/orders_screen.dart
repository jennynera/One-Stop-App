
//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_items.dart';

class OrdersScreen extends StatefulWidget {
 static const routeName = '/orders' ;

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isloading = false;

@override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
              _isloading = true;
            });
    
    await Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
      setState(() {
              _isloading= false;
            });
    });
    super.initState();

  }


//  @override
//    void didChangeDependencies() {
//      Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
//      super.didChangeDependencies();
//    }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
       title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: _isloading ? Center(child: CircularProgressIndicator(),)
      :
      
      ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder:(ctx, i)
        =>OrderItems(orderData.orders[i]) )
      
    );
  }
}