import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatshop/Auth/auth_repository.dart';


class ProductProvider with ChangeNotifier {
  List<DocumentSnapshot> _products =[];
  List<String> _favorites = [];
  List<DocumentSnapshot> get products => _products;
  List<String> get favorites=>_favorites;
  Future<void> fetchProducts()async{
    try{

      final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('products').limit(14).get();
      _products = snapshot.docs;
      notifyListeners();
    }
    catch(e){
      print("Error fetching the products : $e");
    }

  }




  Future<String?> userId() async{
    try{
      Customer? user = await AuthRepository.getCurrentUser();
      String? userId = user?.id;
      return userId;
    }catch(e){
      print("ID elde ederken xeta bas verdi $e");
    }
  }
  Future<void> fetchFavorites() async{
    try{
      String? currentUserId = await userId();

      if (currentUserId == null) {
        print("User not found. Exiting fetching.");
        return;  // Exit if userId is null
      }
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc('$currentUserId').get();
      if(userDoc.exists){
        _favorites = List<String>.from(userDoc['favorites']);
        notifyListeners();
      }
    }catch(e){
      print('Error fetching favorites: $e');
    }
  }
  bool isHearted(String productId) {
    return favorites.contains(productId);
  }

  Future<void> toggleHeart(String productId) async {
    try {
      String? currentUserId = await userId();

      if (currentUserId == null) {
        print("User not found. Exiting toggleHeart.");
        return;  // Exit if userId is null
      }else{
        print(currentUserId);
      }

      DocumentReference userRef =
      FirebaseFirestore.instance.collection("Users").doc("$currentUserId");

      if (isHearted(productId)) {
        // Remove from favorites
        await userRef.update({
          'favorites': FieldValue.arrayRemove([productId])
        });
        _favorites.remove(productId);
      } else {
        // Add to favorites
        await userRef.update({
          'favorites': FieldValue.arrayUnion([productId])
        });
        _favorites.add(productId);
      }

      notifyListeners(); // Notify listeners after updating local state
    } catch (e) {
      print("Error in toggleHeart: $e");
    }
    notifyListeners();
  }


}
