import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class UpdateOrderEvent extends OrderEvent {
  final String orderId;
  UpdateOrderEvent(this.orderId);
  @override
  List<Object> get props => [orderId];

}
