import 'package:http/http.dart' as http;

class MovimentacaoDeFrota {
  String id = "0";
  int typeMov = 0;
  String reportId;
  String dataHourMov = "";
  String board = "";
  int km = 0;
  int fuelLvl = 0;
  int hasBreakDown = 0;

  MovimentacaoDeFrota();

  Future<dynamic> saveMov(MovimentacaoDeFrota mov) async {
    try {
      var url = 'http://grupoct.com.br/supervision/crud/saveMovFleet.php';
      var response = await http.post(url, body: {
        'tolken': '14913',
        'typeMov': '${mov.typeMov}',
        'reportId': '${mov.reportId}',
        'dataHourMov': '${mov.dataHourMov}',
        'board': '${mov.board}',
        'km': '${mov.km}',
        'fuelLvl': '${mov.fuelLvl}',
        'hasBreakDown': '${mov.hasBreakDown}',
        'movId': '${mov.id}',
      });

      if (response.statusCode == 200) {
        if (response.body == "1") {
          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  String toString() {
    return 'FleetCarsMov(typeMov: $typeMov, reportId: $reportId, dataHourMov: $dataHourMov, board: $board, km: $km, fuelLvl: $fuelLvl, hasBreakDown: $hasBreakDown, movId: $id)';
  }
}
