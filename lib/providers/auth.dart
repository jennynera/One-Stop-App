import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';
import 'package:shop/models/http_exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
class Auth with ChangeNotifier{
  String _token;
   DateTime  _expriydate;
   String _userid;
   Timer _authTimer;
 
  bool get isAuth{
    return token != null;
  }
String get token {
 if (_expriydate != null &&
  _expriydate.isAfter(DateTime.now())&&
 _token != null ){
   return _token;
  
 }
 return null;
}
 String get userId{
   return _userid;
 }

Future<void> _authenticate(String email, String password, String urlSegment)async{
final url ='https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyA1f7iIwX9wqDmePSMy-CTywBddYSl2MY4';
  try{
  final response = await http.post(url,body: json.encode({
  'email':email,
  'password':password,
  'returnSecureToken':true,
  }));
  
  final responsedata = json.decode(response.body);
 if(responsedata['error']!=null){
   throw HttpException(responsedata['error']['message']);
  }
  _token = responsedata['idToken'];
   _userid = responsedata['localId'];
  _expriydate = DateTime.now().add(Duration(seconds: int.parse(responsedata['expiresIn'] )));
   _autoLogout();
   notifyListeners();
   final prefs = await SharedPreferences.getInstance();
   final userData = json.encode(
    { 'token': _token,
     'userid':_userid,
     'expiry':_expriydate.toIso8601String(),}
   );
   prefs.setString('userData',userData);
  } 
   catch(error){
     throw error;}

}

 Future <void> signup(String email,String password) async{
  return _authenticate(email, password,'accounts:signUp') ; 
}

 Future <void> login(String email,String password) async{
  return _authenticate(email, password,'accounts:signInWithPassword') ; 
}

Future<bool> tryAutologout()async {
  final prefs = await SharedPreferences.getInstance();
  if(!prefs.containsKey('userdata')){
    return false;
  }
  final extractedUserData =json.decode( prefs.getString('userData'))as Map <String,Object> ;
  final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
  if(expiryDate.isBefore(DateTime.now())){
    return false;
  }
  _token = extractedUserData['token'];
  _userid = extractedUserData['userid'];
  _expriydate = expiryDate;
  notifyListeners();
  _autoLogout();
  return true;
}

Future <void> logout() async{
  _token=null;
  _userid =null;
  _expriydate=null;
 if (_authTimer!=null){
   _authTimer.cancel();
   _authTimer = null;
 }
  notifyListeners();
  final prefs = await SharedPreferences.getInstance();
 //prefs.remove('userData');
  prefs.clear();
}
void _autoLogout(){
  if(_authTimer != null){
    _authTimer.cancel();
  }
 final timetoexpiry= _expriydate.difference(DateTime.now()).inSeconds;
  _authTimer =Timer(Duration(seconds: timetoexpiry),logout);
}
}






//  or Future <void> signup(String email,String password) async{
//   const url ='https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA1f7iIwX9wqDmePSMy-CTywBddYSl2MY4';

//   final response = await http.post(url,body: json.encode({
//   'email':email,
//   'password':password,
//   'returnSecureToken':true,

// }));

//   print(json.decode(response.body));
// }
// Future <void> login(String email,String password) async{
//   const url ='https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA1f7iIwX9wqDmePSMy-CTywBddYSl2MY4';

//   final response = await http.post(url,body: json.encode({
//   'email':email,
//   'password':password,
//   'returnSecureToken':true,

// }));

// }

