import 'package:flutter_test/flutter_test.dart';
import 'package:demo/models/stored_value.dart';
import 'package:demo/stored_value.dart';
import 'package:demo/cart_command.dart';
import 'package:demo/cart_history.dart';

void main() {
  group('Complete Undo/Redo Integration Tests', () {
    setUp(() {
      // Clear cart and history before each test
      Cart.itemList.clear();
      Cart.clearHistory();
    });

    test('full workflow with undo/redo operations', () {
      // Test items
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

      // Step 1: Add items using static methods
      Cart.itemList.clear();
      Cart.clearHistory();
      
      final addAppleCmd = AddItemCommand(apple, Cart.itemList);
      CartHistory().executeCommand(addAppleCmd);
      expect(Cart.itemList.length, 1);
      expect(Cart.itemList[0].name, 'Apple');
      expect(Cart.itemList[0].qty, 2);

      final addBananaCmd = AddItemCommand(banana, Cart.itemList);
      CartHistory().executeCommand(addBananaCmd);
      expect(Cart.itemList.length, 2);

      // Step 2: Increment apple quantity
      final incrementCmd = IncrementQtyCommand('Apple', Cart.itemList);
      CartHistory().executeCommand(incrementCmd);
      expect(Cart.itemList[0].qty, 3);

      // Step 3: Decrement banana quantity
      final decrementCmd = DecrementQtyCommand('Banana', Cart.itemList);
      CartHistory().executeCommand(decrementCmd);
      expect(Cart.itemList[1].qty, 2);

      // Step 4: Remove apple
      final removeCmd = RemoveItemCommand(0, Cart.itemList);
      CartHistory().executeCommand(removeCmd);
      expect(Cart.itemList.length, 1);
      expect(Cart.itemList[0].name, 'Banana');

      // Step 5: Verify we can undo all operations
      expect(Cart.canUndo, true);
      expect(Cart.undoDescription, 'Remove Apple');

      // Undo remove apple
      Cart.undo();
      expect(Cart.itemList.length, 2);
      expect(Cart.itemList[0].name, 'Apple');
      expect(Cart.itemList[0].qty, 3);

      // Undo decrement banana
      Cart.undo();
      expect(Cart.itemList[1].qty, 3);

      // Undo increment apple
      Cart.undo();
      expect(Cart.itemList[0].qty, 2);

      // Undo add banana
      Cart.undo();
      expect(Cart.itemList.length, 1);
      expect(Cart.itemList[0].name, 'Apple');

      // Undo add apple
      Cart.undo();
      expect(Cart.itemList.length, 0);
      expect(Cart.canUndo, false);

      // Step 6: Test redo functionality
      expect(Cart.canRedo, true);
      expect(Cart.redoDescription, 'Add Apple (2)');

      // Redo all operations
      Cart.redo(); // Add apple
      expect(Cart.itemList.length, 1);
      expect(Cart.itemList[0].name, 'Apple');

      Cart.redo(); // Add banana
      expect(Cart.itemList.length, 2);

      Cart.redo(); // Increment apple
      expect(Cart.itemList[0].qty, 3);

      Cart.redo(); // Decrement banana
      expect(Cart.itemList[1].qty, 2);

      Cart.redo(); // Remove apple
      expect(Cart.itemList.length, 1);
      expect(Cart.itemList[0].name, 'Banana');
      expect(Cart.canRedo, false);
    });

    test('test cart methods directly', () {
      // Use Cart static methods for more realistic testing
      final orange = StoredValue(
        key: 'orange',
        name: 'Orange',
        image: 'orange.png',
        qty: 1,
        price: 2.00,
      );

      // Add item directly using Cart method
      Cart.itemList.add(orange); // Simulate the operation without context
      
      // Now test increment using Cart method
      Cart.incrementQty('Orange');
      expect(Cart.itemList[0].qty, 2);
      expect(Cart.canUndo, true);

      // Test decrement
      Cart.decrementQty('Orange');
      expect(Cart.itemList[0].qty, 1);

      // Test decrement to zero (should remove item)
      Cart.decrementQty('Orange');
      expect(Cart.itemList.length, 0);

      // Undo decrement (should restore item)
      Cart.undo();
      expect(Cart.itemList.length, 1);
      expect(Cart.itemList[0].qty, 1);
      expect(Cart.itemList[0].name, 'Orange');

      // Test remove by index
      Cart.removeItemAt(0);
      expect(Cart.itemList.length, 0);

      // Undo remove
      Cart.undo();
      expect(Cart.itemList.length, 1);
      expect(Cart.itemList[0].name, 'Orange');
    });

    test('test clear cart functionality', () {
      // Add multiple items
      final items = [
        StoredValue(key: '1', name: 'Item1', image: '1.png', qty: 1, price: 5.0),
        StoredValue(key: '2', name: 'Item2', image: '2.png', qty: 2, price: 10.0),
        StoredValue(key: '3', name: 'Item3', image: '3.png', qty: 3, price: 15.0),
      ];

      for (var item in items) {
        Cart.itemList.add(item);
      }
      expect(Cart.itemList.length, 3);

      // Clear cart
      Cart.clearCart();
      expect(Cart.itemList.length, 0);
      expect(Cart.canUndo, true);

      // Undo clear
      Cart.undo();
      expect(Cart.itemList.length, 3);
      expect(Cart.itemList[0].name, 'Item1');
      expect(Cart.itemList[1].name, 'Item2');
      expect(Cart.itemList[2].name, 'Item3');

      // Verify quantities were restored correctly
      expect(Cart.itemList[0].qty, 1);
      expect(Cart.itemList[1].qty, 2);
      expect(Cart.itemList[2].qty, 3);
    });

    test('test history limit and description functionality', () {
      final item = StoredValue(
        key: 'test',
        name: 'Test Item',
        image: 'test.png',
        qty: 1,
        price: 1.0,
      );

      // Add item
      Cart.itemList.add(item);

      // Perform multiple operations to test history descriptions
      Cart.incrementQty('Test Item');
      expect(Cart.undoDescription, 'Increment Test Item');

      Cart.incrementQty('Test Item');
      expect(Cart.undoDescription, 'Increment Test Item');

      Cart.decrementQty('Test Item');
      expect(Cart.undoDescription, 'Decrement Test Item');

      // Test undo descriptions
      Cart.undo(); // Undo decrement
      expect(Cart.redoDescription, 'Decrement Test Item');

      Cart.undo(); // Undo increment
      expect(Cart.redoDescription, 'Increment Test Item');

      // Test redo descriptions
      Cart.redo(); // Redo increment
      expect(Cart.undoDescription, 'Increment Test Item');
    });

    test('verify commands work with existing quantity limits', () {
      final item = StoredValue(
        key: 'limited',
        name: 'Limited Item',
        image: 'limited.png',
        qty: 9, // Close to limit
        price: 1.0,
      );

      Cart.itemList.add(item);

      // Increment should work (qty becomes 10)
      Cart.incrementQty('Limited Item');
      expect(Cart.itemList[0].qty, 10);

      // Another increment should not work due to limit
      Cart.incrementQty('Limited Item');
      expect(Cart.itemList[0].qty, 10); // Should stay at 10

      // But we should still be able to undo the first increment
      Cart.undo();
      expect(Cart.itemList[0].qty, 9);
    });
  });
}