import 'package:demo/models/stored_value.dart';

/// Abstract base class for cart operations that can be undone/redone
abstract class CartCommand {
  void execute();
  void undo();
  String get description;
}

/// Interface for cart operations - to be implemented by the cart
abstract class CartOperations {
  static List<StoredValue> get itemList;
  static set itemList(List<StoredValue> value);
}

/// Command to add an item to the cart
class AddItemCommand extends CartCommand {
  final StoredValue item;
  final List<StoredValue> cartItems;
  bool _wasExecuted = false;
  int? _existingItemIndex;
  int? _previousQty;

  AddItemCommand(this.item, this.cartItems);

  @override
  void execute() {
    _existingItemIndex = cartItems.indexWhere(
      (existingItem) => existingItem.name == item.name,
    );

    if (_existingItemIndex != -1) {
      // Item already exists, update quantity
      _previousQty = cartItems[_existingItemIndex!].qty;
      cartItems[_existingItemIndex!].qty += item.qty;
    } else {
      // New item, add to cart
      cartItems.add(item);
      _existingItemIndex = cartItems.length - 1;
    }
    _wasExecuted = true;
  }

  @override
  void undo() {
    if (!_wasExecuted) return;

    if (_previousQty != null) {
      // Restore previous quantity
      cartItems[_existingItemIndex!].qty = _previousQty!;
    } else {
      // Remove the item that was added
      cartItems.removeAt(_existingItemIndex!);
    }
    _wasExecuted = false;
  }

  @override
  String get description => 'Add ${item.name} (${item.qty})';
}

/// Command to remove an item from the cart
class RemoveItemCommand extends CartCommand {
  final int itemIndex;
  final List<StoredValue> cartItems;
  StoredValue? _removedItem;

  RemoveItemCommand(this.itemIndex, this.cartItems);

  @override
  void execute() {
    if (itemIndex >= 0 && itemIndex < cartItems.length) {
      _removedItem = cartItems.removeAt(itemIndex);
    }
  }

  @override
  void undo() {
    if (_removedItem != null) {
      cartItems.insert(itemIndex, _removedItem!);
    }
  }

  @override
  String get description => 'Remove ${_removedItem?.name ?? 'item'}';
}

/// Command to increment item quantity
class IncrementQtyCommand extends CartCommand {
  final String itemName;
  final List<StoredValue> cartItems;
  bool _wasExecuted = false;

  IncrementQtyCommand(this.itemName, this.cartItems);

  @override
  void execute() {
    final index = cartItems.indexWhere((item) => item.name == itemName);
    if (index != -1 && cartItems[index].qty < 10) {
      cartItems[index].qty++;
      _wasExecuted = true;
    }
  }

  @override
  void undo() {
    if (!_wasExecuted) return;
    
    final index = cartItems.indexWhere((item) => item.name == itemName);
    if (index != -1) {
      if (cartItems[index].qty > 1) {
        cartItems[index].qty--;
      } else {
        cartItems.removeAt(index);
      }
    }
    _wasExecuted = false;
  }

  @override
  String get description => 'Increment $itemName';
}

/// Command to decrement item quantity
class DecrementQtyCommand extends CartCommand {
  final String itemName;
  final List<StoredValue> cartItems;
  bool _wasExecuted = false;
  bool _wasRemoved = false;
  StoredValue? _removedItem;
  int? _removedIndex;

  DecrementQtyCommand(this.itemName, this.cartItems);

  @override
  void execute() {
    final index = cartItems.indexWhere((item) => item.name == itemName);
    if (index != -1) {
      if (cartItems[index].qty > 1) {
        cartItems[index].qty--;
        _wasExecuted = true;
      } else {
        _removedItem = cartItems.removeAt(index);
        _removedIndex = index;
        _wasRemoved = true;
        _wasExecuted = true;
      }
    }
  }

  @override
  void undo() {
    if (!_wasExecuted) return;

    if (_wasRemoved && _removedItem != null && _removedIndex != null) {
      cartItems.insert(_removedIndex!, _removedItem!);
    } else {
      final index = cartItems.indexWhere((item) => item.name == itemName);
      if (index != -1) {
        cartItems[index].qty++;
      }
    }
    _wasExecuted = false;
  }

  @override
  String get description => 'Decrement $itemName';
}

/// Command to clear the entire cart
class ClearCartCommand extends CartCommand {
  final List<StoredValue> cartItems;
  List<StoredValue> _previousItems = [];

  ClearCartCommand(this.cartItems);

  @override
  void execute() {
    _previousItems = List.from(cartItems);
    cartItems.clear();
  }

  @override
  void undo() {
    cartItems.clear();
    cartItems.addAll(_previousItems);
  }

  @override
  String get description => 'Clear cart';
}