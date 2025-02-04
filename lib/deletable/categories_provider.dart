/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider with ChangeNotifier{
  List<Map<String , dynamic>> _categories = [];
  List<Map<String , dynamic>> get categories=>_categories;

  int _selectedIndex = 0;
  int get selectedIndex =>_selectedIndex;
  void setSelectedIndex(int newIndex){
    print('selecting new index=$newIndex');
    _selectedIndex = newIndex;
    notifyListeners();
  }
  Future<void> fetchCategories() async{

    if(_categories.isNotEmpty){
      return;
    }
    try{
      final categorySnapshot = await FirebaseFirestore.instance.collection('categories').get();
      _categories = categorySnapshot.docs.map((doc){
        return{
          'id':doc.id,
          'name':doc['name'],
          'description':doc['description'],
          'iconPath' : doc['iconPath']
        };
      }).toList();
      notifyListeners();
    }catch(error){
      print('Error fetching categories: $error');
    }
  }
}
*/
