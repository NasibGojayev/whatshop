import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whatshop/bloc_management/vendor_cubit/vendor_state.dart';

import '../d_product_bloc/d_product_bloc.dart';

class VendorCubit extends Cubit<VendorState> {
  VendorCubit() :super(VendorLoading());


  void fetchVendor(String vendorId) async {
    try {
      if(state is VendorLoaded && (state as VendorLoaded).vendor.vendorId == vendorId){
        print('you have already fetched it');
        return;
      }


      SupabaseClient supabase = Supabase.instance.client;
      final response = await supabase
          .from('vendors')
          .select()
          .eq('vendor_id', vendorId)
          .single();
      Vendor vendor = Vendor.fromJson(response);
      print('Vendor fetched: $vendor');
      emit(VendorLoaded(vendor));

    } catch (e) {
      emit(VendorError('error $e'));
    }
  }
  void fetchVendorProducts(String vendorId) async {
    try {
      SupabaseClient supabase = Supabase.instance.client;

      print('nasib fetch edirem❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️');
      List<Product> products = [];
      final response = await supabase
          .from('products')
          .select().eq('vendor_id', vendorId);
      for(var i in response){
        Product product = getProductFromJson(i);
        products.add(product);
      }
      if(state is VendorLoaded){
        var currentState = state as VendorLoaded;
        emit(VendorLoaded(currentState.vendor.copyWith(products: products)));
      }
    }
    catch(e){
      debugPrint(e.toString());
    }
  }
}





class Vendor {
  final String name;
  final String vendorId;
  final String picPath;
  final String description;
  final String phone;
  final String email;
  final String address;
  final String shopName;
  final String shopImage;
  final List<Product> products;
  Vendor({
    required this.shopImage,
    required this.shopName,
    required this.products,
    required this.address,
    required this.email,
    required this.name,
    required this.vendorId,
    required this.picPath,
    required this.description,
    required this.phone,
});
  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      shopImage: json['shop_image']??'https://archive.org/download/placeholder-image/placeholder-image.jpg',
      shopName: json['shop_name']??'Magaza Adı',
      products: [],
      address: json['address']??'',
      email: json['email']??'',
      name: json['name'],
      vendorId: json['vendor_id'],
      picPath: json['avatar_pic'],
      description: json['description']??'',
      phone: json['phone'],
    );
  }
  Vendor copyWith({
    String? shopImage,
    String? shopName,
    String? name,
    String? vendorId,
    String? picPath,
    String? description,
    String? phone,
    String? email,
    String? address,
    List<Product>? products,
  }) {
    return Vendor(
      shopImage: shopImage??this.shopImage,
      shopName: shopName??this.shopName,
      name: name ?? this.name,
      vendorId: vendorId ?? this.vendorId,
      picPath: picPath ?? this.picPath,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      products: products ?? this.products,
    );
  }
}