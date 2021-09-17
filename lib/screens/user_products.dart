import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/user_product_item.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
   
   static const routeName = '/user-product';

   Future <void> _refreshProducts(BuildContext context) async {
     Provider.of<Products>(context,listen: false).fetchAndsetProducts(true);
   }
  

  @override
  Widget build(BuildContext context) {
    final productsData =Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(icon:Icon(Icons.add),
           onPressed:(){
            Navigator.of(context).pushNamed(EditProductScreen.routeName);

           }
           )
        ],
      ),
      drawer:AppDrawer() ,
      body:FutureBuilder(
        future:_refreshProducts(context) ,
        builder:(ctx,snapshot)=> snapshot.connectionState == ConnectionState.waiting ? 
        Center(
          child:CircularProgressIndicator() ,
        ) : 
        RefreshIndicator(
          onRefresh:()=>_refreshProducts(context) ,
          child:Consumer<Products>(builder: (ctx,productsdata,_,)=> Padding(
            padding: EdgeInsets.all(8),
            child:ListView.builder(
              itemCount:productsData.items.length , 
              itemBuilder:(_,i)=> Column(
                children: [
                  UserProductItem(
                    productsData.items[i].id,
                    productsData.items[i].title,
                    productsData.items[i].imageUrl
                    ),
                  Divider(),
                ],
              )
              )
               ),
        ),
      ),
        
    
  )
      );
  }
}