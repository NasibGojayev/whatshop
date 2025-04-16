import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Remove static flags - these can cause state inconsistencies
  bool get isSignedIn => _supabase.auth.currentSession != null;
  set isSignedIn(bool newValue) {
    isSignedIn = newValue;
  }

  Future<AuthResponse> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Clear any existing session first
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign-in failed: No user returned');
      }

      return response;
    } catch (e) {
      isSignedIn = false; // Clear the flag
      debugPrint('SignIn error: $e');
      // Always rethrow errors to handle them in the UI
      rethrow;
    }
  }

  Future<AuthResponse> signUpWithEmailAndPassword(
      {email, password, name}) async {
    try {
      String uniqueId = await generateUniqueUsername(name);
      await addUserToBase(
        Customer(
          id: uniqueId,
          name: name,
          email: email,
        ),
      );

      final response =
          await _supabase.auth.signUp(
              email: email,
              password: password,
              data: {
                'fullname': name,
                'username': uniqueId,
              });

      if (response.user == null) {
        throw Exception('Sign-up failed: No user returned');
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      // Clear any local cache if needed
    } catch (e) {
      debugPrint('SignOut error: $e');
      rethrow;
    }
  }

  String? get userEmail => _supabase.auth.currentUser?.email;

  Future<void> addUserToBase(Customer customer) async {
    try {
      await _supabase.from('users').insert({
        'id': customer.id,
        'name': customer.name,
        'email': customer.email,
        'cart': [],
      });
    } catch (e) {
      debugPrint('Error adding user to database: $e');
      rethrow;
    }
  }

  Future<String> generateUniqueUsername(String fullName) async {
    final SupabaseClient supabase = Supabase.instance.client;

    // Step 1: Make the base username
    String baseUsername = fullName.toLowerCase().replaceAll(' ', '');
    String username = '@$baseUsername';

    // Step 2: Check if username exists
    var existing = await supabase.from('users').select("id").eq('id', username);

    int attempt = 0;
    Random random = Random();

    // Step 3: If exists, add random numbers
    while (existing.isNotEmpty) {
      attempt++;
      int randomNumber = random.nextInt(900) + 100; // 100-999
      username = '@$baseUsername$randomNumber';

      existing =
          await supabase.from('users').select('id').eq('username', username);

      // Safety break if somehow gets stuck
      if (attempt > 20) {
        throw Exception('Failed to generate unique username');
      }
    }

    return username;
  }
}

class Customer {
  final String? id;
  final String? name;
  final String? email;
  final List<Map<String, dynamic>> cart;

  Customer({
    this.id,
    required this.name,
    required this.email,
    this.cart = const [],
  });
}
