/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop/bloc_management/auth_bloc/auth_event.dart';
import 'package:whatshop/bloc_management/auth_bloc/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Auth/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthStates> {
  AuthBloc() : super(AuthLoadingState()) {
    on<SignInEmailPasswordEvent>(_onSignInEmailPassword);
    on<SignUpEmailPasswordEvent>(_onSignUpEmailPassword);
    on<SignOutEvent>(_onSignOut);
  }


  final SupabaseClient _supabase = Supabase.instance.client;
  bool get isSignedIn => _supabase.auth.currentSession != null;
  set isSignedIn(bool newValue) {
    isSignedIn = newValue;
  }

  Future<AuthResponse> _onSignUpEmailPassword(SignUpEmailPasswordEvent event,
      Emitter<AuthStates> emit) async {
    try {
      emit(AuthLoadingState());
      // Clear any existing session first
      await _supabase.auth.signOut();

      final response = await _supabase.auth.signInWithPassword(
        email: event.email,
        password: event.password,
      );

      if (response.user == null) {
        throw Exception('Sign-in failed: No user returned');
      }

      return response;
    } catch (e) {
      emit(AuthFailedState(e.toString()));
      rethrow;
    }
  }

  Future<AuthResponse> _onSignInEmailPassword(SignInEmailPasswordEvent event,
      Emitter<AuthStates> emit) async {
    try {
      // Clear any existing session first
      await _supabase.auth.signOut();

      final response = await _supabase.auth.signInWithPassword(
        email: event.email,
        password: event.password,
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

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthStates> emit) async {
    try {
      await _supabase.auth.signOut();
      // Clear any local cache if needed
    } catch (e) {
      debugPrint('SignOut error: $e');
      rethrow;
    }
  }

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

  bool isHidden =true;
  void toggleHidden(){
    isHidden = !isHidden;
  }

}


*/
