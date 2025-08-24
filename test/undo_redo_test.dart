import 'package:flutter_test/flutter_test.dart';
import 'package:demo/models/stored_value.dart';
import 'package:demo/stored_value.dart';
import 'package:demo/cart_command.dart';
import 'package:demo/cart_history.dart';

void main() {
  group('Cart Undo/Redo Functionality', () {
    setUp(() {
      // Clear cart and history before each test
      Cart.itemList.clear();
      Cart.clearHistory();
    });

    test('should add item and allow undo', () {
      final item = StoredValue(
        key: 'test',
        name: 'Test Item',
        image: 'test.png',
        qty: 2,
        price: 10.0,
      );

      // Add item using command
      final command = AddItemCommand(item, Cart.itemList);
      CartHistory().executeCommand(command);

      expect(Cart.itemList.length, 1);
      expect(Cart.itemList[0].qty, 2);
      expect(Cart.canUndo, true);

      // Undo the operation
      Cart.undo();

      expect(Cart.itemList.length, 0);
      expect(Cart.canUndo, false);
      expect(Cart.canRedo, true);
    });

    test('should redo after undo', () {
      final item = StoredValue(
        key: 'test',
        name: 'Test Item',
        image: 'test.png',
        qty: 1,
        price: 5.0,
      );

      final command = AddItemCommand(item, Cart.itemList);
      CartHistory().executeCommand(command);

      // Undo then redo
      Cart.undo();
      expect(Cart.itemList.length, 0);

      Cart.redo();
      expect(Cart.itemList.length, 1);
      expect(Cart.itemList[0].name, 'Test Item');
    });

    test('should handle increment/decrement with undo/redo', () {
      final item = StoredValue(
        key: 'test',
        name: 'Test Item',
        image: 'test.png',
        qty: 1,
        price: 5.0,
      );

      // Add item
      CartHistory().executeCommand(AddItemCommand(item, Cart.itemList));
      expect(Cart.itemList[0].qty, 1);

      // Increment quantity
      CartHistory().executeCommand(IncrementQtyCommand('Test Item', Cart.itemList));
      expect(Cart.itemList[0].qty, 2);

      // Undo increment
      Cart.undo();
      expect(Cart.itemList[0].qty, 1);

      // Redo increment
      Cart.redo();
      expect(Cart.itemList[0].qty, 2);

      // Decrement quantity
      CartHistory().executeCommand(DecrementQtyCommand('Test Item', Cart.itemList));
      expect(Cart.itemList[0].qty, 1);

      // Undo decrement
      Cart.undo();
      expect(Cart.itemList[0].qty, 2);
    });

    test('should handle remove item with undo/redo', () {
      final item = StoredValue(
        key: 'test',
        name: 'Test Item',
        image: 'test.png',
        qty: 1,
        price: 5.0,
      );

      // Add item
      CartHistory().executeCommand(AddItemCommand(item, Cart.itemList));
      expect(Cart.itemList.length, 1);

      // Remove item
      CartHistory().executeCommand(RemoveItemCommand(0, Cart.itemList));
      expect(Cart.itemList.length, 0);

      // Undo remove
      Cart.undo();
      expect(Cart.itemList.length, 1);
      expect(Cart.itemList[0].name, 'Test Item');

      // Redo remove
      Cart.redo();
      expect(Cart.itemList.length, 0);
    });

    test('should handle clear cart with undo/redo', () {
      final items = [
        StoredValue(key: 'test1', name: 'Item 1', image: 'test1.png', qty: 1, price: 5.0),
        StoredValue(key: 'test2', name: 'Item 2', image: 'test2.png', qty: 2, price: 10.0),
      ];

      // Add items
      for (var item in items) {
        CartHistory().executeCommand(AddItemCommand(item, Cart.itemList));
      }
      expect(Cart.itemList.length, 2);

      // Clear cart
      CartHistory().executeCommand(ClearCartCommand(Cart.itemList));
      expect(Cart.itemList.length, 0);

      // Undo clear
      Cart.undo();
      expect(Cart.itemList.length, 2);
      expect(Cart.itemList[0].name, 'Item 1');
      expect(Cart.itemList[1].name, 'Item 2');

      // Redo clear
      Cart.redo();
      expect(Cart.itemList.length, 0);
    });

    test('should clear redo stack when new command is executed', () {
      final item = StoredValue(
        key: 'test',
        name: 'Test Item',
        image: 'test.png',
        qty: 1,
        price: 5.0,
      );

      // Add item and undo
      CartHistory().executeCommand(AddItemCommand(item, Cart.itemList));
      Cart.undo();
      expect(Cart.canRedo, true);

      // Execute new command should clear redo stack
      final newItem = StoredValue(
        key: 'test2',
        name: 'New Item',
        image: 'test2.png',
        qty: 1,
        price: 8.0,
      );
      CartHistory().executeCommand(AddItemCommand(newItem, Cart.itemList));
      expect(Cart.canRedo, false);
    });

    test('should provide correct descriptions for undo/redo', () {
      final item = StoredValue(
        key: 'test',
        name: 'Test Item',
        image: 'test.png',
        qty: 2,
        price: 5.0,
      );

      CartHistory().executeCommand(AddItemCommand(item, Cart.itemList));
      expect(Cart.undoDescription, 'Add Test Item (2)');

      Cart.undo();
      expect(Cart.redoDescription, 'Add Test Item (2)');
    });

    test('should handle decrement that removes item', () {
      final item = StoredValue(
        key: 'test',
        name: 'Test Item',
        image: 'test.png',
        qty: 1,
        price: 5.0,
      );

      // Add item with qty 1
      CartHistory().executeCommand(AddItemCommand(item, Cart.itemList));
      expect(Cart.itemList.length, 1);
      expect(Cart.itemList[0].qty, 1);

      // Decrement should remove the item
      CartHistory().executeCommand(DecrementQtyCommand('Test Item', Cart.itemList));
      expect(Cart.itemList.length, 0);

      // Undo should restore the item
      Cart.undo();
      expect(Cart.itemList.length, 1);
      expect(Cart.itemList[0].qty, 1);
      expect(Cart.itemList[0].name, 'Test Item');
    });
  });
}