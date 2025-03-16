import 'package:bloc/bloc.dart';
import 'category_event.dart';
import 'category_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryBloc extends Bloc<CategoryEvent,CategoryState>{
  CategoryBloc() : super(CategoryInitial()){
    on<FetchCategories>(_onFetchCategories);
    on<SetSelectedIndex>(_onSetSelectedIndex);
  }

  Future<void> _onFetchCategories(
      FetchCategories event, Emitter<CategoryState> emit) async{
    emit(CategoryLoading()); //emit loading state

    try{
      /*final categorySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      final categories = categorySnapshot.docs.map((doc){
        return{
          'id' : doc.id,
          'name' : doc["name"],
          'description':doc['description'],
          'iconPath' : doc['iconPath']
        };
      }).toList();*/

      final categories = await Supabase.instance.client.from('categories').select("*").order('id',ascending: true);

      print('fetched the categories');

      emit(CategoryLoaded(categories,0));
    }catch(error){
      emit(CategoryError('Error fetching categories: $error'));
    }
  }

  void _onSetSelectedIndex(
      SetSelectedIndex event ,Emitter<CategoryState> emit){
    final currentState = state;
    if(currentState is CategoryLoaded){
      emit(CategoryLoaded(currentState.categories, event.newIndex));
    }
  }
}