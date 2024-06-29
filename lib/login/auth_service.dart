import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../provider/Name provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> loginWithGoogle()async{

    //final GoogleSignIn googleSignIn=GoogleSignIn(clientId: "1092798171686-77q1nsshhchc8c82lo0t1c3chm6tf1i3.apps.googleusercontent.com");
    try{
      final googleUser = await GoogleSignIn(clientId:"789013470799-h6c9u4clbubakbi3bl7idh2k67q2f6od.apps.googleusercontent.com" ).signIn();

      final googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken,
          accessToken: googleAuth?.accessToken
      );
      googleUser!.displayName;
      return await _auth.signInWithCredential(cred);
    }
    catch(e){
      print(e.toString());
    }
    return null;
  }

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return cred.user;
    } on FirebaseException catch(e){
      exceptionHandler(e.code);
    }

    catch (e) {
      log("Something went wrong: $e");
      return null;
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return cred.user;
    }on FirebaseException catch(e){
      exceptionHandler(e.code);
    }
    catch (e) {
      log("Something went wrong: $e");
      return null;
    }
    return null;
  }



  Future<void> signout() async {
    try {
      await _auth.signOut();
      final GoogleSignIn googleSignIn = GoogleSignIn();
      googleSignIn.signOut();
    } catch (e) {
      log("Something went wrong: $e");
    }
  }
}

exceptionHandler(String code){
  switch(code){
    case"invalid-credential":
      log("your login credentials are invalid");
      case"Week password ":
        log("Your password must contain 8 letter");
    case"email is already in use":
      log("user ifd already exit");
    default:log("something went wrong");
  }
}



