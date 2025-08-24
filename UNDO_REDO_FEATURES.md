# Undo/Redo Cart Functionality

This implementation adds comprehensive undo/redo functionality to the Flutter cart application using the Command Pattern.

## Architecture Overview

### Command Pattern Implementation

The undo/redo functionality is built using the Command Pattern with the following components:

1. **CartCommand** - Abstract base class defining the interface for all cart operations
2. **Concrete Commands** - Specific implementations for each type of cart operation
3. **CartHistory** - Manages the undo/redo stacks and command execution
4. **Cart Class** - Updated to use commands for all operations

### Components

#### 1. Cart Commands (`lib/cart_command.dart`)

- **AddItemCommand**: Handles adding items to cart with quantity updates
- **RemoveItemCommand**: Handles item removal with ability to restore
- **IncrementQtyCommand**: Handles quantity increments with 10-item limit
- **DecrementQtyCommand**: Handles quantity decrements (removes item when qty=0)
- **ClearCartCommand**: Handles clearing entire cart with full restoration

#### 2. Cart History (`lib/cart_history.dart`)

- Singleton pattern for managing operation history
- Maintains separate undo and redo stacks
- Limits history to 50 operations to prevent memory issues
- Automatically clears redo stack when new operations are performed
- Provides operation descriptions for UI feedback

#### 3. Updated Cart Class (`lib/stored_value.dart`)

- All cart operations now use command pattern
- Public methods for undo/redo operations
- Maintains backward compatibility with existing code
- Provides status methods (canUndo, canRedo, descriptions)

#### 4. Enhanced UI (`lib/cart.dart`)

- Undo/Redo buttons in the cart screen app bar
- Buttons are enabled/disabled based on availability
- Tooltips show descriptions of operations that can be undone/redone
- Snackbar feedback when operations are performed

## Features

### Core Functionality

✅ **Complete Undo/Redo Support**
- All cart operations are undoable: add, remove, increment, decrement, clear
- Redo capability for all undone operations
- Proper handling of complex operations (e.g., decrement that removes item)

✅ **User Interface**
- Undo/Redo buttons in cart screen header
- Visual feedback with enabled/disabled states
- Operation descriptions in tooltips
- Snackbar notifications for undo/redo actions

✅ **Smart History Management**
- History limit prevents memory issues
- Redo stack automatically cleared on new operations
- Operation descriptions for better user experience

✅ **Robust Edge Case Handling**
- Handles quantity limits (max 10 items per type)
- Properly manages item removal when quantity reaches 0
- Maintains cart state consistency during all operations

### Technical Features

✅ **Clean Architecture**
- Command pattern provides excellent separation of concerns
- No circular dependencies
- Easy to extend with new operations

✅ **Memory Efficient**
- Limited history stack (50 operations)
- Commands only store necessary state for undo

✅ **Error Handling**
- Commands validate operations before execution
- Safe undo operations that maintain cart integrity

## Usage

### Basic Operations

```dart
// Add item to cart (creates AddItemCommand internally)
Cart.addItem(item, context);

// Remove item by index (creates RemoveItemCommand internally)  
Cart.removeItemAt(0);

// Increment/decrement quantity (creates respective commands)
Cart.incrementQty('Item Name');
Cart.decrementQty('Item Name');

// Clear entire cart (creates ClearCartCommand internally)
Cart.clearCart();
```

### Undo/Redo Operations

```dart
// Check if undo/redo is available
if (Cart.canUndo) {
  Cart.undo(); // Undoes last operation
}

if (Cart.canRedo) {
  Cart.redo(); // Redoes last undone operation  
}

// Get operation descriptions
String? undoDesc = Cart.undoDescription; // "Add Apple (2)"
String? redoDesc = Cart.redoDescription; // "Remove Orange"
```

### UI Integration

The cart screen automatically shows undo/redo buttons that:
- Are enabled only when operations are available
- Show tooltips with operation descriptions
- Provide visual feedback through snackbars
- Update the cart display after each operation

## Testing

### Comprehensive Test Coverage

The implementation includes extensive tests covering:

1. **Individual Command Tests** (`test/undo_redo_test.dart`)
   - Each command type (Add, Remove, Increment, Decrement, Clear)
   - Undo/redo behavior for each command
   - Edge cases like quantity limits and item removal

2. **Integration Tests** (`test/integration_undo_redo_test.dart`)
   - Complete workflows with multiple operations
   - History management (stack clearing, limits)
   - Cart method integration
   - Real-world usage scenarios

3. **Demo Script** (`lib/demo_undo_redo.dart`)
   - Interactive demonstration of functionality
   - Shows complete workflow from user perspective

## Benefits

### For Users
- **Mistake Recovery**: Users can easily undo accidental operations
- **Confidence**: Knowing they can undo gives users confidence to experiment
- **Efficiency**: Quick redo of undone operations saves time

### For Developers  
- **Maintainable**: Command pattern makes adding new operations easy
- **Testable**: Each command is independently testable
- **Extensible**: Easy to add new types of undoable operations
- **Robust**: Comprehensive error handling and edge case management

## Future Enhancements

Potential improvements that could be added:

1. **Persistence**: Save undo history across app sessions
2. **Batch Operations**: Group related operations for single undo
3. **Operation Timestamps**: Show when operations were performed
4. **Keyboard Shortcuts**: Ctrl+Z / Ctrl+Y support
5. **Visual History**: Show list of recent operations
6. **Operation Limits**: Different limits for different operation types

## Migration Notes

The implementation maintains full backward compatibility:
- Existing cart operations continue to work unchanged
- New undo/redo functionality is purely additive
- No breaking changes to existing API
- All cart state management remains the same

The only visible changes are:
- New undo/redo buttons in cart UI
- Operations now go through command pattern internally
- Added snackbar feedback for better UX