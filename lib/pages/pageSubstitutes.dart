import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/userModel.dart';
import '../services/firebaseService.dart';

enum SingingCharacter {vegetarian, lactose, celiac}

class PageSubstitutes extends StatefulWidget {
  const PageSubstitutes({Key? key}) : super(key: key);

  @override
  State<PageSubstitutes> createState() => _PageSubstitutesState();
}

class _PageSubstitutesState extends State<PageSubstitutes> {
  _PageSubstitutesState() {}
  FirebaseService firebaseService = FirebaseService();
  SingingCharacter? _character = SingingCharacter.vegetarian;

  //Text Controllers
  TextEditingController ingredientController = TextEditingController();
  TextEditingController substituteController = TextEditingController();

  bool editDisable = true;
  Color textEnableColor = Colors.black12;
  String buttonFunc = "Edit";
  IconData buttonIcon = Icons.add;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Substitutes'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              ListTile(
                title: const Text('Vegetarian'),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.vegetarian,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),

              ListTile(
                title: const Text('Lactose'),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.lactose,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),

              ListTile(
                title: const Text('Celiac'),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.celiac,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const Divider(height: 15),
          const Text("Ingredient:", textScaleFactor: 1.3, style: TextStyle(fontWeight: FontWeight.bold),),
          Container(
            padding: const EdgeInsets.fromLTRB(10,0,90,20),
            child: TextFormField(
              controller: ingredientController,
            ),
          ),

          const Text("Substitute:",textScaleFactor: 1.3, style: TextStyle(fontWeight: FontWeight.bold),),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: substituteController,),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                      child: SizedBox(
                        width: 40,
                        child: FloatingActionButton(
                          heroTag: 1,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(15.0))),
                          onPressed: () async {
                            if (ingredientController.text.trim() != "" && substituteController.text.trim() != "") {
                              await firebaseService.removeSubstitute(_character.toString().split('.').last, ingredientController.text, substituteController.text);
                              await firebaseService.createSubstitute(
                                  type: _character.toString().split('.').last,
                                  ingredient: ingredientController.text.trim(),
                                  substitute: substituteController.text.trim());
                              ingredientController.text = '';
                              substituteController.text = '';
                              setState(() {
                              });
                            }
                          },
                          foregroundColor: Colors.black,
                          child: const Text("+", style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                              textScaleFactor: 2.7),
                        ),
                      )
                  ),
                  SizedBox(
                    width: 40,
                    child: FloatingActionButton(
                      heroTag: 2,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(15.0))),
                      onPressed: () async {
                        if (ingredientController.text.trim() != "" && substituteController.text.trim() != "") {
                          firebaseService.removeSubstitute(_character.toString().split('.').last, ingredientController.text, substituteController.text);
                          ingredientController.text = '';
                          substituteController.text = '';
                        }
                      },
                      // backgroundColor: const Color(0x818170bb),
                      foregroundColor: Colors.black,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]
            ),
          ),


          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 100,
              height: 30,
              child: FloatingActionButton(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(
                        10.0))),
                onPressed: () async {
                  ingredientController.text = "";
                  substituteController.text = '';
                  setState(() {});
                },
                // backgroundColor: const Color(0x818170bb),
                foregroundColor: Colors.black,
                child: const Text("Clear text", style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800),),
              ),
            ),
          ),

          const Text('Substitutes',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              decoration: TextDecoration.underline,),
            textScaleFactor: 1.6,),
          StreamBuilder<List<dynamic>>(
            stream: firebaseService.readSubstitutesByType(_character.toString().split('.').last),
            builder: (context, snapshot) {
              //If something went wrong in retrieving snapshot
              if (snapshot.hasError) {
                return const Text('Something went wrong!');
              //Creating ListView of history from collection (Firestore)
              } else if (snapshot.hasData) {
                var substitutes = snapshot.data!.map((e) => e).toList();
                substitutes.sort((a, b) => b.ingredient.compareTo(a.ingredient));
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: substitutes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        elevation: 3,
                        child:GestureDetector(
                            onTap:(){
                              ingredientController.text=substitutes[index].ingredient.toString();
                              substituteController.text=substitutes[index].substitute.toString();
                            },
                            child:Text(substitutes[index].ingredient.toString() + "  -->  " + substitutes[index].substitute.toString())
                        )
                    );
                  }
                );
              //If no data in collection (Firestore)
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }
          )
        ]
      )
    );
  }
}
