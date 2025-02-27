import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable{

  const CategoryState();
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState{}

class CategoryLoading extends CategoryState{}

class CategoryLoaded extends CategoryState{

  final List<Map<String,dynamic>> categories;
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