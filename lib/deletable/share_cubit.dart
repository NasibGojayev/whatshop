/*
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareCubit extends Cubit<List<XFile>> {
  ShareCubit() : super([]);

  final Map<String,GlobalKey> _imageKeys = {}; // Store keys for each product

  void initializeKeys(List<Map<String, dynamic>> favoriteState) {
    _imageKeys.clear(); // Clear existing keys
  }

  GlobalKey getKey(String uniqueId) {

    if (!_imageKeys.containsKey(uniqueId)) {

      _imageKeys[uniqueId] = GlobalKey(); // Create a new key if it doesn't exist
      //print('now here creating a new $uniqueId one puahahah ${_imageKeys[uniqueId]}');
    }
    return _imageKeys[uniqueId]!;
  }

  */
/*Future<void> captureProducts(List<Map<String, dynamic>> favoriteState) async {
    List<XFile> files = [];

    for (int i = 0; i < favoriteState.length; i++) {
      var product = favoriteState[i];
      List<String> productImages = (product['pic_path'] as List<dynamic>).cast<String>();

      for (int j = 0; j < productImages.length; j++) {
        final String uniqueId = '${product['product_id']}_$j';
        final GlobalKey key = getKey(uniqueId);

        // Use addPostFrameCallback to ensure widget is fully rendered
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          RenderRepaintBoundary? boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

          if (boundary == null) {
            print("Error: RenderRepaintBoundary is null for product ${product['name']} $i image $j");
            return;
          }

          ui.Image image = await boundary.toImage(pixelRatio: 13.0);
          ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

          if (byteData == null) {
            print("Error: byteData is null for product $i");
            return;
          }

          Uint8List pngBytes = byteData.buffer.asUint8List();
          final tempDir = await getTemporaryDirectory();
          final file = await File('${tempDir.path}/${product['product_id']}_$j.png').create();
          await file.writeAsBytes(pngBytes);
          files.add(XFile(file.path));

          // After all files are captured, share them
          if (files.length == favoriteState.length * productImages.length) {
            emit(files); // Update state with captured images
            if (files.isNotEmpty) {
              await Share.shareXFiles(files, text: 'Seçdiyiniz məhsullar:');
            } else {
              print("No files were captured.");
            }
          }
        });
      }
    }
  }*//*

  Future<void> captureProducts(List<Map<String, dynamic>> favoriteState) async {
    List<XFile> files = [];
    List<Future<void>> tasks = []; // Bütün asinxron əməliyyatları saxlamaq üçün

    for (var product in favoriteState) {
      List<String> productImages = (product['pic_path'] as List<dynamic>).cast<String>();

      for (int j = 0; j < productImages.length; j++) {
        final String uniqueId = '${product['product_id']}_$j';
        final GlobalKey key = getKey(uniqueId);

        // Asinxron render prosesini tasks listinə əlavə edirik
        tasks.add(_captureImage(key, product['product_id'], j, files));
      }
    }

    // Bütün şəkillər render olunana qədər gözləyirik
    await Future.wait(tasks);

    emit(files); // Bütün şəkillər hazır olandan sonra state yenilənir

    if (files.isNotEmpty) {
      await Share.shareXFiles(files, text: 'Seçdiyiniz məhsullar:').then((_) {
        emit(List.from(files)); // Ensure UI updates after sharing
      }).catchError((error) {
        print("Share cancelled or failed: $error");
        emit(List.from(files));
      });
    } else {
      print("No files were captured.");
      emit(List.from(files));
    }
  }
// Şəkil tutma prosesini ayrı funksiyaya çıxarırıq ki, for-loop daha səliqəli olsun
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
*/
