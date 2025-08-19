import 'package:demo/main.dart';
import 'package:demo/modal_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StoredValue {
  String key;
  String name;
  String image;
  int qty;
  double price;

  StoredValue({
    required this.key,
    required this.name,
    required this.image,
    required this.qty,
    required this.price,
  });

  @override
  String toString() {
    return 'StoredValue{key: $key, name: $name, image: $image, qty: $qty, price: $price}';
  }
}

class Cart {
  static List<StoredValue> itemList = [];

  /// Add item to cart
  static void addItem(StoredValue item, BuildContext context) {
    final index = itemList.indexWhere(
      (existingItem) => existingItem.name == item.name,
    );

    if (index != -1) {
      // Item already exists
      int currentQty = itemList[index].qty;
      int newQty = currentQty + item.qty;

      if (newQty > 10) {
        // show modal and stop
        int remaining = 10 - currentQty;

         ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You can only add up to 10 items of this type. You can add $remaining more.'),
        ),
      );
        // Fluttertoast.showToast(
        //   msg: 'You can only add up to 10 items of this type. You can add $remaining more.',
        //   toastLength: Toast.LENGTH_LONG,
        //   gravity: ToastGravity.BOTTOM,
        // );
        // ModalHelper.askForInput(
        //   'Limit Reached',
        //   'You can only add up to 10 items of this type.',
        //   'OK',
        //   'Cancel',
        //   true,
        // );
      
        return;
      }

      // ✅ Update quantity
      itemList[index].qty = newQty;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.name} added to cart!'),
          ),
        );

    } else {
      // New item
      if (item.qty > 10) {
        // Directly blocked
        // ModalHelper.showLimitDialog(
        //   context: context,
        //   currentQty: 0,
        //   remaining: 10,
        // );
        return;
      }

      itemList.add(item); // ✅ add new item


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.name} added to cart!'),
          ),
        );
      }

  }

  static void removeItem(String key) {
    itemList.removeWhere((item) => item.key == key);
  }

  static void clearCart() {
    itemList.clear();
  }

  static double getTotal() {
    return itemList.fold(0.0, (sum, item) => sum + (item.price * item.qty));
  }

  @override
  String toString() {
    return 'Cart{items: $itemList}';
  }
}
