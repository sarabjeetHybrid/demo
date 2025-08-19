import 'package:demo/stored_value.dart';

/// Abstract base class for cart operations that can be undone/redone
abstract class CartCommand {
  void execute();
  void undo();
  String get description;
}

/// Command to add an item to the cart
class AddItemCommand extends CartCommand {
  final StoredValue item;
  bool _wasExecuted = false;
  int? _existingItemIndex;
  int? _previousQty;

  AddItemCommand(this.item);

  @override
  void execute() {
    _existingItemIndex = Cart.itemList.indexWhere(
      (existingItem) => existingItem.name == item.name,
    );

    if (_existingItemIndex != -1) {
      // Item already exists, update quantity
      _previousQty = Cart.itemList[_existingItemIndex!].qty;
      Cart.itemList[_existingItemIndex!].qty += item.qty;
    } else {
      // New item, add to cart
      Cart.itemList.add(item);
      _existingItemIndex = Cart.itemList.length - 1;
    }
    _wasExecuted = true;
  }

  @override
  void undo() {
    if (!_wasExecuted) return;

    if (_previousQty != null) {
      // Restore previous quantity
      Cart.itemList[_existingItemIndex!].qty = _previousQty!;
    } else {
      // Remove the item that was added
      Cart.itemList.removeAt(_existingItemIndex!);
    }
    _wasExecuted = false;
  }

  @override
  String get description => 'Add ${item.name} (${item.qty})';
}

/// Command to remove an item from the cart
class RemoveItemCommand extends CartCommand {
  final int itemIndex;
  StoredValue? _removedItem;

  RemoveItemCommand(this.itemIndex);

  @override
  void execute() {
    if (itemIndex >= 0 && itemIndex < Cart.itemList.length) {
      _removedItem = Cart.itemList.removeAt(itemIndex);
    }
  }

  @override
  void undo() {
    if (_removedItem != null) {
      Cart.itemList.insert(itemIndex, _removedItem!);
    }
  }

  @override
  String get description => 'Remove ${_removedItem?.name ?? 'item'}';
}

/// Command to increment item quantity
class IncrementQtyCommand extends CartCommand {
  final String itemName;
  bool _wasExecuted = false;

  IncrementQtyCommand(this.itemName);

  @override
  void execute() {
    final index = Cart.itemList.indexWhere((item) => item.name == itemName);
    if (index != -1 && Cart.itemList[index].qty < 10) {
      Cart.itemList[index].qty++;
      _wasExecuted = true;
    }
  }

  @override
  void undo() {
    if (!_wasExecuted) return;
    
    final index = Cart.itemList.indexWhere((item) => item.name == itemName);
    if (index != -1) {
      if (Cart.itemList[index].qty > 1) {
        Cart.itemList[index].qty--;
      } else {
        Cart.itemList.removeAt(index);
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
  bool _wasExecuted = false;
  bool _wasRemoved = false;
  StoredValue? _removedItem;
  int? _removedIndex;

  DecrementQtyCommand(this.itemName);

  @override
  void execute() {
    final index = Cart.itemList.indexWhere((item) => item.name == itemName);
    if (index != -1) {
      if (Cart.itemList[index].qty > 1) {
        Cart.itemList[index].qty--;
        _wasExecuted = true;
      } else {
        _removedItem = Cart.itemList.removeAt(index);
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
      Cart.itemList.insert(_removedIndex!, _removedItem!);
    } else {
      final index = Cart.itemList.indexWhere((item) => item.name == itemName);
      if (index != -1) {
        Cart.itemList[index].qty++;
      }
    }
    _wasExecuted = false;
  }

  @override
  String get description => 'Decrement $itemName';
}

/// Command to clear the entire cart
class ClearCartCommand extends CartCommand {
  List<StoredValue> _previousItems = [];

  @override
  void execute() {
    _previousItems = List.from(Cart.itemList);
    Cart.itemList.clear();
  }

  @override
  void undo() {
    Cart.itemList.clear();
    Cart.itemList.addAll(_previousItems);
  }

  @override
  String get description => 'Clear cart';
}