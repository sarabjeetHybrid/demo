import 'package:demo/main_dash_board_screen.dart';
import 'package:demo/stored_value.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartState();
}

class _CartState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainDashBoardScreen()),
          ),
        ),
        actions: [
          // Undo button
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: Cart.canUndo ? () {
              setState(() {
                Cart.undo();
              });
              if (Cart.undoDescription != null) {
                snackBar(context, "Undone: ${Cart.undoDescription}");
              }
            } : null,
            tooltip: Cart.canUndo ? "Undo: ${Cart.undoDescription}" : "No actions to undo",
          ),
          // Redo button
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: Cart.canRedo ? () {
              setState(() {
                Cart.redo();
              });
              if (Cart.redoDescription != null) {
                snackBar(context, "Redone: ${Cart.redoDescription}");
              }
            } : null,
            tooltip: Cart.canRedo ? "Redo: ${Cart.redoDescription}" : "No actions to redo",
          ),
        ],
      ),
      body: Cart.itemList.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : ListView.builder(
              itemCount: Cart.itemList.length,
              itemBuilder: (context, index) {
                final item = Cart.itemList[index];

                return Column(
                  children: [
                    ListTile(
                      leading: Image.asset(item.image, width: 50, height: 50),
                      title: Text(item.name),
                      subtitle: Text("\$${item.price}"),
                      trailing: SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  Cart.decrementQty(item.name);
                                });
                              },
                            ),
                            Text(
                              '${item.qty}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                final currentItem = Cart.itemList[index];
                                if (currentItem.qty >= 10) {
                                  snackBar(
                                    context,
                                    "You can only add 10 items of the same type to the cart",
                                  );
                                } else {
                                  setState(() {
                                    Cart.incrementQty(item.name);
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  Cart.removeItemAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
      bottomNavigationBar: Cart.itemList.isEmpty
          ? null
          : SizedBox(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green[100],
                ),
                padding: EdgeInsets.only(
                  left: 0,
                  right: 2,
                  top: 12,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                ),
                margin: const EdgeInsets.only(
                  top: 8,
                  bottom: 20,
                  left: 200,
                  right: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "\$${totalPrice.toStringAsFixed(2)} \nTotal",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Container(
                            child: TextButton(
                              onPressed: () {
                                // Place order logic here
                              },
                              child: const Text(
                                "Place Order",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void snackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  double get totalPrice {
    return Cart.itemList.fold(0, (sum, item) => sum + item.price * item.qty);
  }
}
