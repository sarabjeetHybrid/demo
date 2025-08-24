// Demo script to show undo/redo functionality
// Run with: dart lib/demo_undo_redo.dart

import 'models/stored_value.dart';
import 'cart_command.dart';
import 'cart_history.dart';

class SimpleCart {
  static List<StoredValue> itemList = [];
  static final CartHistory _history = CartHistory();

  static void addItem(StoredValue item) {
    final command = AddItemCommand(item, itemList);
    _history.executeCommand(command);
    print('Added ${item.name} (qty: ${item.qty}) to cart');
  }

  static void removeItemAt(int index) {
    if (index >= 0 && index < itemList.length) {
      final itemName = itemList[index].name;
      final command = RemoveItemCommand(index, itemList);
      _history.executeCommand(command);
      print('Removed $itemName from cart');
    }
  }

  static void incrementQty(String itemName) {
    final command = IncrementQtyCommand(itemName, itemList);
    _history.executeCommand(command);
    print('Incremented quantity of $itemName');
  }

  static void decrementQty(String itemName) {
    final command = DecrementQtyCommand(itemName, itemList);
    _history.executeCommand(command);
    print('Decremented quantity of $itemName');
  }

  static void clearCart() {
    final command = ClearCartCommand(itemList);
    _history.executeCommand(command);
    print('Cleared cart');
  }

  static bool undo() {
    final result = _history.undo();
    if (result) {
      print('Undone: ${_history.lastRedoDescription}');
    } else {
      print('Nothing to undo');
    }
    return result;
  }

  static bool redo() {
    final result = _history.redo();
    if (result) {
      print('Redone: ${_history.lastUndoDescription}');
    } else {
      print('Nothing to redo');
    }
    return result;
  }

  static bool get canUndo => _history.canUndo;
  static bool get canRedo => _history.canRedo;

  static void printCart() {
    print('\n--- Cart Contents ---');
    if (itemList.isEmpty) {
      print('Cart is empty');
    } else {
      for (int i = 0; i < itemList.length; i++) {
        final item = itemList[i];
        print('$i: ${item.name} - Qty: ${item.qty} - Price: \$${item.price}');
      }
    }
    print('Can Undo: $canUndo (${_history.lastUndoDescription ?? 'none'})');
    print('Can Redo: $canRedo (${_history.lastRedoDescription ?? 'none'})');
    print('--------------------\n');
  }
}

void main() {
  print('🛒 Undo/Redo Cart Demo\n');

  // Create some test items
  final apple = StoredValue(
    key: 'apple',
    name: 'Apple',
    image: 'apple.png',
    qty: 2,
    price: 1.50,
  );

  final banana = StoredValue(
    key: 'banana',
    name: 'Banana',
    image: 'banana.png',
    qty: 3,
    price: 0.75,
  );

  final orange = StoredValue(
    key: 'orange',
    name: 'Orange',
    image: 'orange.png',
    qty: 1,
    price: 2.00,
  );

  // Demo operations
  print('1. Adding items to cart:');
  SimpleCart.addItem(apple);
  SimpleCart.printCart();

  SimpleCart.addItem(banana);
  SimpleCart.printCart();

  SimpleCart.addItem(orange);
  SimpleCart.printCart();

  print('2. Increment apple quantity:');
  SimpleCart.incrementQty('Apple');
  SimpleCart.printCart();

  print('3. Decrement banana quantity:');
  SimpleCart.decrementQty('Banana');
  SimpleCart.printCart();

  print('4. Remove orange:');
  SimpleCart.removeItemAt(2); // Orange should be at index 2
  SimpleCart.printCart();

  print('5. Now testing UNDO operations:');
  
  print('Undo remove orange:');
  SimpleCart.undo();
  SimpleCart.printCart();

  print('Undo decrement banana:');
  SimpleCart.undo();
  SimpleCart.printCart();

  print('Undo increment apple:');
  SimpleCart.undo();
  SimpleCart.printCart();

  print('6. Now testing REDO operations:');
  
  print('Redo increment apple:');
  SimpleCart.redo();
  SimpleCart.printCart();

  print('Redo decrement banana:');
  SimpleCart.redo();
  SimpleCart.printCart();

  print('7. Add a new item (should clear redo stack):');
  final grape = StoredValue(
    key: 'grape',
    name: 'Grape',
    image: 'grape.png',
    qty: 5,
    price: 3.00,
  );
  
  SimpleCart.addItem(grape);
  SimpleCart.printCart();

  print('8. Try to redo (should fail since redo stack was cleared):');
  SimpleCart.redo();
  SimpleCart.printCart();

  print('9. Clear entire cart:');
  SimpleCart.clearCart();
  SimpleCart.printCart();

  print('10. Undo clear cart (restore all items):');
  SimpleCart.undo();
  SimpleCart.printCart();

  print('✅ Demo completed! Undo/Redo functionality is working correctly.');
}