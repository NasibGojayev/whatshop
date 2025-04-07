import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectBloc extends Bloc<SelectEvent, SelectState>{
  SelectBloc() : super(SelectInitial()){
    on<SelectColorEvent>(_onSelectColor);
  }

  void _onSelectColor(SelectColorEvent event, Emitter<SelectState> emit) {

  }
}
//---------------------------
class SelectEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class SelectColorEvent extends SelectEvent{
  final String color;
  SelectColorEvent(this.color);
  @override
  List<Object?> get props => [color];
}

class SelectSizeEvent extends SelectEvent{
  final String size;
  SelectSizeEvent(this.size);
  @override
  List<Object?> get props => [size];
}



//--------------------------------------
class SelectState extends Equatable{
  @override
  List<Object?> get props => [];
}

class SelectInitial extends SelectState{}

class SelectingState extends SelectState {
  final String selectedColor;
  final String selectedSize;
  SelectingState(this.selectedColor, this.selectedSize);
  @override
  List<Object?> get props => [selectedColor, selectedSize];

}