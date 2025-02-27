import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'address_event.dart';
import 'address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop/Auth/auth_service.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressLoadingState()) {
    on<AddAddressEvent>(_onAddAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<FetchAddressEvent>(_onFetchAddress);
    on<ShowAddAddressDialog>(_onShowAddAddressDialog);
  }

  List<Map<String, dynamic>> addresses = [];




String? userId = AuthService().cachedUser?.id;
  // Function to store address in Hive
  Future<void> _onAddAddress(
      AddAddressEvent event,
      Emitter<AddressState> emit,
      ) async {

    if (userId == null) return;

    List<Map<String, dynamic>> updatedAddresses = List.from(addresses);
    var box = Hive.box('userAddresses');

    // Store address in Hive
    await box.put(userId, event.address.toMap());
    updatedAddresses.add(event.address.toMap());

    emit(AddressLoadedState(updatedAddresses));
    addresses = List.from(updatedAddresses);
  }

  // Function to delete address
  Future<void> _onDeleteAddress(
      DeleteAddressEvent event,
      Emitter<AddressState> emit,
      ) async {
    if (userId == null) return;

    try {
      var box = Hive.box('userAddresses');
      await box.delete(userId);
      emit(NoAddressState());
    } catch (e) {
      emit(AddressErrorState("Error deleting address: $e"));
    }
  }

  // Function to fetch addresses
  Future<void> _onFetchAddress(
      FetchAddressEvent event,
      Emitter<AddressState> emit,
      ) async {
    emit(AddressLoadingState());

    if (userId == null) return;

    try {
      final List<Map<String, dynamic>> updatedAddresses = List.from(addresses);
      var box = Hive.box('userAddresses');

      if (box.containsKey(userId)) {
        final Map<String, dynamic> addressData = Map<String, dynamic>.from(box.get(userId));
        final UserAddress address = UserAddress.fromMap(addressData);
        updatedAddresses.add(address.toMap());

        addresses = List.from(updatedAddresses);
        emit(AddressLoadedState(updatedAddresses));
      } else {
        emit(NoAddressState());
      }
    } catch (e) {
      print(e);
      emit(AddressErrorState("Couldn't fetch the address: $e"));
    }
  }

  // Function to show the Add Address dialog
  void _onShowAddAddressDialog(
      ShowAddAddressDialog event,
      Emitter<AddressState> emit,
      ) {
    TextEditingController adSoyadController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController addressLine1Controller = TextEditingController();
    TextEditingController addressLine2Controller = TextEditingController();

    showCupertinoDialog(
      context: event.context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Adres əlavə et"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                CupertinoTextField(
                  controller: adSoyadController..text ,
                  placeholder: 'Ad Soyad',
                ),
                SizedBox(height: 10),
                CupertinoTextField(
                  controller: phoneNumberController,
                  placeholder: 'Telefon nömrəsi',
                ),
                SizedBox(height: 10),
                CupertinoTextField(
                  controller: addressLine1Controller,
                  placeholder: 'Adres sətiri 1',
                ),
                SizedBox(height: 10),
                CupertinoTextField(
                  controller: addressLine2Controller,
                  placeholder: 'Adres sətiri 2',
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('İmtina et'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text("Əlavə et"),
              onPressed: () {
                if (addressLine1Controller.text.isNotEmpty) {
                  UserAddress address = UserAddress(
                    nameSurname: adSoyadController.text,
                    line1: addressLine1Controller.text,
                    line2: addressLine2Controller.text,
                    phoneNum: phoneNumberController.text,
                  );
                  context.read<AddressBloc>().add(AddAddressEvent(address));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

// Model for UserAddress
class UserAddress {
  final String nameSurname;
  final String line1;
  final String line2;
  final String phoneNum;

  UserAddress({
    required this.nameSurname,
    required this.line1,
    required this.line2,
    required this.phoneNum,
  });

  // Convert object to Map (for Hive storage)
  Map<String, dynamic> toMap() {
    return {
      'name': nameSurname,
      'line1': line1,
      'line2': line2,
      'phone_num': phoneNum,
    };
  }

  // Convert Map to UserAddress (for Hive retrieval)
  factory UserAddress.fromMap(Map<String, dynamic> map) {
    return UserAddress(
      nameSurname: map['name'] ?? '',
      line1: map['line1'] ?? '',
      line2: map['line2'] ?? '',
      phoneNum: map['phone_num'] ?? '',
    );
  }
}
