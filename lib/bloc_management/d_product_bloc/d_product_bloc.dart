import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_event.dart';
import 'package:whatshop/bloc_management/d_product_bloc/d_product_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whatshop/tools/variables.dart';
import '../../pages/detailed_product_page.dart';
import '../../tools/colors.dart';
import '../cart_bloc/cart_bloc.dart';
import 'd_product_state.dart';

class ProductIdBloc extends Bloc<ProductIdEvent,ProductIdState>{
  final SupabaseClient supabase; // Injected dependency

  ProductIdBloc(this.supabase) : super(ProductIdLoadingState()) {
    on<FetchProductIdEvent>(_onFetchProductId);
    on<SelectColorEvent>(_onSelectColor);
    on<SelectSizeEvent>(_onSelectSize);
  }

  void _onSelectColor(SelectColorEvent event, Emitter<ProductIdState> emit) {
    final currentState = state;
    if (currentState is ProductIdFetchedState) {
      emit(ProductIdFetchedState(
          product: currentState.product,
          colorOption: ColorOption(
              color: event.color,
              isAvailable: true
          ),
        sizeOption: SizeOption(
            price: currentState.sizeOption.price,
            size: currentState.sizeOption.size,
            isAvailable: currentState.sizeOption.isAvailable)
      ));
    }

  }

  void _onSelectSize(SelectSizeEvent event, Emitter<ProductIdState> emit) {
    final currentState = state;
    if (currentState is ProductIdFetchedState) {
      print("${currentState.sizeOption.size} before");
      emit(ProductIdFetchedState(
          product: currentState.product,
          colorOption: ColorOption(
              color: currentState.colorOption.color,
              isAvailable: currentState.colorOption.isAvailable
          ),
          sizeOption: SizeOption(
              price: event.price,
              size: event.size,
              isAvailable: true)
      ));
      print("${currentState.sizeOption.size} after");


    }
  }



  Future<void> _onFetchProductId(
      FetchProductIdEvent event,
      Emitter<ProductIdState> emit
      )async{
    emit(ProductIdLoadingState());
    try {
      final item = await supabase
          .from('products')
          .select()
          .eq('product_id', event.productId)
          .single();

      Product product = getProductFromJson(item);
      emit(ProductIdFetchedState(
          product: product,
          colorOption: ColorOption(
              color: '',
              isAvailable: false
          ),

          sizeOption: SizeOption(
              price: product.sizeOptions[0].price,
              size: '',
              isAvailable: product.sizeOptions[0].isAvailable
          )
      ));
    } catch (e) {
      emit(ProductIdErrorState(e.toString()));
    }

  }


 }

class Product{
  final String productId;
  final String category;
  final String name;
  final String description;
  final List<SizeOption> sizeOptions;
  final List<String> images;
  final List<ColorOption> colorOptions;

  Product({
    required this.colorOptions,
    required this.images,
    required this.productId,
    required this.category,
    required this.name,
    required this.description,
    required this.sizeOptions,
  });


}

class ColorOption{
  final String color;
  final bool isAvailable;

  ColorOption({
    required this.color,
    required this.isAvailable,
});
}

class SizeOption{
  final String size;
  final double price;
  final bool isAvailable;

  SizeOption({
    required this.price,
    required this.size,
    required this.isAvailable,
});
}


Product getProductFromJson(var item){
  return Product(

    colorOptions: item['colors'].map<ColorOption>((color) {
      return ColorOption(
          color: color['color'] as String,
          isAvailable: color['isAvailable'] as bool);
    }).toList(),

    images: item['pic_path'].cast<String>(),
    productId: item['product_id'],
    category: item['category'],
    name: item['name'],
    description: item['description'],
    sizeOptions: item['size_price'].map<SizeOption>((size) {
      return SizeOption(
          size: size['size'] as String,
          price: size['price'].toDouble(),
          isAvailable: size['isAvailable'] as bool
      );
    }).toList(),
  );
}

void chooseOpts(BuildContext context,String productId){
  context.read<ProductIdBloc>().add(FetchProductIdEvent(productId));
  showModalBottomSheet(

    isScrollControlled: false,

    context: context,

    builder: (BuildContext context) {

      return Container(
        width: getWidthSize(context),
        padding: EdgeInsets.all(16),
        height: 1200,
        child: BlocBuilder<ProductIdBloc,ProductIdState>(
            builder: (context,state) {
              if(state is ProductIdFetchedState){
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Qiymet: ${state.sizeOption.price} AZN',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Container(
                        width: getWidthSize(context),
                        height: 100,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (var i in state.product.images)
                                Container(
                                  child: Image.network(i),
                                )
                            ])),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Olcu Secin',
                    ),
                    SizedBox(height: 5,),
                    SizedBox(
                      width: getWidthSize(context),
                      height: 30,
                      child:
                      Wrap(spacing: 10, runSpacing: 20, children: [
                        for (var i in state.product.sizeOptions)
                          GestureDetector(
                            onTap: (){
                              context.read<ProductIdBloc>().add(SelectSizeEvent(size: i.size,price:i.price));
                            },
                            child: Container(
                                width: 100,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(

                                    color: state.sizeOption.size == i.size?mainGreen:Colors.white,
                                    border: Border.all(
                                      color: state.sizeOption.size == i.size?mainGreen:Colors.black,
                                      width: 1,

                                    )
                                ),
                                margin: EdgeInsets.only(left: 20),
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 14,vertical: 5),
                                    child: Text(i.size,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: state.sizeOption.size == i.size?Colors.white:Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                )),
                          )
                      ]),
                    ),
                    SizedBox(height: 10,),

                    Text(
                      'Reng Secin',
                    ),
                    SizedBox(height: 5,),
                    SizedBox(
                      width: getWidthSize(context),
                      height: 30,
                      child:
                      Wrap(spacing: 10, runSpacing: 20, children: [
                        for (var i in state.product.colorOptions)
                          GestureDetector(
                            onTap: (){
                              context.read<ProductIdBloc>().add(SelectColorEvent(color: i.color));
                            },
                            child: Container(
                                width: 100,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(

                                    color: state.colorOption.color == i.color?mainGreen:Colors.white,
                                    border: Border.all(
                                      color: state.colorOption.color == i.color?mainGreen:Colors.black,
                                      width: 1,

                                    )
                                ),
                                margin: EdgeInsets.only(left: 20),
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 14,vertical: 5),
                                    child: Text(i.color,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: state.colorOption.color == i.color?Colors.white:Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                )),
                          )
                      ]),
                    ),
                    SizedBox(height: 14),
                    Container(
                      height: 55,
                      width: getWidthSize(context)*0.95,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: (){

                            if(state.colorOption.color=='' || state.sizeOption.size=='') {
                              return;
                            }
                            else{

                              context.read<CartBloc>().add(AddCartEvent(
                                product: state.product,
                                colorOption: state.colorOption,
                                sizeOption: state.sizeOption,
                              ));
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Mehsul sebete elave olundu !'), // The message to display
                                  duration: Duration(
                                      milliseconds:
                                      2300), // How long to show the snackbar (optional)
                                  action: SnackBarAction(
                                    // An optional action button
                                    label: 'Sebete get',
                                    onPressed: () {
                                      context.go('/cart');
                                    },
                                  ),
                                ),
                              ); // The message to display
                            }
                          },
                          child: Container(
                            color: primaryColor,
                            child: Center(child: Text('Səbətə at',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                          ),
                        ),
                      ),
                    ),

                  ],
                );
              }

              else{
                print(state);
                return CircularProgressIndicator();
              }
            }
        ),
      );

    },
  );
}
