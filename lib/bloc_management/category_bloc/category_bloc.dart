import 'package:flutter_bloc/flutter_bloc.dart';
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

      final json = await Supabase.instance.client.from('categories').select("*").order('id',ascending: true);

      final categories = json.map((e) => CategoryObject.fromJson(e)).toList();

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

class CategoryObject{
  final String id;
  final String name;
  final String description;
  final String image;

  const CategoryObject({required this.description,required this.image,required this.id,required this.name});

  factory CategoryObject.fromJson(Map<String,dynamic> json){
    return CategoryObject(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['iconPath'],
    );
  }

}