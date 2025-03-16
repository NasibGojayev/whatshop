import 'package:equatable/equatable.dart';
import 'package:whatshop/bloc_management/address_bloc/address_bloc.dart';

abstract class AddressState extends Equatable{
  @override
  List<Object> get props=>[];
}

class AddressLoadingState extends AddressState{}


class AddressLoadedState extends AddressState{
  final List<UserAddress> addresses;
  final String selectedAddressId;
  AddressLoadedState(this.addresses,this.selectedAddressId);
  @override
  List<Object> get props=>[addresses,selectedAddressId];
}

class AddressEmptyState extends AddressState{}

class NoAddressState extends AddressState{}

class AddressErrorState extends AddressState{
  final String error;
  AddressErrorState(this.error);
  @override
  List<Object> get props=>[error];
}