import 'package:connectivity/connectivity.dart';
import 'package:grupoct_supervisao/bd/helper.dart';
import 'package:http/http.dart' as http;

class ItemDeRelatorio {
  String id;
  String reportId;
  String type;
  int hasImage = 0;
  String descr = "";
  String dateTime;
  int isPost = 0;
  int clientContact = 0;
  String dateTimeFinish;
  int codPost;

  ItemDeRelatorio();

  Map toMap() {
    Map<String, dynamic> map = {
      Helper.tbReportMovId: id,
      Helper.tbReportMovRepId: reportId,
      Helper.tbReportMovType: type,
      Helper.tbReportMovHasImage: hasImage,
      Helper.tbReportMovDescr: descr,
      Helper.tbReportMovDateTime: dateTime,
      Helper.tbReportMovIsPost: isPost,
      Helper.tbReportMovClientContact: clientContact,
      Helper.tbReportMovDateTimeFinish: dateTimeFinish,
      Helper.tbReportMovCodPost: codPost,
    };
    return map;
  }

  ItemDeRelatorio.fromMap(Map map) {
    id = map[Helper.tbReportMovId];
    reportId = map[Helper.tbReportMovRepId];
    type = map[Helper.tbReportMovType];
    hasImage = map[Helper.tbReportMovHasImage];
    descr = map[Helper.tbReportMovDescr];
    dateTime = map[Helper.tbReportMovDateTime];
    isPost = map[Helper.tbReportMovIsPost];
    clientContact = map[Helper.tbReportMovClientContact];
    dateTimeFinish = map[Helper.tbReportMovDateTimeFinish];
    codPost = map[Helper.tbReportMovCodPost];
  }

  doAlIWant(ItemDeRelatorio reportMov) async {
    await saveMov(reportMov);
    await cleanDbReportMov();
  }

  saveHttpMov(ItemDeRelatorio reportMov) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        var url = 'http://grupoct.com.br/supervision/crud/saveReportMov.php';
        var response = await http.post(url, body: {
          'tolken': '14913',
          'id': '${reportMov.id}',
          'reportId': '${reportMov.reportId}',
          'movTitle': '${reportMov.type}',
          'hasImage': '${reportMov.hasImage}',
          'descr': '${reportMov.descr}',
          'inputHour': '${reportMov.dateTime}',
          'isPost': '${reportMov.isPost}',
          'clientContact': '${reportMov.clientContact}',
          'dateTimeFinish': '${reportMov.dateTimeFinish}',
          'codPost': '${reportMov.codPost}',
        });
        if (response.statusCode == 200) {
          return response.body;
        }
        return response.body;
      } else {
        return false;
      }
    } catch (e) {
      return e;
    }
  }

  saveMov(ItemDeRelatorio reportMov) async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.insert(Helper.tbReportMov, reportMov.toMap());
    } catch (e) {}
  }

  deleteMov(id) async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.delete(Helper.tbReportMov, where: "tbReportMovId =?", whereArgs: [id]);
    } catch (e) {}
  }

  getMov() async {
    try {
      String tbReportMov = Helper.tbReportMov;
      Helper helper = Helper();
      var db = await helper.db;
      List listMap = await db.rawQuery("select * from $tbReportMov");
      List<ItemDeRelatorio> reportMov = List();
      for (Map map in listMap) {
        reportMov.add(ItemDeRelatorio.fromMap(map));
      }
      return reportMov;
    } catch (e) {}
  }

  Future<dynamic> cleanDbReportMov() async {
    try {
      List<ItemDeRelatorio> list = await getMov();
      if (list.length > 0) {
        for (var item in list) {
          var saveHttpResponse = await saveHttpMov(item);
          if (saveHttpResponse == "OK") {
            await deleteMov(item.id);
          }
        }
        list = await getMov();
        if (list.length > 0) {
          return false;
        }
        return true;
      }
      return true;
    } catch (e) {
      return "$e";
    }
  }
}

class ReportComplement {
  String tbReportToUpdateId;
  String tbReportToUpdateDt = "N/A";
  int tbReportToUpdateClientContact = 0;
  int tbReportToUpdateType;

  ReportComplement();

  doAlIWant(ReportComplement reportComplement) async {
    await saveUpdate(reportComplement);
    await cleanDbReport();
  }

  Future<dynamic> updateHttp(ReportComplement rc) async {
    try {
      var url = 'http://grupoct.com.br/supervision/crud/updateReportMov.php';
      var response = await http.post(url, body: {
        'tolken': '14913',
        'tbReportToUpdateId': '${rc.tbReportToUpdateId}',
        'tbReportToUpdateDt': '${rc.tbReportToUpdateDt}',
        'tbReportToUpdateClientContact': '${rc.tbReportToUpdateClientContact}',
        'tbReportToUpdateType': '${rc.tbReportToUpdateType}',
      });
      if (response.statusCode == 200) {
        return response.body;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  saveUpdate(ReportComplement reportComplement) async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.insert(Helper.tbReportToUpdate, reportComplement.toMap());
    } catch (e) {}
  }

  updateNov(reportComplement) async {
    Helper helper = Helper();
    var db = await helper.db;
    String idColumn = Helper.tbReportToUpdateId;
    db.update(Helper.tbSupReport, reportComplement.toMap(),
        where: "$idColumn =?",
        whereArgs: [reportComplement.tbReportToUpdateId]);
  }

  getReport() async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      List listMap =
          await db.rawQuery("select * from ${Helper.tbReportToUpdate}");
      List<ReportComplement> list = List();
      for (Map map in listMap) {
        list.add(ReportComplement.fromMap(map));
      }
      return list;
    } catch (e) {}
  }

  deleteReport(id) async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.delete(Helper.tbReportToUpdate,
          where: "tbReportToUpdateId =?", whereArgs: [id]);
    } catch (e) {}
  }

  Future<dynamic> cleanDbReport() async {
    try {
      List<ReportComplement> list = await getReport();
      if (list.length > 0) {
        for (var item in list) {
          var updateHttpResponse = await updateHttp(item);
          print("response: $updateHttpResponse");
          if (updateHttpResponse == "ok") {
            await deleteReport(item.tbReportToUpdateId);
          }
        }
        list = await getReport();
        if (list.length > 0) {
          return false;
        }
        return true;
      }
      return true;
    } catch (e) {
      return "$e";
    }
  }

  Map toMap() {
    Map<String, dynamic> map = {
      Helper.tbReportToUpdateId: tbReportToUpdateId,
      Helper.tbReportToUpdateDt: tbReportToUpdateDt,
      Helper.tbReportToUpdateClientContact: tbReportToUpdateClientContact,
      Helper.tbReportToUpdateType: tbReportToUpdateType
    };
    return map;
  }

  ReportComplement.fromMap(Map map) {
    tbReportToUpdateId = map[Helper.tbReportToUpdateId];
    tbReportToUpdateDt = map[Helper.tbReportToUpdateDt];
    tbReportToUpdateClientContact = map[Helper.tbReportToUpdateClientContact];
    tbReportToUpdateType = map[Helper.tbReportToUpdateType];
  }
}
