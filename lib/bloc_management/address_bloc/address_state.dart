import 'package:equatable/equatable.dart';

abstract class AddressState extends Equatable{
  @override
  List<Object> get props=>[];
}

class AddressLoadingState extends AddressState{}


class AddressLoadedState extends AddressState{
  final List<Map<String,dynamic>> addresses;
  AddressLoadedState(this.addresses);
  @override
  List<Object> get props=>[addresses];
}

class AddressEmptyState extends AddressState{}

class NoAddressState extends AddressState{}

class AddressErrorState extends AddressState{
  final String error;
  AddressErrorState(this.error);
  @override
  List<Object> get props=>[error];
}