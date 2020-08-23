import 'package:brew_order/models/user.dart';
import 'package:brew_order/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;   //firebaseauth object
  //"_" in auth means its private,i.e., we can use it in this file only
    
  //create user object based on firebase object
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null; 

  }


  //auth  change user stream
  Stream<User> get user {     //this stream will return our custom user
    return _auth.onAuthStateChanged
      .map(_userFromFirebaseUser);
  }



  //signin anonymously
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously(); 
      //it is important that you have this authentication enabled in firebase console
      FirebaseUser user = result.user;      //to access the user
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  //sign-in with email and password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password:password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }
  
  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password:password);
      FirebaseUser user = result.user;

      //create a new document for the suer with the uid
      await DatabaseService(uid: user.uid).updateUserData('0', 'new crew member', 100);
      return _userFromFirebaseUser(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }
  
  //sign out 
  Future signOut() async{
    try{
        return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;

    }
  }

}