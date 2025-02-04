import 'package:flutter/cupertino.dart';
import 'package:whatshop/Auth/auth_repository.dart';
import 'address_event.dart';
import 'address_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBloc extends Bloc<AddressEvent,AddressState>{
  AddressBloc() : super(AddressLoadingState()){
    on<AddAddressEvent>(_onAddAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<FetchAddressEvent>(_onFetchAddress);
    on<ShowAddAddressDialog>(_onShowAddAddressDialog);
  }
  //--------------------------------------------

   List<Map<String,String>> addresses =[];
   User? user;
   String? userId;
   DocumentReference? userDocRef;

  Future<void> _getUserData() async{

      user = await getCurrentUser();
      if(user != null){
        userId = user!.uid;
        userDocRef =  FirebaseFirestore.instance.collection('Users').doc(userId);
      }
      else if(user == null) {
        print('user null du');
      }

  }


  Future<void> _onAddAddress(
      AddAddressEvent event,
      Emitter<AddressState> emit
      )async {
    _getUserData();
    List<Map<String,String>> updatedAddresses = List.from(addresses);
    if(userDocRef == null){
      emit(AddressErrorState("User not logged in"));
      return;
    }

    try{
      updatedAddresses.add({'line1':event.line1,'line2':event.line2,'ad_soyad':event.ad_soyad,'phone_num':event.phone_num});
      addresses = List.from(updatedAddresses);
      /*await userDocRef!.update({
          'addresses':FieldValue.arrayUnion([
            {'line1': event.line1, 'line2': event.line2}
          ])
        });*/
      await userDocRef!.update({'addresses': updatedAddresses});
      emit(AddressLoadedState(updatedAddresses));
      }catch(e){
        print("Error adding address: $e");
        emit(AddressErrorState("error $e"));
      }

  }
  //--------------------------------------------------
  Future<void> _onDeleteAddress(
      DeleteAddressEvent event,
      Emitter<AddressState> emit
      )async {
    _getUserData();
    if( userDocRef == null){
      emit(AddressErrorState("user not logged in"));
    }

    try{
      if(event.index >= 0 && event.index<addresses.length) {
        List<Map<String, String>> updatedAddresses = List.from(addresses);
        updatedAddresses.removeAt(event.index);
        addresses = List.from(updatedAddresses);
        await userDocRef!.update({'addresses': updatedAddresses});

        emit(AddressLoadedState(updatedAddresses));
      }
      else {
        emit(AddressErrorState("Invalid address index"));
      }
    }catch(e){
      emit(AddressErrorState("error deleting the address $e"));
    }
  }
  //--------------------------------------------------
  Future<void> _onFetchAddress(
      FetchAddressEvent event,
      Emitter<AddressState> emit
      ) async{
    emit(AddressLoadingState());
    await _getUserData();
    if(userDocRef==null){
      emit(AddressErrorState("user not logged in"));
      return;
    }
    try{
      final userDocSnapshot = await userDocRef!.get();
      if(userDocSnapshot.exists){
        final userData = userDocSnapshot.data() as Map<String,dynamic>?;
        
        if(userData != null && userData.containsKey('addresses')){
          addresses = (userData['addresses'] as List).map((e)=>Map<String,String>.from(e)).toList();
          emit(AddressLoadedState(addresses));
        }
        else{
          emit(NoAddressState());
        }

      }
      else{
        emit(AddressErrorState('User Document SNP does not exist'));
      }

    }catch(e){
      emit(AddressErrorState("couldn't fetch the address $e"));
    }


  }


  void _onShowAddAddressDialog(
      ShowAddAddressDialog event,
      Emitter<AddressState> emit
      ) {
    TextEditingController ad_soyad = TextEditingController();
    TextEditingController phone_number = TextEditingController();
    TextEditingController addressLine1 = TextEditingController();
    TextEditingController addressLine2 = TextEditingController();

    showCupertinoDialog(
      context: event.context,
      builder: (context) {
        return CupertinoAlertDialog(

          title: Text("Adres əlavə et"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                CupertinoTextField(

                  controller: ad_soyad..text="${user!.displayName}",
                  placeholder: 'Ad Soyad',
                ),
                SizedBox(height: 20),
                CupertinoTextField(
                  controller: phone_number,
                  placeholder: 'Telefon nomresi',
                ),
                SizedBox(height: 20),

                CupertinoTextField(

                  controller: addressLine1,
                  placeholder: 'Adres sətiri 1',
                ),
                SizedBox(height: 20),
                CupertinoTextField(
                  controller: addressLine2,
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
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            CupertinoDialogAction(
              child: Text("Əlavə et"),
              onPressed: () {
                if (addressLine1.text.isNotEmpty) {

                  context.read<AddressBloc>().add(AddAddressEvent(addressLine1.text, addressLine2.text,ad_soyad.text,phone_number.text));
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