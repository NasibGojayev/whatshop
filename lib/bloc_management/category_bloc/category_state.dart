import 'package:equatable/equatable.dart';
import 'package:whatshop/bloc_management/category_bloc/category_bloc.dart';

abstract class CategoryState extends Equatable{

  const CategoryState();
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState{}

class CategoryLoading extends CategoryState{}

class CategoryLoaded extends CategoryState{

  final List<CategoryObject> categories;
  final int selectedIndex;
  const CategoryLoaded(this.categories,this.selectedIndex);

  @override

  List<Object?> get props => [categories,selectedIndex];
}

class CategoryError extends CategoryState{

  final String message;
  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}