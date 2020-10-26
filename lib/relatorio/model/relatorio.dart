import 'package:http/http.dart' as http;

import 'package:grupoct_supervisao/bd/helper.dart';

class Relatorio {
  String id;
  int idDoSupervisor = 0;
  String dataHoraComeco = "";
  int status = 0;
  int rota = 0;
  String dataHoraFim = "";
  int fezRefeicao = 0;
  String dataHoraInicioRefeicao = "N/A";
  String dataHoraFimRefeicao = "N/A";

  Relatorio();

  Relatorio.fromMap(Map map) {
    id = map[Helper.tbSupRepId];
    dataHoraComeco = map[Helper.tbSupRepDtBegin];
    status = map[Helper.tbSupRepStatus];
    idDoSupervisor = map[Helper.tbSupRepSupId];
    rota = map[Helper.tbSupRepRoute];
    dataHoraFim = map[Helper.tbSupRepDateTimeEnd];
    fezRefeicao = map[Helper.tbSupRepHasMeal];
    dataHoraInicioRefeicao = map[Helper.tbSupRepDtMealBegin];
    dataHoraFimRefeicao = map[Helper.tbSupRepDtMealEnd];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      Helper.tbSupRepId: id,
      Helper.tbSupRepDtBegin: dataHoraComeco,
      Helper.tbSupRepStatus: status,
      Helper.tbSupRepSupId: idDoSupervisor,
      Helper.tbSupRepRoute: rota,
      Helper.tbSupRepDateTimeEnd: dataHoraFim,
      Helper.tbSupRepHasMeal: fezRefeicao,
      Helper.tbSupRepDtMealBegin: dataHoraInicioRefeicao,
      Helper.tbSupRepDtMealEnd: dataHoraFimRefeicao,
    };
    return map;
  }

  Future<Relatorio> salvarRelatorio(Relatorio relatorio) async {
    Helper helper = Helper();
    var db = await helper.db;
    db.insert(Helper.tbSupReport, relatorio.toMap());
    return relatorio;
  }

  Future<dynamic> salvarHttpRelatorio(Relatorio sr) async {
    try {
      delete();
      var url =
          'http://grupoct.com.br/supervision/crud/supReportSaveAndUpdate.php';
      var response = await http.post(url, body: {
        'tolken': '14913',
        'id': '${sr.id}',
        'supervisorId': '${sr.idDoSupervisor}',
        'dateTimeBegin': '${sr.dataHoraComeco}',
        'status': '${sr.status}',
        'route': '${sr.rota}',
        'dateTimeEnd': '${sr.dataHoraFim}',
      });
      if (response.statusCode == 200) {
        return response.body;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  atualizarRelatorio(Relatorio supervisionReport) async {
    supervisionReport.rota == null
        ? supervisionReport.rota = 0
        : supervisionReport.rota = supervisionReport.rota;
    supervisionReport.dataHoraFim == null
        ? supervisionReport.dataHoraFim = ""
        : supervisionReport.dataHoraFim = supervisionReport.dataHoraFim;

    Helper helper = Helper();
    var db = await helper.db;
    String idColumn = Helper.tbSupRepId;
    db.update(Helper.tbSupReport, supervisionReport.toMap(),
        where: "$idColumn =?", whereArgs: [supervisionReport.id]);
  }

  Future<dynamic> atualizarHttpRelatorio(Relatorio sr) async {
    try {
      var url = 'http://grupoct.com.br/supervision/crud/supReportUpdate.php';
      var response = await http.post(url, body: {
        'tolken': '14913',
        'id': '${sr.id}',
        'status': '${sr.status}',
        'route': '${sr.rota}',
        'dateTimeEnd': '${sr.dataHoraFim}',
        'hasMeal': '${sr.fezRefeicao}',
        'dtMealBegin': '${sr.dataHoraInicioRefeicao}',
        'dtMealEnd': '${sr.dataHoraFimRefeicao}',
      });
      if (response.statusCode == 200) {
        return response.body;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  delete() async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.delete(Helper.tbSupReport);
    } catch (e) {
      print("$e");
    }
  }

  Future<Relatorio> retornarRelatorio() async {
    String tbSupReport = Helper.tbSupReport;
    Helper helper = Helper();
    var db = await helper.db;
    List listMap = await db
        .rawQuery("select * from $tbSupReport where tbSupRepStatus > 0");
    List<Relatorio> supervisionReportList = List();
    for (Map map in listMap) {
      supervisionReportList.add(Relatorio.fromMap(map));
    }
    if (supervisionReportList.isNotEmpty) {
      return supervisionReportList[0];
    }
    return null;
  }

  @override
  String toString() {
    return 'SupervisionReport(id: $id, supervisorId: $idDoSupervisor, dateTimeBegin: $dataHoraComeco, status: $status, route: $rota, dateTimeEnd: $dataHoraFim, hasMeal: $fezRefeicao, dtMealBegin: $dataHoraInicioRefeicao, dtMealEnd: $dataHoraFimRefeicao)';
  }
}
