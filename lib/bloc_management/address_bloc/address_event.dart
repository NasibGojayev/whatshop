import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


abstract class AddressEvent extends Equatable{
  @override
  List<Object> get props=>[];
}

class AddAddressEvent extends AddressEvent{
  final String ad_soyad;
  final String phone_num;
  final String line1;
  final String line2;
  AddAddressEvent(this.line1,this.line2,this.ad_soyad,this.phone_num);
  @override
  List<Object> get props=>[line1,line2,ad_soyad,phone_num];
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