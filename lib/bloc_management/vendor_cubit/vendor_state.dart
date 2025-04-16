import 'package:equatable/equatable.dart';
import 'package:whatshop/bloc_management/vendor_cubit/vendor_cubit.dart';

abstract class VendorState extends Equatable{
  const VendorState();
  @override
  List<Object> get props => [];
}

class VendorLoading extends VendorState{}

class VendorLoaded extends VendorState{
  final Vendor vendor;
  const VendorLoaded(this.vendor);
  @override
  List<Object> get props => [vendor];
}
class VendorError extends VendorState{
  final String error;
  const VendorError(this.error);
  @override
  List<Object> get props => [error];
}


