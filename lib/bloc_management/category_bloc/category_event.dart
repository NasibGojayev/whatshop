import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable{
  const CategoryEvent();
  @override
  List<Object?> get props =>[];

}

// event to fetch categories from the firebase

class FetchCategories extends CategoryEvent{}

class SetSelectedIndex extends CategoryEvent{
  final int newIndex;

  const SetSelectedIndex(this.newIndex);

  @override
  List<Object?> get props => [newIndex];

}