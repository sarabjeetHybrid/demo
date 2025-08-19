import 'package:demo/bottom_bar.dart';
import 'package:demo/cart.dart';
import 'package:demo/home.dart';
import 'package:demo/login_screen/login_screen.dart';
import 'package:demo/notification.dart';
import 'package:demo/stored_value.dart';
import 'package:demo/user_info.dart';
import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MainDashBoardScreen extends StatefulWidget {
  const MainDashBoardScreen({super.key});

  @override
  State<MainDashBoardScreen> createState() => _HomeState();
}

class _HomeState extends State<MainDashBoardScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String label = "home";
  var selected = 0;
  PageController controller = PageController(initialPage: 0);
  String stri = (Cart.itemList.length + 1).toString();
 @override
  void initState() {

    super.initState();
    controller = PageController(initialPage: selected);
  }
  @override
  Widget build(BuildContext context) {
    stri = (Cart.itemList.length).toString();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: const Color(0xFFF2EDD1),
        actions: [

          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_rounded, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              ),
              if (Cart.itemList.isNotEmpty)
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                     stri,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          
        ],
      ),

    drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
            ),
          ],
        ),
      ),
    
      body: PageView(
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            selected = index;
          });
        },
        children: [
          Home(), NotificationScreen(), UserInfo()
        ]   
      ),
     bottomNavigationBar: ClipRRect(
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  ),
  child: StylishBottomBar(
    backgroundColor: Colors.black,
    option: BubbleBarOptions(
      barStyle: BubbleBarStyle.horizontal,
      bubbleFillStyle: BubbleFillStyle.fill,
      //unselectedIconColor: kPrimaryDark,
      opacity: 0.3,
    ),
    iconSpace: 12.0,
    items: [
      BottomBarItem(
        icon: const Icon(Icons.home),
        selectedColor: Colors.white70,
        backgroundColor: Colors.white70,
        title: Text("home"),
        unSelectedColor: Colors.white70,
      ),
      // BottomBarItem(
      //   icon: const Icon(Icons.person),
      //   selectedColor: Colors.white70,
      //   backgroundColor:Colors.white70,
      //   title: Text(AppLocalizations.of(context)!.profile),
      //   unSelectedColor: Colors.white70,
      // ),

      BottomBarItem(
        icon: const Icon(Icons.notifications),
        selectedColor: Colors.white70,
        backgroundColor: Colors.white70,
        title: Text("notification"),
        unSelectedColor: Colors.white70,
      ),
       BottomBarItem(
        icon: const Icon(Icons.logout),
        selectedColor: Colors.white70,
        backgroundColor: Colors.white70,
        title: Text("user"),
        unSelectedColor: Colors.white70,
      ),
    ],
    hasNotch: true,
currentIndex: selected,
    onTap: (index) {
      setState(() {
    selected = index;
     label = [
        "Home", "Notification", "User"  
        ][index];
      
        controller.jumpToPage(index);
      });
    },
  ),
),
    );
  }
  
}
