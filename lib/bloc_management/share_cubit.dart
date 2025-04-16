import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SelectedImageObject {
  final String imagePath;
  final int index;
  SelectedImageObject({required this.imagePath, required this.index});
}

class ShareCubit extends Cubit<List<SelectedImageObject>> {
  final int length;
  ShareCubit(this.length) : super([]) {
    initState(length);
  }

  List<GlobalKey> keys = [];
  List<XFile> files = [];

  void initState(int length) {
    keys.clear();
    files.clear();
    keys = List.generate(length, (index) => GlobalKey());
  }

  GlobalKey getKey(int i) {
    return keys[i];
  }

  void toggleSelectImage(SelectedImageObject object) {
    // Create a completely new list
    final newState = List<SelectedImageObject>.from(state);
    final existingIndex =
        newState.indexWhere((e) => e.imagePath == object.imagePath);

    if (existingIndex >= 0) {
      newState.removeAt(existingIndex);
    } else {
      newState.add(object);
    }

    // Single emit call with the final state
    emit(newState);
  }

  Future<void> shareImages(String productId) async {
    files.clear(); // Clear previous files

    // Add slight delay to ensure widgets are rendered

    for (var i in state) {
      await captureImage(keys[i.index], productId, i.index);
    }

    if (files.isNotEmpty) {
      await Share.shareXFiles(files, text: 'Seçdiyiniz məhsullar:');
    } else {}
  }

  Future<void> captureImage(GlobalKey key, String productId, int index) async {
    RenderRepaintBoundary? boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return;
    }
    ui.Image image = await boundary.toImage(pixelRatio: 12);
    ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (byteData == null) {
      return;
    }
    Uint8List pngBytes = byteData.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/${productId}_$index.png').create();
    await file.writeAsBytes(pngBytes);
    files.add(XFile(file.path));
  }
}
