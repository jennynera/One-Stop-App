import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItems extends StatefulWidget {
  final OrderItem order; //ye orders providers wala file ko refer kar raha hai

  OrderItems(this.order);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:EdgeInsets.all(10) ,
      child: Column(children: [
        ListTile(
          title: Text('₹ ${widget.order.amount}'),
          subtitle:Text(
          
            DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),

            ),
            trailing: IconButton(
              icon:Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: (){
                setState(() {
                    _expanded = !_expanded;             
                                });
              } ,
              ),
            ) ,
            if(_expanded)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal:15,
                vertical: 4 ),
               height: min(widget.order.products.length * 20.0 + 10,180),
            child:ListView(
              children:widget.order.products.map((e) => 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(e.title,style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  )
                  ),
                  Text('${e.quantity}x ₹ ${e.price}',
                  style: TextStyle(
                    fontSize: 18,
                    color:Colors.grey,


                  ),)
              ],
            )).toList(),
            ),),
        
      ],),
      
    );
  }
}