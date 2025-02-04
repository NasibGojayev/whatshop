import 'package:firebase_auth/firebase_auth.dart';

/*abstract class UserState extends Equatable{
  @override
  List<Object> get props=>[];
}*/

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