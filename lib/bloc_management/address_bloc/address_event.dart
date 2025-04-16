import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatshop/bloc_management/address_bloc/address_bloc.dart';


abstract class AddressEvent extends Equatable{
  @override
  List<Object> get props=>[];
}

class AddAddressEvent extends AddressEvent{
  final UserAddress address;

  AddAddressEvent(this.address);
  @override
  List<Object> get props=>[address];
}
class FetchAddressEvent extends AddressEvent{}
class SelectAddressEvent extends AddressEvent{
  final String addressId;
  SelectAddressEvent(this.addressId);
  @override
  List<Object> get props=>[addressId];
}


class DeleteAddressEvent extends AddressEvent{
  final UserAddress address;
  DeleteAddressEvent(this.address);
  @override
  List<Object> get props=>[address];
}

class ShowAddAddressDialog extends AddressEvent{
  final BuildContext context;
  ShowAddAddressDialog(this.context);
}