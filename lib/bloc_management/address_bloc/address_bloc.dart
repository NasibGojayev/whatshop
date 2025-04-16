import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'address_event.dart';
import 'address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressLoadingState()) {
    on<AddAddressEvent>(_onAddAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<FetchAddressEvent>(_onFetchAddress);
    on<ShowAddAddressDialog>(_onShowAddAddressDialog);
    on<SelectAddressEvent>(_onSelectAddress);
    init();
  }

  List<UserAddress> addresses = [];
  String selectedAddressId = 'non';
  User? user;
  String? userId;
  late SupabaseClient _supabase;

  String generateShortUuid(String user) {
    var uuid =  Uuid();
    String code = '$user${uuid.v4().substring(0, 5).toUpperCase()}'; // Take first 7 chars

    return code;
  }

  void init() {
    _supabase = Supabase.instance.client;
    user = _supabase.auth.currentUser;
    userId = user?.id;
  }

  void _onSelectAddress(
      SelectAddressEvent event,
      Emitter<AddressState> emit,
      ){
    emit(AddressLoadedState(addresses,event.addressId));
  }

  // Function to store address in Hive
  Future<void> _onAddAddress(
      AddAddressEvent event,
      Emitter<AddressState> emit,
      ) async {
    if (userId == null) return;

    var box = Hive.box('userAddresses');

    // Retrieve existing addresses
    List<Map<String, dynamic>> storedAddresses = addresses.map((address) => address.toMap()).toList();

    // Add the new address to the list
    storedAddresses.add(event.address.toMap());
    await box.put(userId, storedAddresses);

    // Update state
    addresses = storedAddresses.map((e) => UserAddress.fromMap(e)).toList();
    emit(AddressLoadedState(List.from(addresses),selectedAddressId));
  }

  // Function to delete all addresses
  Future<void> _onDeleteAddress(
      DeleteAddressEvent event,
      Emitter<AddressState> emit,
      ) async {
    try {
      var box = Hive.box('userAddresses');

      // Retrieve existing addresses
      List<Map<String, dynamic>> storedAddresses = addresses.map((address) => address.toMap()).toList();

      // delete the address from the list
      storedAddresses.removeWhere((element) => element['address_id'] == event.address.addressId);

      await box.put(userId, storedAddresses);

      // Update state
      addresses = storedAddresses.map((e) => UserAddress.fromMap(e)).toList();
      emit(AddressLoadedState(List.from(addresses),selectedAddressId));
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

    try {
      var box = Hive.box('userAddresses');


      List<UserAddress> updatedAddresses = [];

      if (box.containsKey(userId)) {
        for (var e in box.get(userId)) {
          var address = UserAddress.fromMap(e);
          updatedAddresses.add(address);
        }
      }
      else{
        emit(NoAddressState());
        return;

      }
      addresses = updatedAddresses;
      emit(AddressLoadedState(addresses,selectedAddressId));

    } catch (e) {
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
                  controller: adSoyadController,
                  placeholder: 'Ad Soyad',
                ),
                SizedBox(height: 10),
                CupertinoTextField(
                  controller: phoneNumberController,
                  placeholder: 'Telefon nömrəsi',
                  keyboardType: TextInputType.phone,
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
                if (adSoyadController.text.isEmpty ||
                    phoneNumberController.text.isEmpty ||
                    addressLine1Controller.text.isEmpty) {
                  return;
                }

                UserAddress address = UserAddress(
                  addressId: generateShortUuid('ws'),
                  nameSurname: adSoyadController.text,
                  line1: addressLine1Controller.text,
                  line2: addressLine2Controller.text,
                  phoneNum: phoneNumberController.text,
                );

                context.read<AddressBloc>().add(AddAddressEvent(address));
                Navigator.of(context).pop();
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
  String addressId;
  final String nameSurname;
  final String line1;
  final String line2;
  final String phoneNum;

  UserAddress({
    required this.addressId,
    required this.nameSurname,
    required this.line1,
    required this.line2,
    required this.phoneNum,
  });

  // Convert object to Map (for Hive storage)
  Map<String, dynamic> toMap() {
    return {
      'address_id': addressId,
      'name': nameSurname,
      'line1': line1,
      'line2': line2,
      'phone_num': phoneNum,
    };
  }

  // Convert Map to UserAddress (for Hive retrieval)
  factory UserAddress.fromMap(Map<dynamic, dynamic> map) {
    return UserAddress(
      addressId: map['address_id'] ?? '',
      nameSurname: map['name'] ?? '',
      line1: map['line1'] ?? '',
      line2: map['line2'] ?? '',
      phoneNum: map['phone_num'] ?? '',
    );
  }
}
