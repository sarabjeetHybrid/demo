import 'package:demo/main.dart';
import 'package:demo/modal_helper.dart';
import 'package:demo/cart_command.dart';
import 'package:demo/cart_history.dart';
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
  static final CartHistory _history = CartHistory();

  /// Add item to cart using command pattern
  static void addItem(StoredValue item, BuildContext context) {
    // Check limits before creating command
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
        return;
      }
    } else {
      // New item
      if (item.qty > 10) {
        return;
      }
    }

    // Execute command through history
    final command = AddItemCommand(item);
    _history.executeCommand(command);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart!'),
      ),
    );
  }

  /// Remove item by index using command pattern
  static void removeItemAt(int index) {
    if (index >= 0 && index < itemList.length) {
      final command = RemoveItemCommand(index);
      _history.executeCommand(command);
    }
  }

  /// Legacy method for compatibility
  static void removeItem(String key) {
    final index = itemList.indexWhere((item) => item.key == key);
    if (index != -1) {
      removeItemAt(index);
    }
  }

  /// Increment quantity using command pattern
  static void incrementQty(String itemName) {
    final command = IncrementQtyCommand(itemName);
    _history.executeCommand(command);
  }

  /// Decrement quantity using command pattern
  static void decrementQty(String itemName) {
    final command = DecrementQtyCommand(itemName);
    _history.executeCommand(command);
  }

  /// Clear cart using command pattern
  static void clearCart() {
    final command = ClearCartCommand();
    _history.executeCommand(command);
  }

  /// Undo last operation
  static bool undo() {
    return _history.undo();
  }

  /// Redo last undone operation
  static bool redo() {
    return _history.redo();
  }

  /// Check if undo is available
  static bool get canUndo => _history.canUndo;

  /// Check if redo is available
  static bool get canRedo => _history.canRedo;

  /// Get undo description
  static String? get undoDescription => _history.lastUndoDescription;

  /// Get redo description
  static String? get redoDescription => _history.lastRedoDescription;

  /// Clear history
  static void clearHistory() {
    _history.clearHistory();
  }

  static double getTotal() {
    return itemList.fold(0.0, (sum, item) => sum + (item.price * item.qty));
  }

  @override
  String toString() {
    return 'Cart{items: $itemList}';
  }
}
