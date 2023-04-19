import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/firebaseService.dart';

class PageUserSignUp extends StatelessWidget {
  PageUserSignUp({Key? key}) : super(key: key);

  FirebaseService firebaseService = FirebaseService();

  //Text Controllers
  TextEditingController userNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              controller: userNameController,
              expands: false,
            ),
            const Text('Phone',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w900, decoration: TextDecoration.underline,),
              textScaleFactor: 1.6,),
            TextFormField(
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
                      onPressed: ()  async {
                          if (userNameController.text == "" ||
                              phoneController.text.length != 10) {
                            _illegalData(context);
                          } else {
                            await firebaseService.updateUserDetails(
                                userNameController.text,
                                phoneController.text);
                          }
                      },
                      // backgroundColor: const Color(0x818170bb),
                      foregroundColor: Colors.black,
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      label: Text("Send",
                          style: TextStyle(color: Colors.white)),
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


bool isPhoneNumberValid(String input) {
  if (input == null || input.isEmpty) {
    return false; // empty string is not a valid phone number
  }
  if (input.length != 10) {
    return false; // phone number must be 10 digits long
  }
  final numericRegex = RegExp(r'^[0-9]+$');
  if (!numericRegex.hasMatch(input)) {
    return false; // phone number must contain only numeric characters
  }
  return true; // phone number is valid
}