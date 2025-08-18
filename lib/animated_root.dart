import 'package:demo/stagger_drop_animation.dart';
import 'package:flutter/material.dart';

class AnimatedRoot extends StatefulWidget {
  const AnimatedRoot({super.key, required this.color});

  final Color color;

  @override
  State<AnimatedRoot> createState() => _SplashAnimationState();
}

class _SplashAnimationState extends State<AnimatedRoot>
    with SingleTickerProviderStateMixin {
  Size size = Size.zero;
  late AnimationController _controller;
  late StaggeredDropAnimation _animation;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? errorMessage;
  String? errorMessage1;
  bool moveUp = false;
  bool moveUpText =  false;
 



  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    usernameController.addListener(() {
      if (usernameController.text.isNotEmpty && errorMessage != null) {
        setState(() {
          errorMessage = null;
        });
      }
    });

    passwordController.addListener(() {
      if (passwordController.text.isNotEmpty && errorMessage1 != null) {
        setState(() {
          errorMessage1 = null;
        });
      }
    });
    _controller = AnimationController(
      duration: const Duration(milliseconds: 10000),
      vsync: this,
    );
    _animation = StaggeredDropAnimation(_controller);
    _controller.forward();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    setState(() {
      size = MediaQuery.of(context).size;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width:double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
          
          SizedBox(
                width: _animation.dropSize.value,
                height: _animation.dropSize.value,
                child: _animation.dropVisible.value
                    ? Container(
                    height: 400,
                    color: const Color(0xFFF2EDD1),
                    alignment: Alignment.topCenter,
                       child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      height:250,
                      width: 250,
                        child: ClipRRect(
                        child: Image.asset('assets/images/quiz3.png', fit: BoxFit.cover, width: double.infinity, height: 90, alignment: Alignment.bottomCenter)),
                      ),)
                    : Container(),
              ),
            
            _animation.contentVisible.value ? 
            Positioned(
                      top: 280,
                      left: 0,
                      right: 0,
                       child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: _animation.textOpacity.value,
              
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                            elevation: 4,
                            color: const Color.fromARGB(255, 207, 204, 204),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                               Radius.circular(16)
                             
                        
                            )),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: usernameController,
                                      decoration: const InputDecoration(labelText: 'Username'),
                                    ),
                                  ),
                                  if (errorMessage != null && errorMessage!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        errorMessage!,
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: passwordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(labelText: 'Password'),
                                    ),
                                  ),
                                  if (errorMessage1 != null && errorMessage1!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        errorMessage1!,
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  
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
                                } else {
                                  print('Username: ${usernameController.text}');
                                  print('Password: ${passwordController.text}');
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
                      ),
              ),
            ) ): Container(),
            // _animation.contentVisible.value ? Padding(
            //   padding: const EdgeInsets.only(bottom: 32),
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Opacity(
            //       opacity: _animation.nicOpacity.value,
            //       child: Container(
            //         height: 50,
            //         width: 100,
            //         decoration: const BoxDecoration(
            //           image: DecorationImage(
            //             image: AssetImage('assets/logos/MahilaNidhiwhit.png'),
            //             fit: BoxFit.cover,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ) : Container(),
          ],
        ),
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
 