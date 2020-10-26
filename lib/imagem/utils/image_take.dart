import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageTake {
  static Future onClickCam() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (image != null) {
      File compressFile = await _compressImage(image);
      return compressFile;
    }
  }

  static Future _compressImage(File file) async {
    var now = new DateTime.now().millisecondsSinceEpoch;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path + "/" + now.toString() + ".jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      tempPath,
      quality: 85,
    );
    return result;
  }

  static Future<Directory> getTemporaryDirectory() async {
    return Directory.systemTemp;
  }
}
