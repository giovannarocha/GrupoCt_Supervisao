import 'package:connectivity/connectivity.dart';
import 'package:grupoct_supervisao/bd/helper.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TbImage {
  String image;
  String name;
  String descr;
  String type;
  String id;

  TbImage();

  Map toMap() {
    Map<String, dynamic> map = {
      Helper.tbReportMovImagesImage: image,
      Helper.tbReportMovImagesName: name,
      Helper.tbReportMovImagesDesc: descr,
      Helper.tbReportMovImagesType: type,
      Helper.tbReportMovImagesRelationalId: id,
    };
    return map;
  }

  TbImage.fromMap(Map map) {
    image = map[Helper.tbReportMovImagesImage];
    name = map[Helper.tbReportMovImagesName];
    descr = map[Helper.tbReportMovImagesDesc];
    type = map[Helper.tbReportMovImagesType];
    id = map[Helper.tbReportMovImagesRelationalId];
  }

  Future<String> doAllIWant(File file, String imageName, String descr,
      String type, String relationalId) async {
    try {
      String base64Image = base64Encode(file.readAsBytesSync());

      if (base64Image.length < 2) {
        return "erro";
      }
      TbImage image = TbImage();
      image.id = relationalId;
      image.descr = descr;
      image.name = imageName;
      image.type = type;
      image.image = base64Image;
      image.save(image);
      upload();
      return "OK";
    } catch (e) {
      return "$e";
    }
  }

  save(TbImage tbImage) async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.insert(Helper.tbReportMovImages, tbImage.toMap());
    } catch (e) {}
  }

  upload() async {
    List<TbImage> list = await select();
    if (list.length >= 1) {
      for (var image in list) {
        try {
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) {
            final String phpEndPoint =
                'http://grupoct.com.br/supervision/crud/uploadImage.php';
            var response = await http.post(phpEndPoint, body: {
              "image": image.image,
              "name": image.name,
              "descr": image.descr,
              "type": image.type,
              "id": image.id,
            });
            if (response.statusCode == 200) {
              if (response.body == "ok") {
                await delete(image.name);
              }
            }
          }
        } catch (e) {
          return false;
        }
      }
      List<TbImage> list2 = await select();
      if (list2.length >= 1) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  delete(name) async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.delete(Helper.tbReportMovImages,
          where: "${Helper.tbReportMovImagesName} = ?", whereArgs: [name]);
    } catch (e) {}
  }

  Future<List<TbImage>> select() async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      List listMap =
          await db.rawQuery("select * from ${Helper.tbReportMovImages}");
      List<TbImage> list = List();
      for (Map map in listMap) {
        list.add(TbImage.fromMap(map));
      }
      return list;
    } catch (e) {
      return null;
    }
  }
}
