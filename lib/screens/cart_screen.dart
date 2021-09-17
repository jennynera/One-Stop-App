import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import '../widgets/cartitems.dart';
import '../providers/orders.dart';
class CartScreen extends StatefulWidget {
 static const  routename ='/cartscreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    var _isLoading = false;
    final cart = Provider.of<Cart>(context) ;
    
    return Scaffold(
      appBar: AppBar(
        title:Text('Your Cart'),
        ),
      body:Column(children: [
        Card(
          margin: EdgeInsets.all(15),
        child:Padding(
          padding: EdgeInsets.all(8),
          child:Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
              style: TextStyle(fontSize: 20),
              ),

              Spacer(),
              Chip(label: Text('₹  ${cart.totalAmount.toStringAsFixed(2)}', 
              style:TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).accentColor,
              ),
             TextButton(child:_isLoading ? CircularProgressIndicator(): 
             Text('Order Now'),

             onPressed:cart.totalAmount <=0 ? null : () async{
               setState(() {
                 _isLoading = true;
                              });
              await  Provider.of<Orders>(context,listen: false).addOrder(
                 cart.items.values.toList(),
                 cart.totalAmount
                 );
                 setState(() {
                 _isLoading = false;
                              });

                 cart.clear();

             },
             )
              ],
            ),
          ) ,
          ),
          SizedBox(height: 15,),
          Expanded(child:ListView.builder(
            itemCount: cart.items.length,
            itemBuilder:(ctx,i)=> CartItems(
              cart.items.values.toList()[i].id,
              cart.items.keys.toList()[i],
              cart.items.values.toList()[i].price,
              cart.items.values.toList()[i].quantity,
              cart.items.values.toList()[i].title
    
              
              ),
            )
            )

      ],)



    );
  }
}