import 'package:demo/home.dart';
import 'package:demo/main_dash_board_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool showForm = false; // Show form after animation
 final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? errorMessage;
  String? errorMessage1;
  double _opacity = 0.0;
  bool isChecked = false;
  @override
  void initState() {

    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    super.initState();


    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom
      end: const Offset(0, 0), // End at normal position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showForm = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated logo
          Align(
            alignment: Alignment.topCenter,
            child:  Container(
                    height: 400,
                    color: showForm ? const Color(0xFFF2EDD1) : Colors.transparent,
                    alignment: Alignment.topCenter,
                       child:SlideTransition(
              position: _slideAnimation,
              child: Container(
                      margin: const EdgeInsets.only(top: 50),
                      height:265,
                      width: 265,
                        child: ClipRRect(
                        child: Image.asset('assets/images/quiz3.png', fit: BoxFit.cover, width: double.infinity, height: 90, alignment: Alignment.bottomCenter)),
                      ),)
            ),
          ),

          // Form after animation
          if (showForm)
            Positioned(
              top: 320,
              left: 20,
              right: 20,
             
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 1200), 
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: usernameController,
                            decoration: const InputDecoration(labelText: 'Username'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Password'),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(value: isChecked, onChanged: (bool? value) {
                              setState(() {
                                isChecked = value ?? false;
                                print('Checkbox is now: $isChecked');
                                // Handle checkbox state change
                              });
                            }),
                            const Text('Remember me', style: TextStyle(fontSize: 16)),
                          ],

                        ),
                        const SizedBox(height: 10),
                       SizedBox(
                            width: double.infinity, 
                           height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                backgroundColor: Colors.deepPurple,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (usernameController.text.isEmpty) {
                                    showAlertDialog('Please enter username');
                                  } else if (passwordController.text.isEmpty) {
                                    showAlertDialog('Please enter password');
                                  } else if(isChecked == false) {
                                    showAlertDialog('Please check the "Remember me" option');
                                  }
                                  
                                  else {
                                    print('Username: ${usernameController.text}');
                                    print('Password: ${passwordController.text}');
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => MainDashBoardScreen()) );
                                  }
                                });
                              },
                              child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 20)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
  void showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
