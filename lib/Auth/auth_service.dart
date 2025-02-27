import 'package:supabase_flutter/supabase_flutter.dart';




class AuthService{


  final SupabaseClient _supabase = Supabase.instance.client ;

   User? cachedUser;


   Future<User?> getCurrentUser() async{
    AuthService authService = AuthService();

    if(cachedUser!=null) return cachedUser;
    cachedUser = authService._supabase.auth.currentUser;
    return cachedUser;
  }

  static bool isSignedUp = false;
  static bool isSignedIn = false;

  //Sign in with email and password

  Future<AuthResponse> signInWithEmailAndPassword(String email, String password) async{
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password
    );
    isSignedIn = true;

    return response;
  }



  //Sign up with email and password

  Future<AuthResponse> signUpWithEmailAndPassword(Customer customer) async {

    final AuthResponse response = await _supabase.auth.signUp(
        email: customer.email,
        password: customer.password.toString()
    );
    await addUserToBase(
      Customer(
        id: response.user!.id,
        name: customer.name,
        password: customer.password,
        email: customer.email
      )
    );
    isSignedUp = true;
    return response;
  }

  //Sign out
    Future<void> signOut() async{
    isSignedUp = false;
    isSignedIn = false;
    await _supabase.auth.signOut();
  }


 // Get user email

String? getUserEmail(){
    final user = _supabase.auth.currentUser;
    if(user!=null){

      return user.email;
    }
    return null;
}

  Future<void> addUserToBase(Customer customer) async{
    await _supabase.from('users').insert({
      'id':customer.id,
      'name':customer.name,
      'email':customer.email,
      'password':customer.password,
      'cart': []
    }
    );

  }



}


class Customer{
  final String? id;
  final String? name;
  final String? password;
  final String? email;
  final List<String> cart;

  Customer({
    this.cart = const[],
    this.id,
    required this.name,
    required this.password,
    required this.email,
  });
}
