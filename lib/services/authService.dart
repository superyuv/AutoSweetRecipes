import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../layout/appLayout.dart';
import '../pages/PageLogin.dart';
import 'firebaseService.dart';

class AuthService {
  static String? currentUserEmail;
  final googleSignIn = GoogleSignIn();
  FirebaseService firebaseService = FirebaseService();
  //Determine if the user is authenticated.
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            currentUserEmail = snapshot.data!.email;
            return FutureBuilder(
                future: firebaseService.writeUserToDB(),
                builder: (context, snapshot) {
                  return const AppLayout();
                });
          } else {
            currentUserEmail = null;
            return const PageLogin();
          }
        });
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
