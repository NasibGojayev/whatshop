import 'user_event.dart';
import 'user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      print('started fetching');
      User? user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(UserError("User not logged in"));
        return;
      }
       // Fetch from repository
      emit(UserLoaded(user)); // Set state to loaded with the user data
        } catch (e) {
      emit(UserError("Error fetching user: $e"));
    }
  }
}