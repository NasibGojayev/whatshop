import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable{
  @override
  List<Object> get props => [];
}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<Map<String, dynamic>> orders;
  OrderLoaded(this.orders);
  @override
  List<Object> get props => [orders];
}

class OrderError extends OrderState {
  final String error;
  OrderError(this.error);
  @override
  List<Object> get props => [error];
}