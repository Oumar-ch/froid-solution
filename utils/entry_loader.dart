import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

Future<ui.Image> loadUiImage(String assetPath) async {
  final data = await rootBundle.load(assetPath);
  final bytes = data.buffer.asUint8List();
  final completer = Completer<ui.Image>();
  ui.decodeImageFromList(bytes, (img) => completer.complete(img));
  return completer.future;
}
