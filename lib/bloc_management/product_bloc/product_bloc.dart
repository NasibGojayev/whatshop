import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent,ProductState>{
  ProductBloc() : super(ProductLoadingState()) {
    on<FetchProductsEvent>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event,
      Emitter<ProductState> emit
      ) async{
    emit(ProductLoadingState());
    try{
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').limit(14).get();
      final products = snapshot.docs;
      emit(ProductLoadedState(products));
    }catch(error){
      emit(ProductErrorState('Error Fetching the products : $error'));
    }
  }




}