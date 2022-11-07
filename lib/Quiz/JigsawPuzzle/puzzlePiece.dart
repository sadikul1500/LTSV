import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as imglib;

class PuzzlePiece {
  late imglib.Image image;
  final File file;
  int level;
  late Uint8List bytes;
  List<Uint8List> splitImages = [];
  List<imglib.Image> parts = <imglib.Image>[];
  late int width, height;

  PuzzlePiece(this.file, this.level) {
    bytes = file.readAsBytesSync();
    image = imglib.decodeImage(bytes)!;
    // print('puzzle piece ${file.path}');
  }

  List<Uint8List> getSplitImages() {
    for (var part in parts) {
      Uint8List uint8list = Uint8List.fromList(imglib.encodeJpg(part));
      splitImages.add(uint8list);
    }

    return splitImages;
  }

  imglib.Image resizeImage() {
    int imageHeight = image.height > 380
        ? 380
        : image.height < 300
            ? 300
            : image.height;
    int imageWidth = image.width > 500
        ? 500
        : image.width < 400
            ? 400
            : image.width;

    return imglib.copyResize(image,
        width: imageWidth, height: imageHeight); //height: imageHeight,
  }

  List<Uint8List> splitImage() {
    if (level == 2) {
      // print('level2');
      return splitImage2();
    } else {
      return splitImage3();
    }
  }

  //2X2
  List<Uint8List> splitImage2() {
    int x = 0, y = 0;

    image = resizeImage();
    // imglib.copyResize(image, height: imageHeight, width: imageWidth);
    width = (image.width / 2).floor();
    height = (image.height / 2).floor();

    // List<imglib.Image> parts = <imglib.Image>[];
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        parts.add(imglib.copyCrop(image, x, y, width, height));
        x += width;
      }
      x = 0;
      y += height;
    }

    return getSplitImages();
  }

  List<Uint8List> splitImage3() {
    int x = 0, y = 0;

    image = resizeImage();
    // imglib.copyResize(image, height: imageHeight, width: imageWidth);
    width = (image.width / 3).floor();
    height = (image.height / 2).floor();

    // List<imglib.Image> parts = <imglib.Image>[];
    for (int i = 0; i < 2; i++) {
      //height
      for (int j = 0; j < 3; j++) {
        //width
        parts.add(imglib.copyCrop(image, x, y, width, height));
        x += width;
      }
      x = 0;
      y += height;
    }

    return getSplitImages();
  }
}
