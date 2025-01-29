import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Auth/auth_repository.dart';

class UserDetails with ChangeNotifier {
  List<Map<String, String>> _addresses = [];

  List<Map<String, String>> get addresses => _addresses;


  void addAdress(String line1, String line2) {
    _addresses.add({'line1': line1, 'line2': line2});
    notifyListeners();
  }

  void clearAddresses() {
    _addresses.clear();
    notifyListeners();
  }

  void deleteAddress(int index) {
    _addresses.removeAt(index);
  }

  Customer? _user;

  Customer? get user => _user;

  void setUser() async{
    Customer? customer = await AuthRepository.getCurrentUser();
    if (customer != null) {
      _user = customer;
      notifyListeners(); // Notify UI about the changes
    } else {
      print('No user found in AuthRepository');
    }
  }

}




