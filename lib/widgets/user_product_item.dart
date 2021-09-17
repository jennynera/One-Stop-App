import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class UserProductItem  extends StatelessWidget {
  final String id;
 final String title;
 final String imgurl;

 UserProductItem(this.id,this.title,this.imgurl);

  @override
  Widget build(BuildContext context) {
    
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgurl,
        ),
       ),
       trailing: Container(
         width: 100,
         child: Row(
           children: [
             IconButton(
               icon:Icon(Icons.edit),
              onPressed: (){
                Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
              }
              ),
               IconButton(
               icon:Icon(Icons.delete),
              onPressed: (){
                Provider.of<Products>(context, listen: false).deleteProduct(id);
              }
              )
           ],
           ),
       ),

     );
  }
}