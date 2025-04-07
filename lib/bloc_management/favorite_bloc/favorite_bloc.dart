import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../d_product_bloc/d_product_bloc.dart';
import 'favorite_events.dart';
import 'favorite_states.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteStates>{
  FavoriteBloc() : super(FavoriteUpdatedState([])){
    on<CaptureProductsEvent>(_onProductsCaptured);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);

  }

  final Map<String,GlobalKey> _imageKeys = {};//// Store keys for each product
  List<Product> _favoriteProducts = [];
  void initializeKeys() {
    _imageKeys.clear(); // Clear existing keys
  }

  void _onToggleFavorite(
      ToggleFavoriteEvent event,
      Emitter<FavoriteStates> emit
      ){
    final updatedFavorites = List<Product>.from(_favoriteProducts);
    if(updatedFavorites.contains(event.product)){
      updatedFavorites.remove(event.product);
    }
    else{
      updatedFavorites.add(event.product);
    }
    _favoriteProducts = updatedFavorites;
    emit(FavoriteUpdatedState(updatedFavorites));
  }

  void _onRemoveFavorite(
      RemoveFavoriteEvent event,
      Emitter<FavoriteStates> emit
      ){

    _favoriteProducts.removeWhere((product) => product.productId == event.productId);
    emit(FavoriteLoadingState());
    emit(FavoriteUpdatedState(_favoriteProducts));
  }


  void _onProductsCaptured(
      CaptureProductsEvent event,
      Emitter<FavoriteStates> emit) async{
    emit(ShareLoadingState(_favoriteProducts));
    List<XFile> files = [];
    List<Future<void>> tasks = []; // Bütün asinxron əməliyyatları saxlamaq üçün

    for (var product in _favoriteProducts) {
      List<String> productImages = (product.images as List<dynamic>).cast<String>();

      for (int j = 0; j < productImages.length; j++) {
        final String uniqueId = '${product.productId}_$j';


        final GlobalKey key  = getKey(uniqueId);

        // Asinxron render prosesini tasks listinə əlavə edirik
        tasks.add(_captureImage(key, product.productId, j, files));
      }
    }
    // Bütün şəkillər render olunana qədər gözləyirik
    await Future.wait(tasks);


    if (files.isNotEmpty) {
      await Share.shareXFiles(files, text: 'Seçdiyiniz məhsullar:').then((_) {
        emit(FavoriteUpdatedState(_favoriteProducts)); // Ensure UI updates after sharing
      }).catchError((error) {
        print("Share cancelled or failed: $error");
        emit(ShareFailure('$error cancelled or failed'));
      });
    } else {
      print("No files were captured.");
      emit(ShareFailure('no files were captured.'));
    }




  }

  GlobalKey getKey(
      String uniqueId,){
    if (!_imageKeys.containsKey(uniqueId)) {

      _imageKeys[uniqueId] = GlobalKey(); // Create a new key if it doesn't exist
      //print('now here creating a new $uniqueId one puahahah ${_imageKeys[uniqueId]}');
    }
    return _imageKeys[uniqueId]!;


  }

  Future<void> _captureImage(GlobalKey key, String productId, int index, List<XFile> files) async {

    RenderRepaintBoundary? boundary =
    key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      print("Error: RenderRepaintBoundary is null for product $productId image $index");
      return;
    }
    ui.Image image = await boundary.toImage(pixelRatio: 12);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      print("Error: byteData is null for product $productId image $index");
      return;
    }
    Uint8List pngBytes = byteData.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/${productId}_$index.png').create();
    await file.writeAsBytes(pngBytes);
    files.add(XFile(file.path));
  }






}