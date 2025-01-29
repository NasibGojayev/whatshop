import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository{

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  //sign_up
  static bool isSignedUp = false;
  static bool isSignedIn = false;

  /*Future<void> saveUserId() async{
    String userId = await _auth.currentUser!.uid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }
  static Future<String?> getUserId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }*/
  

   static Future<Customer?> signUp(String email,String password,String name)async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password);
      isSignedUp = true;
      User? user = result.user;
      if(user!=null){
        String userId = user.uid;

        Customer customer = Customer(
            id: userId,
            name: name,
            password: password,
            email: email);
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
  // Get the currently signed-in user
  static Future<Customer?> getCurrentUser() async {
     FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser; // Get the current user from Firebase
    if (user != null) {
     DocumentSnapshot userData = await firestore.collection('Users').doc(user.uid).get();
      // If the user is signed in, return a Customer object with their data
      return Customer(
        id: user.uid, // Firebase UID
        name: userData['name'] ?? '', // User's name (optional)
        email: user.email ?? '', // User's email
        password: userData['password'], // Password is not retrievable from Firebase for security reasons
      );
    } else {
      return null; // No user is signed in
    }
  }




  static Future<void> addUserToFirestore(Customer customer) async{
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('Users').doc(customer.id).set({
      'name': customer.name,
      'email': customer.email,
      'password':customer.password
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

  Customer({
    required this.id,
    required this.name,
    required this.password,
    required this.email
  });
}






