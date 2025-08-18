import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    nameController.text = "John Doe";
    emailController.text = "john@gmail.com";
    phoneController.text = "+1234567890";
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/images/quiz3.png'),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${nameController.text}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                Opacity(
                  opacity: 1.0,
                  child: TextField(
                    controller: emailController,
                    enabled: false, // keeps it uneditable
                    style: const TextStyle(
                      color: Colors.black, // Darker text
                      fontWeight: FontWeight.w500, // Slightly bolder
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                        color: Colors.black, // Dark label
                      ),
                      filled: true,
                      // Darker background
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black, // Dark border
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                   Opacity(
                    opacity: 1.0,
                    child: TextField(
                    controller: phoneController,
                    enabled: false, // keeps it uneditable
                    style: const TextStyle(
                      color: Colors.black, // Darker text
                      fontWeight: FontWeight.w500, // Slightly bolder
                    ),
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: const TextStyle(
                        color: Colors.black, // Dark label
                      ),
                      filled: true,
                      // Darker background
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black, // Dark border
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
               
                ),
                SizedBox(height: 20),
                SizedBox(
                  
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      // Add your logout logic here
                      debugPrint("Logout pressed");
                    },
                    child: Text('Logout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
