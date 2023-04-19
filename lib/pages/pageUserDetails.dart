import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/userModel.dart';
import '../services/firebaseService.dart';

class PageUserDetails extends StatefulWidget {
  const PageUserDetails({Key? key}) : super(key: key);

  @override
  State<PageUserDetails> createState() => _PageUserDetailsState();
}

class _PageUserDetailsState extends State<PageUserDetails> {
  _PageUserDetailsState() {}
  FirebaseService firebaseService = FirebaseService();

  // Text Controllers
  TextEditingController userNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  // Variables
  bool editDisable = true;
  Color textEnableColor = Colors.black12;
  String buttonFunc = "Edit";
  IconData buttonIcon = Icons.edit;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: firebaseService.getUserDetails(),
        builder: (context, snapshot) {
          //If something went wrong in retrieving snapshot
          if (snapshot.hasError) {
            return const Text('Something went wrong');

            //Creating text of instructions (Firestore)
          } else if (snapshot.hasData) {
            final User user = User.fromJson(snapshot.data!.docs.first.data());
            userNameController.text = user.userName;
            phoneController.text = user.userPhone;
            return buildUserDetailsPage(user);

            //If no data in collection (Firestore)
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget buildUserDetailsPage(User user){
    return Scaffold(
          appBar: AppBar(
            title: const Text('User Details'),
          ),
          body: ListView(
            children: [
              const Text('Name',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w900, decoration: TextDecoration.underline,),
                textScaleFactor: 1.6,),
              TextFormField(
                enabled: !editDisable,
                controller: userNameController,
                expands: false,
              ),
              const Text('Phone',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w900, decoration: TextDecoration.underline,),
                textScaleFactor: 1.6,),
              TextFormField(
                enabled: !editDisable,
                controller: phoneController,
                expands: false,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
                    child: SizedBox(
                      width: 100,
                      child: FloatingActionButton.extended(
                        onPressed: () async {
                          if (buttonFunc == "Edit") {
                            editDisable = !editDisable;
                            buttonIcon = Icons.send;
                            buttonFunc = "Send";
                            setState(() {});
                          } else {
                            if (userNameController.text == "" ||
                                phoneController.text.length != 10) {
                              _illegalData(context);
                            } else {
                              await firebaseService.updateUserDetails(
                                  userNameController.text,
                                  phoneController.text);
                              editDisable = !editDisable;
                              buttonIcon = Icons.edit;
                              buttonFunc = "Edit";
                              setState(() {});
                            }
                          }
                        },
                        foregroundColor: Colors.black,
                        icon: Icon(
                          buttonIcon,
                          color: Colors.white,
                        ),
                        label: Text(buttonFunc,
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          )
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
