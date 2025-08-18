import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo/stored_value.dart';

void main() {
  group('StoredValue Tests', () {
    test('StoredValue creation and toString', () {
      final item = StoredValue(
        key: 'test_key',
        name: 'Test Item',
        image: 'test.png',
        qty: 2,
        price: 10.99,
      );

      expect(item.key, 'test_key');
      expect(item.name, 'Test Item');
      expect(item.qty, 2);
      expect(item.price, 10.99);
      expect(item.toString(), contains('Test Item'));
    });
  });

  group('Cart Tests', () {
    setUp(() {
      // Clear cart before each test
      Cart.clearCart();
    });

    testWidgets('Add new item to cart', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Container()));

      final item = StoredValue(
        key: 'item1',
        name: 'Test Item',
        image: 'test.png',
        qty: 1,
        price: 10.0,
      );

      Cart.addItem(item, tester.element(find.byType(Container)));

      expect(Cart.items.length, 1);
      expect(Cart.items.first.name, 'Test Item');
      expect(Cart.getTotal(), 10.0);
    });

    testWidgets('Add existing item increases quantity', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Container()));

      final item1 = StoredValue(
        key: 'item1',
        name: 'Test Item',
        image: 'test.png',
        qty: 2,
        price: 10.0,
      );

      final item2 = StoredValue(
        key: 'item2',
        name: 'Test Item', // Same name
        image: 'test.png',
        qty: 3,
        price: 10.0,
      );

      final context = tester.element(find.byType(Container));
      Cart.addItem(item1, context);
      Cart.addItem(item2, context);

      expect(Cart.items.length, 1); // Should still be 1 item
      expect(Cart.items.first.qty, 5); // 2 + 3
      expect(Cart.getTotal(), 50.0); // 5 * 10.0
    });

    testWidgets('Prevent adding more than 10 items', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Container()));

      final item1 = StoredValue(
        key: 'item1',
        name: 'Test Item',
        image: 'test.png',
        qty: 8,
        price: 10.0,
      );

      final item2 = StoredValue(
        key: 'item2',
        name: 'Test Item',
        image: 'test.png',
        qty: 5, // Would exceed 10
        price: 10.0,
      );

      final context = tester.element(find.byType(Container));
      Cart.addItem(item1, context);
      Cart.addItem(item2, context);

      expect(Cart.items.length, 1);
      expect(Cart.items.first.qty, 8); // Should not change
    });

    test('Remove item from cart', () {
      final item = StoredValue(
        key: 'item1',
        name: 'Test Item',
        image: 'test.png',
        qty: 1,
        price: 10.0,
      );

      Cart.items.add(item);
      expect(Cart.items.length, 1);

      Cart.removeItem('item1');
      expect(Cart.items.length, 0);
    });

    test('Clear cart', () {
      final item1 = StoredValue(
        key: 'item1',
        name: 'Test Item 1',
        image: 'test1.png',
        qty: 1,
        price: 10.0,
      );

      final item2 = StoredValue(
        key: 'item2',
        name: 'Test Item 2',
        image: 'test2.png',
        qty: 2,
        price: 15.0,
      );

      Cart.items.addAll([item1, item2]);
      expect(Cart.items.length, 2);

      Cart.clearCart();
      expect(Cart.items.length, 0);
      expect(Cart.getTotal(), 0.0);
    });

    test('Calculate total price correctly', () {
      final item1 = StoredValue(
        key: 'item1',
        name: 'Test Item 1',
        image: 'test1.png',
        qty: 2,
        price: 10.0,
      );

      final item2 = StoredValue(
        key: 'item2',
        name: 'Test Item 2',
        image: 'test2.png',
        qty: 3,
        price: 15.0,
      );

      Cart.items.addAll([item1, item2]);
      
      // (2 * 10.0) + (3 * 15.0) = 20.0 + 45.0 = 65.0
      expect(Cart.getTotal(), 65.0);
    });

    testWidgets('Invalid quantity should not be added', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Container()));

      final item = StoredValue(
        key: 'item1',
        name: 'Test Item',
        image: 'test.png',
        qty: 0, // Invalid quantity
        price: 10.0,
      );

      Cart.addItem(item, tester.element(find.byType(Container)));

      expect(Cart.items.length, 0); // Should not be added
    });
  });
}
