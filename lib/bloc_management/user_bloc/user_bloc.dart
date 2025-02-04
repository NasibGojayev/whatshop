import '../../Auth/auth_repository.dart';
import 'user_event.dart';
import 'user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent,UserState>{
  UserBloc() : super(UserLoading()) {
    on<FetchUserEvent>(_onUserFetch);
  }

  Future<void> _onUserFetch(
      FetchUserEvent event,
      Emitter<UserState> emit
      ) async{
    emit(UserLoading()); // Set state to loading
    try {
      final user = await getCurrentUser(); // Fetch from repository
      if (user != null) {
        emit(UserLoaded(user)); // Set state to loaded with the user data
      } else {
        emit(UserError("User not found")); // Handle null user
      }
    } catch (e) {
      emit(UserError("Error fetching user: $e"));
    }
  }
}