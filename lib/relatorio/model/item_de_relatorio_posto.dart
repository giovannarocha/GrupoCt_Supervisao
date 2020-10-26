import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

import 'package:grupoct_supervisao/bd/helper.dart';

class ItemDeRelatorioPosto {
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  String titulo;
  String idDoRelatorioPosto;
  int temImagem = 0;
  String descricao = "";
  String dataHora = DateTime.now().toString();

  ItemDeRelatorioPosto();

  Map toMap() {
    Map<String, dynamic> map = {
      Helper.tbReportItemId: id,
      Helper.tbReportItemTitle: titulo,
      Helper.tbReportItemRelationalId: idDoRelatorioPosto,
      Helper.tbReportItemHasImage: temImagem,
      Helper.tbReportItemDescr: descricao,
      Helper.tbReportItemThisDate: dataHora,
    };
    return map;
  }

  ItemDeRelatorioPosto.fromMap(Map map) {
    id = map[Helper.tbReportItemId];
    titulo = map[Helper.tbReportItemTitle];
    idDoRelatorioPosto = map[Helper.tbReportItemRelationalId];
    temImagem = map[Helper.tbReportItemHasImage];
    descricao = map[Helper.tbReportItemDescr];
    dataHora = map[Helper.tbReportItemThisDate];
  }

  save(ItemDeRelatorioPosto reportItem) async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.insert(Helper.tbReportItem, reportItem.toMap());
    } catch (e) {}
  }

  salvarLocalETentarEnviarHttp(ItemDeRelatorioPosto reportItem) async {
    print(reportItem);
    save(reportItem);
    tentarEnviarViaHTTPPraLimparBanco();
  }

  saveHttp(ItemDeRelatorioPosto reportItem) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        var url = 'http://grupoct.com.br/supervision/crud/saveReportItem.php';
        var response = await http.post(url, body: {
          'tolken': '14913',
          'id': '${reportItem.id}',
          'title': '${reportItem.titulo}',
          'relationalId': '${reportItem.idDoRelatorioPosto}',
          'hasImage': '${reportItem.temImagem}',
          'descr': '${reportItem.descricao}',
          'thisDate': '${reportItem.dataHora}',
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

  tentarEnviarViaHTTPPraLimparBanco() async {
    try {
      List<ItemDeRelatorioPosto> list = await select();
      if (list.length > 0) {
        for (var item in list) {
          print(item);
          var saveHttpResponse = await saveHttp(item);
          if (saveHttpResponse == "OK") {
            delete(item.id);
          }
        }
        list = await select();
        if (list.length > 0) {
          return false;
        }
        return true;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  delete(id) async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.delete(Helper.tbReportItem,
          where: "tbReportItemId =?", whereArgs: [id]);
    } catch (e) {}
  }

  select() async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      List listMap =
          await db.rawQuery("select * from ${Helper.tbReportItem} limit 1000");
      List<ItemDeRelatorioPosto> list = List();
      for (Map map in listMap) {
        list.add(ItemDeRelatorioPosto.fromMap(map));
      }
      return list;
    } catch (e) {}
  }

  @override
  String toString() {
    return 'ItemDeRelatorioPosto(id: $id, titulo: $titulo, idDoRelatorioPosto: $idDoRelatorioPosto, temImagem: $temImagem, descricao: $descricao, dataHora: $dataHora)';
  }
}
