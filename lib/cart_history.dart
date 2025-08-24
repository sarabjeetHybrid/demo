import 'package:demo/cart_command.dart';

/// Manages the history of cart operations for undo/redo functionality
class CartHistory {
  static final CartHistory _instance = CartHistory._internal();
  factory CartHistory() => _instance;
  CartHistory._internal();

  final List<CartCommand> _undoStack = [];
  final List<CartCommand> _redoStack = [];
  
  static const int maxHistorySize = 50;

  /// Execute a command and add it to the undo stack
  void executeCommand(CartCommand command) {
    command.execute();
    
    // Add to undo stack
    _undoStack.add(command);
    
    // Clear redo stack when a new command is executed
    _redoStack.clear();
    
    // Limit history size
    if (_undoStack.length > maxHistorySize) {
      _undoStack.removeAt(0);
    }
  }

  /// Undo the last operation
  bool undo() {
    if (_undoStack.isEmpty) return false;
    
    CartCommand command = _undoStack.removeLast();
    command.undo();
    _redoStack.add(command);
    
    return true;
  }

  /// Redo the last undone operation
  bool redo() {
    if (_redoStack.isEmpty) return false;
    
    CartCommand command = _redoStack.removeLast();
    command.execute();
    _undoStack.add(command);
    
    return true;
  }

  /// Check if undo is available
  bool get canUndo => _undoStack.isNotEmpty;

  /// Check if redo is available
  bool get canRedo => _redoStack.isNotEmpty;

  /// Get description of the last undoable operation
  String? get lastUndoDescription => 
    _undoStack.isNotEmpty ? _undoStack.last.description : null;

  /// Get description of the last redoable operation  
  String? get lastRedoDescription =>
    _redoStack.isNotEmpty ? _redoStack.last.description : null;

  /// Clear all history
  void clearHistory() {
    _undoStack.clear();
    _redoStack.clear();
  }

  /// Get the size of undo stack for debugging
  int get undoStackSize => _undoStack.length;

  /// Get the size of redo stack for debugging
  int get redoStackSize => _redoStack.length;
}