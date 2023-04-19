import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/userModel.dart';
import '../services/firebaseService.dart';

class PageUserInventory extends StatefulWidget {
  const PageUserInventory({Key? key}) : super(key: key);

  @override
  State<PageUserInventory> createState() => _PageUserInventoryState();
}

class _PageUserInventoryState extends State<PageUserInventory> {
  _PageUserInventoryState() {}
  FirebaseService firebaseService = FirebaseService();

  //Text Controllers
  TextEditingController inventoryController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  bool editDisable = true;
  Color textEnableColor = Colors.black12;
  String buttonFunc = "Edit";
  IconData buttonIcon = Icons.add;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firebaseService.readUserAsStream(),
        builder: (context, snapshot) {
          //If something went wrong in retrieving snapshot
          if (snapshot.hasError) {
            return const Text('Something went wrong');

            //Creating text of instructions (Firestore)
          } else if (snapshot.hasData) {
            final User user = User.fromJson(snapshot.data!.docs.first.data());
            user.userInventory.sort((a,b) => a.compareTo(b));
            return buildUserInventoryPage(user);

            //If no data in collection (Firestore)
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget buildUserInventoryPage(User user){
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Inventory'),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child:Row(
              children: [
                Expanded(
                  child:TextFormField(controller: inventoryController,),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                  child: SizedBox(
                  width: 40,
                  child:FloatingActionButton(
                    heroTag: 1,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    onPressed: () async {
                      if (inventoryController.text.trim() != "") {
                        firebaseService.updateUserInventory(inventoryController.text, 1);
                        inventoryController.text = '';
                        setState(() {});
                      }
                    },
                    foregroundColor: Colors.black,
                    child: const Text("+", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400), textScaleFactor:2.7),
                  ),
                )
                ),
                SizedBox(
                  width: 40,
                  child:FloatingActionButton(
                    heroTag: 2,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    onPressed: () async {
                      if (inventoryController.text.trim()!="") {
                        firebaseService.updateUserInventory(inventoryController.text, 2);
                        inventoryController.text = '';

                      }
                    },
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
              child:SizedBox(
                width:100,
                height: 30,
                child:FloatingActionButton(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  onPressed: () async {
                    inventoryController.text = "";
                    setState(() {});
                  },
                  foregroundColor: Colors.black,
                  child: const Text("Clear text", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),),
                ),
              ),
            ),

            const Text('Inventory',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w900, decoration: TextDecoration.underline,),
              textScaleFactor: 1.6,),
            ListView.builder(
                shrinkWrap: true,
                itemCount:user.userInventory.length,
                itemBuilder: (BuildContext context, int index){
                  return Card(
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      elevation: 3,
                      child:GestureDetector(
                        onTap:(){inventoryController.text=user.userInventory[index].toString();},
                        child:Text(user.userInventory[index].toString())
                      )
                  );
                }
            ),
          ],
        ),
    );
  }
}

//Missing data popup
Future<void> _illegalData(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
            "Problem with details!", textAlign: TextAlign.left),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text("Make sure valid details"),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
