import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/authService.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({Key? key}) : super(key: key);

  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Google Login"),
        backgroundColor: const Color.fromRGBO(232, 115, 164, 1.0),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: size.height * 0.1,
            bottom: size.height * 0.4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Image(
                width: 400, height: 150, image: AssetImage('assets/MySweetRecipe_logo.png')),
            GestureDetector(
                onTap: () async {
                  AuthService().signInWithGoogle();
                },
                child: Column(
                  children: const [
                    Image(width: 150, image: AssetImage('assets/google.png')),
                    Text("Sign in with google",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
