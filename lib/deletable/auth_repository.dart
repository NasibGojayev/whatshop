/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


//----------------------------
User? _cachedUser;

Future<User?> getCurrentUser() async{
  if(_cachedUser!=null) return _cachedUser;
  _cachedUser = FirebaseAuth.instance.currentUser;
  return _cachedUser;
}
//----------------------------
class AuthRepository{

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  //sign_up
  static bool isSignedUp = false;
  static bool isSignedIn = false;


   static Future<Customer?> signUp(String email,String password,String name)async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password);
      isSignedUp = true;
      User? user = result.user;
      if(user!=null){
        String userId = user.uid;
        user.updateProfile(displayName:name);
        Customer customer = Customer(
            id: userId,
            name: name,
            password: password,
            email: email,
            addresses: [],
            favorites: []
        );
        addUserToFirestore(customer);
        return customer;

      }else{
        return null;
      }

    }catch(e){
      print(e);
      return null;
    }

  }


  static Future<void> addUserToFirestore(Customer customer) async{
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('Users').doc(customer.id).set({
      'name': customer.name,
      'email': customer.email,
      'password':customer.password,
      'addresses':customer.addresses,
      'favorites':customer.favorites
    });
  }



  //sign_in
  static Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      isSignedIn = true;


      return result.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Sign Out
  static Future<void> signOut() async {
    await _auth.signOut();
    isSignedIn = false;
  }

  static Future<void> signInWithGoogle() async{
     GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
     GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
     AuthCredential credential = GoogleAuthProvider.credential(
       accessToken:googleAuth?.accessToken,
       idToken: googleAuth?.idToken
     );

     UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);
     print(user.user?.displayName);
     isSignedIn = true;
}

}

class Customer{
  String? id;
  String? name;
  String? password;
  String? email;
  List<Map<String,String>> addresses;
  List<String> favorites;

  Customer({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.addresses,
    required this.favorites
  });
}






*/
