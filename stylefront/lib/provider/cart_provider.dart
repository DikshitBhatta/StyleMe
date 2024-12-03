import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier{
  final List<Map<String,dynamic>> _cartItems = [];
  List <Map<String,dynamic>> get cartItem => _cartItems;
  void addToCart(Map<String,dynamic> product){
    final existingItemIndex = _cartItems.indexWhere((item)=>item['id']==product['id']);
    if(existingItemIndex!=-1){
      _cartItems[existingItemIndex]['quantity'] +=1;
    }
    else{
    _cartItems.add({...product,'quantity':1,'isSelected':false});}
    notifyListeners();
  }

  void removeFromCart (int index){
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void toggleSelection(int index){
    _cartItems[index]['isSelected']=!_cartItems[index]['isSelected'];
    notifyListeners();
  }

  List<Map<String, dynamic>> get selectedItems{
    return _cartItems.where((item)=>item['isSelected']).toList();
  }

  void clearCart(){
    _cartItems.clear();
    notifyListeners();
  }

}