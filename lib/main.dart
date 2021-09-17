import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash.dart';
import 'providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
         ChangeNotifierProvider(
           create:(ctx)=>Auth() 
           ),
        ChangeNotifierProxyProvider<Auth,Products>( 
         update: (ctx,auth,previousProducts) =>
          Products(
            auth.token,
            auth.userId,
          previousProducts==null?[]: previousProducts.items), 
         //create: (BuildContext context) { Products(); },
        ),
        ChangeNotifierProvider(
           create:(ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth,Orders>(
          //create:(ctx)=> Orders() , 
          update: (ctx,auth,previousorders)=>Orders(auth.token,
          auth.userId,previousorders==null?[]: previousorders.orders))
      ],
      child: Consumer<Auth>(builder: (ctx,auth,_,)=> MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.purple.shade400
           // fontFamily: 'Lato',
          ),
          home: auth.isAuth 
          ? ProductsOverviewScreen()
          : FutureBuilder(
            future: auth.tryAutologout(),
            builder: (ctx,authResultSnapshot)=>
            authResultSnapshot.connectionState==
            ConnectionState.waiting
             ? SplashScreen() 
             :  AuthScreen(),),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routename:(ctx)=>CartScreen(),
            OrdersScreen.routeName:(ctx) => OrdersScreen(),
            UserProductsScreen.routeName:(ctx)=>UserProductsScreen(),
            EditProductScreen.routeName:(ctx)=>EditProductScreen(),
          }),
)    );
    
  }
}

