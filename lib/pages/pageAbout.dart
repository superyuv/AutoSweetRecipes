import 'package:flutter/material.dart';
import 'Widgets/appAboutCard.dart';
import 'Widgets/yuvalAboutCard.dart';

class PageAbout extends StatelessWidget {
  const PageAbout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("About", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29,)),
            titleSpacing: 00.0,
            centerTitle: true,
            toolbarHeight: 60.2,
            toolbarOpacity: 0.8,
        ),
      body:ListView(
        children: const [
          AppAboutCard(),
          YuvalAboutCard(),

        ],
      )
    );
  }
}

