import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //create a user obj based on firebase user

  //auth change user stream
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  //sign in with email and password

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email: email)
          .then((value) async {
        if (value[0] == 'google.com') {
          throw ('User already Signed Up with Google');
        } else {
          AuthResult result = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          FirebaseUser user = result.user;
          return user;
        }
      });
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  //register with email and password

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email: email)
          .then((value) async {
        if (value[0] == 'google.com') {
          throw ('User already Signed Up with Google');
        } else {
          AuthResult result = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          FirebaseUser user = result.user;
          return user;
        }
      });
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  //signout

  Future signOut() async {
    try {
      return await _auth.signOut().then((value) => notifyListeners());
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(email: googleSignInAccount.email)
        .then((value) async {
      if (value[0] != 'google.com') {
        throw ('User already Signed Up with Email and Password. Please Login with them');
      } else {
        final AuthResult authResult =
            await _auth.signInWithCredential(credential);
        final FirebaseUser user = authResult.user;
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final FirebaseUser currentUser = await _auth.currentUser();
        assert(user.uid == currentUser.uid);
        return user;
      }
    });
  }

  Future<void> resetpassword(email) async {
    await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(email: email)
        .then((value) async {
      if (value[0] == 'google.com') {
        throw ('User already Signed Up with Google');
      } else {
        var result = await _auth.sendPasswordResetEmail(email: email);
        return result;
      }
    });
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
  }
}
