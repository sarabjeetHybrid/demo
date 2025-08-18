import 'package:demo/static_variable.dart';
import 'package:flutter/material.dart';

class StoredValue{
   String key;
   String name;
  
   String image;
   int qty;
   double price;

  StoredValue({required this.key, required this.name, required this.image, required this.qty, required this.price});

  @override
  String toString() {
    return 'StoredValue{key: $key, name: $name, image: $image, qty: $qty, price: $price}';
  }
}
 class Cart {




  static void addItem(StoredValue item, BuildContext context) {
    if (StaticVariable.itemList.any((existingItem) => existingItem.name == item.name) ) {
      // If the item already exists, you might want to update the quantity instead
      final index = StaticVariable.itemList.indexWhere((existingItem) => existingItem.name == item.name);
      if (StaticVariable.itemList[index].qty > 10) {
        // Prevent adding more than 10 of the same item
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Limit Reached"),
              content: Text("Cannot add more than 10 of the same item"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
      StaticVariable.itemList[index] = StoredValue(
        key: item.key,
        name: item.name,
        image: item.image,
        qty: StaticVariable.itemList[index].qty + item.qty, // Update quantity
        price: item.price,
      );
      return;
    }
    StaticVariable.itemList.add(item);
     
  }
  
  // static void removeItem(String key) {
  //   StaticVariable.itemList.removeWhere((item) => item.key == key);
  // }

  @override
  String toString() {
    // TODO: implement toString
    return 'Cart{items: $StaticVariable.itemList}';
  }
  }