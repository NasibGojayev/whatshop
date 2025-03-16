import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductBloc extends Bloc<ProductEvent,ProductState>{
  ProductBloc() : super(ProductLoadingState()) {
    on<FetchNextProductsEvent>(_onFetchNextProducts);
    on<FetchByCategoryEvent>(_onFetchByCategory);
  }


  final Map<String,List<Map<String,dynamic>>> _productsByCategory={};






  Future<void> _onFetchByCategory(
      FetchByCategoryEvent event,
      Emitter<ProductState> emit
      ) async{

    emit(ProductLoadingState());




    if (!event.forceRefresh && _productsByCategory.containsKey(event.categoryId)) { // Safer check
      final cachedProducts = _productsByCategory[event.categoryId]!;
      if (cachedProducts.isNotEmpty) { // Check if there are any cached products
        emit(ProductLoadedState(cachedProducts)); // Load from cache
        return; // Important: Stop here if you used the cache
      }
    }

    try{

      _productsByCategory.clear();

      final supabase =  Supabase.instance.client;
      final List<Map<String,dynamic>> _products ;

      if(event.categoryId=='0'){
         _products = await supabase
            .from('products')
            .select()
            .limit(14);
      }
      else{
         _products = await supabase
            .from('products')
            .select().eq('category',event.categoryId)
            .limit(14);

      }




      _productsByCategory.putIfAbsent(event.categoryId, ()=>[]);

      _productsByCategory[event.categoryId]!.addAll(_products);
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

    emit(ProductPaginatingState(List.from(_productsByCategory[categoryId]!))); // Correct list



    try{
      final supabase =  Supabase.instance.client;
      final List<Map<String,dynamic>> _products ;
      print(categoryId);

      if(categoryId=='0'){
         _products = await supabase
            .from('products')
            .select()
            .limit(14);
      }
      else{
         _products = await supabase
            .from('products')
            .select().eq('category',categoryId)
            .limit(14);

      }




      _productsByCategory.putIfAbsent(event.categoryId, ()=>[]);

      _productsByCategory[event.categoryId]!.addAll(_products);

      emit(ProductLoadedState(_productsByCategory[event.categoryId]!));

    }catch(error){
      emit(ProductErrorState('Error Fetching more products : $error'));
    }
  }

}