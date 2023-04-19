import 'package:auto_sweet_recipe/services/authService.dart';
import 'package:auto_sweet_recipe/services/firebaseService.dart';
import 'package:auto_sweet_recipe/services/pageNameProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'layout/appLayout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseService firebaseService = FirebaseService();
  await firebaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, widget) {
          return Directionality(
              textDirection: TextDirection.ltr, child: widget!);
        },
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(color: Color.fromRGBO(231, 73, 120, 1.0), elevation: 0),
          colorScheme: ColorScheme.highContrastLight(
              primary: Color.fromRGBO(232, 115, 164, 1.0),
              secondary: Color.fromRGBO(231, 73, 120, 1.0),
              tertiary: Color.fromRGBO(161, 133, 182, 1.0),
              onSecondary: Colors.white, // for text/icon on secondary color
              onPrimary: Colors.white, // for text/icon on primary color
              onTertiary: Colors.white // for text/icon on primary color
          ),
        ),
        home: ChangeNotifierProvider(
          create: (context) => PageNameProvider(""),
          //child: const AppLayout(),
          child: AuthService().handleAuthState(),
        ));
  }
}
