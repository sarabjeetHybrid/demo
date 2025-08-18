import 'package:demo/static_variable.dart';
import 'package:demo/stored_value.dart';
import 'package:flutter/material.dart';

class CardDetails extends StatefulWidget {
  final String name;
  final String price;
  final String image;
  
  CardDetails({required this.name, required this.price, required this.image});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

// Simple InputCounter widget definition
class InputCounter extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;

  const InputCounter({
    Key? key,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<InputCounter> createState() => _InputCounterState();
}

class _InputCounterState extends State<InputCounter> {
  late int _value;
  int storedValueQty = 0;
  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _decrement() {
    if (_value > widget.minValue) {
      setState(() {
        _value--;
      });
      widget.onChanged(_value);
    }
  }

  void _increment() {
    if (_value < widget.maxValue) {
      setState(() {
        _value++;
      });
      widget.onChanged(_value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: _decrement,
        ),
        Text('$_value', style: TextStyle(fontSize: 18)),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: _increment,
        ),
      ],
    );
  }
}

class _CardDetailsState extends State<CardDetails> {
  int storedValueQty = 1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
         
          SizedBox(
            child: Column(
              children: [
                Image.asset(widget.image),
                Text(widget.name),
                Text(widget.price),
                const SizedBox(height: 20),
                Text(
                  'This is a detailed description of the ${widget.name}. It provides information about the plant, its care instructions, and any other relevant details that might interest the user.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                  ),       ),
                const SizedBox(height: 20),
                InputCounter(
                  initialValue: 1,
                  minValue: 1,
                  maxValue: 10,
                  onChanged: (value) {
                    storedValueQty = value;
                    debugPrint("Quantity changed to $value");
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Add to cart logic here
              debugPrint("Add to cart pressed for ${widget.name}");
              StoredValue storedValue = StoredValue(
                key: widget.name,
                name: widget.name,
                image: widget.image,
                qty: storedValueQty, // Assuming quantity is 1 for simplicity
                price: double.parse(widget.price.replaceAll('\$', '')),
              );
              addItem(storedValue, context);
              // If you want to debug the cart, print Cart.items or similar
              // Navigate back or show a confirmation message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.name} added to cart!'),
                ),
              );
              Navigator.pop(context);
            },
            child: Text('Add to Cart'),
          ),
          const SizedBox(height: 20),
       
        ],
      ),
    );
  }

   void addItem(StoredValue item, BuildContext context) {
    
    if (StaticVariable.itemList.any((existingItem) => existingItem.name == item.name) ) {
      // If the item already exists, you might want to update the quantity instead
      final index = StaticVariable.itemList.indexWhere((existingItem) => existingItem.name == item.name);
      if (StaticVariable.itemList[index].qty +item.qty> 10) {
        // Prevent adding more than 10 of the same item
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Limit Reached"),
              content: Text("Cannot add more than 10 of the same item"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
      StaticVariable.itemList[index] = StoredValue(
        key: item.key,
        name: item.name,
        image: item.image,
        qty: StaticVariable.itemList[index].qty + item.qty, // Update quantity
        price: item.price,
      );
      return;
    }
    StaticVariable.itemList.add(item);
     
  }
  
  // static void removeItem(String key) {
  //   StaticVariable.itemList.removeWhere((item) => item.key == key);
  // }
}