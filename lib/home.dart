import 'package:demo/bottom_bar.dart';
import 'package:demo/login_screen/login_screen.dart';
import 'package:demo/notification.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override 
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedChip = "Popular";
  List<Map<String, dynamic>> mainPlants = [];

  void _filterItems(String query) {
    setState(() {
      if(selectedChip == "Popular") {
        mainPlants = plants1
    
          .where((item) => item["name"].toLowerCase().contains(query.toLowerCase()))
          .toList();
      } else if (selectedChip == "Indoor") {
        mainPlants = plants2
     
          .where((item) => item["name"].toLowerCase().contains(query.toLowerCase()))
          .toList();
      } else if (selectedChip == "Outdoor") {
        mainPlants = plants3
   
          .where((item) => item["name"].toLowerCase().contains(query.toLowerCase()))
          .toList();
      }
     
    });
  }
  // Example plant data
  final List<Map<String, dynamic>> plants1 = [
  {
    "name": "Aloe Vera",
    "price": "\$ 8.50",
    "image": "assets/images/quiz3.png",
  },
  {
    "name": "Snake Plant",
    "price": "\$ 12.00",
    "image": "assets/images/quiz3.png",
  },
  {
    "name": "Peace Lily",
    "price": "\$ 15.75",
    "image": "assets/images/quiz3.png",
  },
  {
    "name": "Bamboo Palm",
    "price": "\$ 10.20",
    "image": "assets/images/quiz3.png",
  },
  {
    "name": "Spider Plant",
    "price": "\$ 6.40",
    "image": "assets/images/quiz3.png",
  },
  {
    "name": "Fiddle Leaf Fig",
    "price": "\$ 22.00",
    "image": "assets/images/quiz3.png",
  },
  {
    "name": "Money Plant",
    "price": "\$ 9.99",
    "image": "assets/images/quiz3.png",
  },
    {
    "name": "Plant",
    "price": "\$ 10.99",
    "image": "assets/images/quiz3.png",
  },
    {
    "name": "Plant",
    "price": "\$ 10.99",
    "image": "assets/images/quiz3.png",
  },

];


final List<Map<String, dynamic>> plants2 = [
  {
    "name": "Succulent Mix",
    "price": "\$ 7.50",
    "image": "assets/images/quiz3.png",
  },
  {
    "name": "Orchid Plant",
    "price": "\$ 18.00",
    "image": "assets/images/quiz3.png",
  },
  {
    "name": "Cactus Small",
    "price": "\$ 4.25",
    "image": "assets/images/quiz3.png",
  },
  {
    "name": "Bonsai Tree",
    "price": "\$ 30.00",
    "image": "assets/images/quiz3.png",
  },
  {
    "name": "Lavender Pot",
    "price": "\$ 12.80",
    "image": "assets/images/quiz3.png",
  },
];



 final List<Map<String, dynamic>> plants3 = [
  {
    "name": "Rose Plant",
    "price": "\$ 14.00",
    "image": "assets/images/quiz3.png",
  },
  {
    "name": "Tulip Pot",
    "price": "\$ 11.50",
    "image": "assets/images/quiz3.png",
  },
  {
    "name": "Sunflower Mini",
    "price": "\$ 9.20",
    "image": "assets/images/quiz3.png",
  },
];

@override
  void initState() {
    
    // TODO: implement initState
     if (mainPlants.isEmpty) {
      mainPlants = plants1; // Default to the first set of plants
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      key: scaffoldKey,

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '''Let's find your \nplants''',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: (value) => _filterItems(value),
              ),
            ),

            const SizedBox(height: 16),

            // Chips Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  buildChip("Popular"),
                  buildChip("Indoor"),
                  buildChip("Outdoor"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Grid of Plants
            // Grid of Plants
SizedBox(
  height: 550,
    child: GridView.count(
      crossAxisCount: 2, // 2 items per row
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      childAspectRatio: 1, // Adjust card height/width ratio
      
      children: List.generate(mainPlants.length, (index) {
        final plant = mainPlants[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4.0,
                offset: const Offset(0, 2), 
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: Image.asset(
                  plant["image"],
                  fit: BoxFit.cover,
                  height: 120,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  plant["name"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Text(
                  plant["price"],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    ),
  
),

          ],
        ),
      ),
    );
  }

  Widget buildChip(String label) {
    bool isSelected = selectedChip == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
        selected: isSelected,
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6), // No 50% rounding
        ),
        selectedColor: Colors.green,
        backgroundColor: Colors.grey[200],
        onSelected: (bool selected) {
          setState(() {
            selectedChip = label;
            print('Selected chip: $selectedChip');
            // Update the plant list based on the selected chip
            if (selectedChip == "Popular") {
              mainPlants = plants1;
            } else if (selectedChip == "Indoor") {
              mainPlants = plants2;
            } else if (selectedChip == "Outdoor") {
              mainPlants = plants3;
            }
          });
        },
      ),
    );
  }
}
