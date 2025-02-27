

import 'package:whatshop/Auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user; // Use your Customer class
  UserLoaded(this.user);
}
class UserError extends UserState {
  final String error;
  UserError(this.error);
}