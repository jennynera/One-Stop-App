import 'package:flutter/foundation.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem{

final String id;
final double amount;
final List<CartItem>products;
final DateTime dateTime ;

OrderItem({

@required this .id,
@required this .amount,
@required this . products,
@required this .dateTime,

});
}

class Orders with ChangeNotifier{
   List<OrderItem>_orders=[];
  final  String authtoken;
  final String userId;
   Orders(this.authtoken, this.userId,this._orders);


List<OrderItem>get orders{
   return[..._orders];
}

Future <void> fetchAndSetOrders() async{
final url = 'https://shopapp-2cba2-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authtoken';
  final response = await http.get(url);
  //print(json.decode(response.body));
    final List<OrderItem> loadedOrders =[];
    final extractedData = json.decode(response.body)as Map<String,dynamic>;
    if (extractedData == null ){
      return;
    }
    extractedData.forEach((ordId, ordData) { 
      loadedOrders.add(OrderItem(
        id: ordId, 
        amount:ordData['amount'],
         dateTime:DateTime.parse (ordData['dateTime'],),
         products: (ordData['products'] as List<dynamic>).map((item)=>
         CartItem(
           id:item['id'],
           price:item['price'],
           quantity: item['quantity'],
           title: item['title']
         )).toList(),
         ));
    });

    _orders = loadedOrders .reversed.toList();
    notifyListeners();
}
 
 Future <void> addOrder(List<CartItem>cartproducts,double total) async {
   final url = 'https://shopapp-2cba2-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authtoken';
   final timestamp = DateTime.now();
  final  response = await http.post(url,body: json.encode({
    'amount': total,
    'dateTime':timestamp.toIso8601String(),
    'products': cartproducts.map(
      (cp)=>{
        'id':cp.id,
        'title':cp.title,
        'quantity':cp.quantity,
        'price':cp.price
      }
    ).toList(),




   }));

   _orders.insert(
     0,
     OrderItem(
       id: json.decode(response.body)['name'],
       amount: total,
       dateTime: timestamp,
       products: cartproducts
     )
     );
    notifyListeners();
 }

 

} 