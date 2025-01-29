
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatshop/Auth/auth_repository.dart';


class Product2Provider with ChangeNotifier {
  bool _noProductsLeft = false;
  bool get noProductsLeft =>_noProductsLeft;
  bool _productsFetched = false;
  void setProductsFetched(){
    _productsFetched = false;
  }
  bool _isFetchingNext = false;
  void setIsFetchingNext(){
    _isFetchingNext = true;
  }
  bool get isFetchingNext => _isFetchingNext;
  Map<String , List<DocumentSnapshot>> _cachedProducts = {};
  List<DocumentSnapshot> _allCachedProducts = [];
  List<DocumentSnapshot> _products =[];
  List<String> _favorites = [];

  Future<void> fetchProductsByCategory(String categoryId) async{
    print(categoryId);
    if(_cachedProducts.containsKey(categoryId)){
      _products = _cachedProducts[categoryId]!;
    }else{
      final querySnapshot = await FirebaseFirestore.instance.
      collection('products')
          .where('category',isEqualTo: categoryId).limit(20).get();
      _products = querySnapshot.docs;
      _cachedProducts[categoryId] = _products;
      notifyListeners();
    }
  }
  Future<void> fetchNextProductsByCategory(String categoryId) async {
    if(!isFetchingNext) return;
    if (_cachedProducts.containsKey(categoryId)) {
      // Get the last document of the current batch
      DocumentSnapshot lastDocument = _products.last;

      // Fetch the next set of products
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: categoryId)
          .startAfterDocument(lastDocument) // Start after the last document
          .limit(20)
          .get();
      _isFetchingNext = false;

      // Append the new products to the existing ones
      _products.addAll(querySnapshot.docs);
      _cachedProducts[categoryId] = _products;

      notifyListeners();
    }
  }

  List<DocumentSnapshot> get products => _products;
  List<String> get favorites=>_favorites;
  Future<void> fetchProducts()async{
    if(_productsFetched) return;
    if(_allCachedProducts.isNotEmpty){
      _products = _allCachedProducts!;
    };
    try{
      final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('products').limit(4).get();
      _products = snapshot.docs;
      _allCachedProducts = _products;
      _productsFetched = true;

      notifyListeners();
    }
    catch(e){
      print("Error fetching the data : $e");
    }

  }
  Future<void> fetchNextProducts()async{
    if(!isFetchingNext) {
      print('because it was false i am returning 😒');
      return;
    };
    if(_products.isEmpty){
      print("product list is empitieso");
      return;
    };
    _isFetchingNext = false;
    DocumentSnapshot lastDocument = _products.last;

    // Fetch the next set of products
    try{
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .startAfterDocument(lastDocument) // Start after the last document
          .limit(4)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _noProductsLeft=true;
        return;
      }

      // Append the new products to the existing ones
      _products.addAll(querySnapshot.docs);
      //_allCachedProducts = _products;

      notifyListeners();
    }catch(e){
      print("there is an error occured $e");
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

  Future<void> addTestProducts() async {
    try {
      // Create an instance of Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Generate 40 test products
      await firestore.collection('products').add({
        'id': '11',
        'picPath':'assets/images/products/bag.png',
        'sizes':{'usaq ucun','boyuk ucun'},
        'name': 'Test Product 11', // Product name
        'description': 'This is a description for Test Product 11.',
        'price': (1) * 10.0, // Price increments by $10
        'category': 'electronics_00',  // Example category
        'created_at': Timestamp.now(), // Creation timestamp
      });
      print("Test products added successfully!");
    } catch (e) {
      print("Error adding test products: $e");
    }
  }

  Future<void> deleteTestProducts() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get all products from the collection
      QuerySnapshot querySnapshot = await firestore.collection('products').get();

      // Delete each product in the collection
      for (var doc in querySnapshot.docs) {
        if(doc.id==1)continue;
        if(doc.id==2)continue;
        if(doc.id==3)continue;
        await doc.reference.delete();
      }

      print("All test products deleted successfully!");
    } catch (e) {
      print("Error deleting test products: $e");
    }
  }

  void toggleVisibility(bool isHidden){
    isHidden = !isHidden;
  }
}






