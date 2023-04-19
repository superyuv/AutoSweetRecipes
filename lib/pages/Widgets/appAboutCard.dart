import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppAboutCard extends StatelessWidget {
  const AppAboutCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0),),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'MySweetRecipes is all about sweetning your day while considering your available ingridiants and preferances!\nJust update your inventory and get the recipes for you! Also, in just a press of a button, you can make a recipe suit to your preferences! We wish you a great experince and the sweetest day ever!',
          style: TextStyle(
            fontSize: 20, height: 1.5, fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
