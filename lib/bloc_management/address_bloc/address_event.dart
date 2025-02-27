import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatshop/bloc_management/address_bloc/address_bloc.dart';


abstract class AddressEvent extends Equatable{
  @override
  List<Object> get props=>[];
}

class AddAddressEvent extends AddressEvent{
  UserAddress address;
  AddAddressEvent(this.address);
  @override
  List<Object> get props=>[address];
}
class FetchAddressEvent extends AddressEvent{}


class DeleteAddressEvent extends AddressEvent{
  final int index;
  DeleteAddressEvent(this.index);
  @override
  List<Object> get props=>[index];
}

class ShowAddAddressDialog extends AddressEvent{
  final BuildContext context;
  ShowAddAddressDialog(this.context);
}