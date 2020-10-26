import 'package:grupoct_supervisao/bd/helper.dart';

class PostoAtual {
  int cod;
  String name;
  String latitude;
  String longitude;
  String reportId;
  String movId;
  String thisDate;
  int temToken;
  int teveContatoComCliente = 0;

  PostoAtual();

  Map toMap() {
    Map<String, dynamic> map = {
      Helper.tbCurrentPostCod: cod,
      Helper.tbCurrentPostName: name,
      Helper.tbCurrentPostLatitude: latitude,
      Helper.tbCurrentPostLongitude: longitude,
      Helper.tbCurrentPostReportId: reportId,
      Helper.tbCurrentPostMovId: movId,
      Helper.tbCurrentPostDate: thisDate,
      Helper.tbCurrentPostHasToken: temToken,
      Helper.tbPostoAtualContatoComCliente: teveContatoComCliente,
    };
    return map;
  }

  PostoAtual.fromMap(Map map) {
    cod = map[Helper.tbCurrentPostCod];
    name = map[Helper.tbCurrentPostName];
    latitude = map[Helper.tbCurrentPostLatitude];
    longitude = map[Helper.tbCurrentPostLongitude];
    reportId = map[Helper.tbCurrentPostReportId];
    movId = map[Helper.tbCurrentPostMovId];
    thisDate = map[Helper.tbCurrentPostDate];
    temToken = map[Helper.tbCurrentPostHasToken];
    teveContatoComCliente = map[Helper.tbPostoAtualContatoComCliente];
  }

  static update(PostoAtual postoAtual) async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.update(Helper.tbCurrentPost, postoAtual.toMap(),
          where: "${Helper.tbCurrentPostMovId} = ?",
          whereArgs: [postoAtual.movId]);
    } catch (e) {}
  }

  static save(PostoAtual currentPost) async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.insert(Helper.tbCurrentPost, currentPost.toMap());
    } catch (e) {}
  }

  static delete() async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.delete(Helper.tbCurrentPost);
    } catch (e) {}
  }

  static Future<PostoAtual> select() async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      List listMap = await db.rawQuery("select * from ${Helper.tbCurrentPost}");
      List<PostoAtual> list = List();
      for (Map map in listMap) {
        list.add(PostoAtual.fromMap(map));
      }
      return list[0];
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'CurrentPost(cod: $cod, name: $name, latitude: $latitude, longitude: $longitude, reportId: $reportId, movId: $movId, thisDate: $thisDate)';
  }
}
