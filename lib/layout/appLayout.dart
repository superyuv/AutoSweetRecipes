import 'package:auto_sweet_recipe/pages/pageCreateRecipe.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/pageFavorites.dart';
import '../pages/pageRecipeSelection.dart';
import '../services/authService.dart';
import '../services/pageNameProvider.dart';
import 'navBar.dart';



class AppLayout extends StatefulWidget {
  const AppLayout({Key? key}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const PageRecipeSelection(),
    const PageFavorites(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PageNameProvider>(context, listen: false)
          .setPageName("MyAutoSweetRecipe");
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = Provider.of<PageNameProvider>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(title.page),
          titleSpacing: 00.0,
          centerTitle: true,
          toolbarHeight: 60.2,
          toolbarOpacity: 0.8,
        actions: [
           IconButton(
              icon:
                  const Icon(FluentSystemIcons.ic_fluent_sign_out_regular),
              onPressed: () {
                AuthService().signOut();
              },
            ),
        ],
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PageCreateRecipe()));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),


      ),
      body: Center(child: _widgetOptions[_selectedIndex]),
      drawer: NavBar(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: const Color(0xFF526480),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_app_generic_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_app_generic_filled),
              label: "Recipes"),
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_star_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_star_filled),
              label: "Favorites"),
        ],
      ),
    );
  }
}
