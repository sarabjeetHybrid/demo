import 'package:demo/cart.dart';
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

  int get cartItemCount {
  return Cart.itemList.fold(0, (sum, item) => sum + item.qty);
}
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
  void initState() {
    // TODO: implement initState
    //StaticVariable.itemList.clear(); // Clear the cart items at the start
    super.initState();
      Cart.itemList.addAll(StaticVariable.itemList);

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
       leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, 'false'),
        ),
        title: Text(widget.name),
      ),
      body: Column(
        children: [
         
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                  ),     
                    textAlign: TextAlign.center,
                    ),
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

              Cart.addItem(storedValue, context);

            setState(() {
            
            });
              // Navigator.pop(context, 'true');
            
            },
            child: Text('Add to Cart'),
          ),
          const SizedBox(height: 20),
       
        ],
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: Cart.itemList.isNotEmpty ? Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            // Navigate to cart or checkout page
            debugPrint("Checkout pressed with ${Cart.itemList.length} items");
            Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
          },


          child: Text(
            Cart.itemList.length.toString() == "0" || Cart.itemList.length == 1
                ? "${Cart.itemList.length} Item • Checkout"
                : "${Cart.itemList.length} Items • Checkout",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ):null,
    );
  }




   
  
  // static void removeItem(String key) {
  //   StaticVariable.itemList.removeWhere((item) => item.key == key);
  // }
}