import 'package:auto_sweet_recipe/pages/pageSubstitutes.dart';
import 'package:auto_sweet_recipe/pages/pageUserDetails.dart';
import 'package:flutter/material.dart';
import '../pages/pageUserRecipes.dart';
import '../pages/pageAbout.dart';
import '../pages/pageUserInventory.dart';
import '../services/authService.dart';
import '../services/firebaseService.dart';

const String SUPERUSER = "superyuv@gmail.com";

class NavBar extends StatelessWidget {
  const NavBar({super.key});



  @override
  Widget build(BuildContext context) {
    FirebaseService firebaseService = FirebaseService();
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("MySweetRecipe"),
            accountEmail: Text(firebaseService.getCurrentUserEmail()),

            decoration: const BoxDecoration(
              color: Color.fromRGBO(212, 89, 238, 1.0),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                      'assets/pinkCake.jpg')),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PageAbout())),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('User Recipes'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PageUserRecipes())),
          ),
          const Divider(height: 70),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Inventory'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PageUserInventory())),
          ),
          ListTile(
            leading: const Icon(Icons.settings_accessibility),
            title: const Text('User Details'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PageUserDetails())),
          ),
          if (firebaseService.getCurrentUserEmail() == SUPERUSER)
            ListTile(
              leading: const Icon(Icons.recycling),
              title: const Text('Substitutes'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PageSubstitutes())),
            ),

          ListTile(
            title: const Text('Sign Out'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () => AuthService().signOut(),
          ),
        ],
      ),
    );
  }
}