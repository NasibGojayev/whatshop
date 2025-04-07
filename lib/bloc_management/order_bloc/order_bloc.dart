import 'package:flutter_bloc/flutter_bloc.dart';

import 'order.event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState>{
  OrderBloc() : super(OrderLoading()){
    on<UpdateOrderEvent>(_onUpdateOrder);
  }

  final List<Map<String, dynamic>> orders = [];


  Future<void> _onUpdateOrder(UpdateOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try{



    }catch(e){
      emit(OrderError("Could not update order: $e"));
    }
  }
}