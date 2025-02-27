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

  final List<GlobalKey> _productKeys = []; // Store keys for each product

  void initializeKeys(int productCount) {
    _productKeys.clear();
    _productKeys.addAll(List.generate(productCount, (index) => GlobalKey()));
  }

  GlobalKey getKey(int index) {
    return _productKeys[index];
  }

  Future<void> captureProducts(List<Map<String, dynamic>> favoriteState) async {
    List<XFile> files = [];

    for (int i = 0; i < favoriteState.length; i++) {
      final GlobalKey key = _productKeys[i];

      RenderRepaintBoundary? boundary =
      key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        print("Error: RenderRepaintBoundary is null for product $i");
        continue;
      }

      ui.Image image = await boundary.toImage(pixelRatio: 30.0);
      // rotation----------------
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));

      // Fill the background with white (or any color)
      Paint backgroundPaint = Paint()..color = Colors.white;
      canvas.drawRect(Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), backgroundPaint);
      canvas.translate(0, image.height.toDouble());
      canvas.scale(1,-1);
      canvas.drawImage(image, Offset.zero, Paint());

      final flippedImage = await recorder.endRecording().toImage(image.width, image.height);
      //----------------
      ByteData? byteData = await flippedImage.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        print("Error: byteData is null for product $i");
        continue;
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/product_$i.png').create();
      await file.writeAsBytes(pngBytes);
      files.add(XFile(file.path));
    }

    emit(files); // Update state with captured images

    if (files.isNotEmpty) {
      await Share.shareXFiles(files, text: 'Seçdiyiniz məhsullar:');
    } else {
      print("No files were captured.");
    }
  }
}
