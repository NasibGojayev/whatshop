/*
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_event.dart';
import 'product_state.dart';



/////////////// this is the project on firebase i have just made the copy of the product bloc, from now on i will use supabase.

class CopyProductBloc extends Bloc<ProductEvent,ProductState>{
  CopyProductBloc() : super(ProductLoadingState()) {
    //on<FetchProductsEvent>(_onFetchProducts);
    on<FetchNextProductsEvent>(_onFetchNextProducts);
    on<FetchByCategoryEvent>(_onFetchByCategory);
  }


  final Map<String,List<Map<String,dynamic>>> _productsByCategory={};

  final Map<String, DocumentSnapshot?> _lastDocument = {};

  final Map<String,bool> _hasMore  = {}; // Track if more products are available




  Future<void> _onFetchByCategory(
      FetchByCategoryEvent event,
      Emitter<ProductState> emit
      ) async{

    emit(ProductLoadingState());




    if (_productsByCategory.containsKey(event.categoryId)) { // Safer check
      final cachedProducts = _productsByCategory[event.categoryId]!;
      if (cachedProducts.isNotEmpty) { // Check if there are any cached products
        emit(ProductLoadedState(cachedProducts)); // Load from cache
        return; // Important: Stop here if you used the cache
      }
    }

    try{
      final QuerySnapshot snapshot;
      if(event.categoryId=="0"){
        snapshot = await FirebaseFirestore.instance
            .collection('products')
            .orderBy('created_at', descending: true)
            .limit(14)
            .get();

      }

      else{
        print(event.categoryId);
        snapshot = await FirebaseFirestore.instance.collection('products')
            .where('category',isEqualTo: event.categoryId)
            .orderBy('created_at', descending: true)
            .limit(14)
            .get();
      }

      _productsByCategory.putIfAbsent(event.categoryId, ()=>[]);
      _productsByCategory[event.categoryId]!.addAll(snapshot.docs.map((doc)=>doc.data() as Map<String,dynamic>).toList());

      if (snapshot.docs.isNotEmpty) {
        _lastDocument[event.categoryId] = snapshot.docs.last;
      } else {
        _lastDocument[event.categoryId] = null; // Important: Reset last document if no data
        emit(EndOfProductsState()); // Emit EndOfProducts if there's no data
        return; // Stop here if there is no data
      }

      _lastDocument[event.categoryId] = snapshot.docs.last;
      emit(ProductLoadedState(_productsByCategory[event.categoryId]!));
    }catch(error){
      emit(ProductErrorState('Error Fetching the products : $error'));
    }
  }

  Future<void> _onFetchNextProducts(
      FetchNextProductsEvent event,
      Emitter<ProductState> emit
      ) async{

    emit(ProductLoadingState());

    final categoryId = event.categoryId;

    if (!_hasMore.containsKey(categoryId) || !_hasMore[categoryId]! || _lastDocument[categoryId] == null) {
      emit(EndOfProductsState()); // No more products to fetch for this category
      return;
    }

    emit(ProductPaginatingState(List.from(_productsByCategory[categoryId]!))); // Correct list



    try{
      final QuerySnapshot snapshot;
      if(event.categoryId=="0"){
        snapshot = await FirebaseFirestore.instance
            .collection('products')
            .orderBy('created_at', descending: true)
            .startAfterDocument(_lastDocument[categoryId]!)
            .limit(14)
            .get();

      }

      else{
        print(event.categoryId);
        snapshot = await FirebaseFirestore.instance.collection('products')
            .where('category',isEqualTo: event.categoryId)
            .orderBy('created_at', descending: true)
            .startAfterDocument(_lastDocument[categoryId]!)
            .limit(14)
            .get();
      }


      if (snapshot.docs.isEmpty) {
        _hasMore[categoryId] = false;
        emit(EndOfProductsState());
      }
      _productsByCategory.putIfAbsent(event.categoryId, ()=>[]);
      _productsByCategory[event.categoryId]!.addAll(snapshot.docs.map((doc)=>doc.data() as Map<String,dynamic>).toList());
      _lastDocument[categoryId] = snapshot.docs.last;
      emit(ProductLoadedState(_productsByCategory[event.categoryId]!));
    }catch(error){
      emit(ProductErrorState('Error Fetching more products : $error'));
    }
  }





}*/
