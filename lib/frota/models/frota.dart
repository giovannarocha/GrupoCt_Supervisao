import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:grupoct_supervisao/bd/helper.dart';

class Frota {
  String fleetNick;
  String fleetBoard;
  int fleetKm;
  int fleetStatus;
  int fleetCaster;

  Frota();

  @override
  String toString() {
    return 'FleetCars(fleetNick: $fleetNick, fleetBoard: $fleetBoard, fleetKm: $fleetKm, fleetStatus: $fleetStatus, fleetCaster: $fleetCaster)';
  }

  Frota.fromMap(Map map) {
    fleetNick = map[Helper.tbFleetNick];
    fleetBoard = map[Helper.tbFleetBoard];
    fleetKm = map[Helper.tbFleetKm];
    fleetStatus = map[Helper.tbFleetStatus];
    fleetCaster = map[Helper.tbFleetCaster];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      Helper.tbFleetNick: fleetNick,
      Helper.tbFleetBoard: fleetBoard,
      Helper.tbFleetKm: fleetKm,
      Helper.tbFleetStatus: fleetStatus,
      Helper.tbFleetCaster: fleetCaster,
    };
    return map;
  }

  static Future<List<Frota>> getFleetCars() async {
    String tabFleetCars = Helper.tbFleetCars;
    Helper helper = Helper();
    var db = await helper.db;
    List listMap = await db.rawQuery("select * from $tabFleetCars");
    List<Frota> cars = List();
    for (Map map in listMap) {
      cars.add(Frota.fromMap(map));
    }
    return cars;
  }

  static save(Frota fleetCars) async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.insert(Helper.tbFleetCars, fleetCars.toMap());
    } catch (e) {}
  }

  static delete() async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.delete(Helper.tbFleetCars);
    } catch (e) {}
  }

  static Future<Frota> select() async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      List listMap = await db.rawQuery("select * from ${Helper.tbFleetCars}");
      List<Frota> list = List();
      for (Map map in listMap) {
        list.add(Frota.fromMap(map));
      }
      return list[0];
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateKm(Frota car) async {
    try {
      var url = 'http://grupoct.com.br/supervision/crud/updateKm.php';
      var response = await http.post(url, body: {
        'tolken': '14913',
        'board': '${car.fleetBoard}',
        'km': '${car.fleetKm}',
      });
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Frota>> getHttpFleetCars() async {
    try {
      var url = 'http://grupoct.com.br/supervision/crud/getFleetCars.php';
      var response = await http.post(url, body: {'tolken': '14913'});
      List<Frota> cars = List();

      if (response.statusCode == 200) {
        List listResponse = json.decode(response.body);
        List<Frota> cars = List();

        for (var car in listResponse) {
          Frota fc = Frota();
          fc.fleetBoard = car[Helper.tbFleetBoard];
          fc.fleetNick = car[Helper.tbFleetNick];
          fc.fleetStatus = int.parse(car[Helper.tbFleetStatus]);
          fc.fleetKm = int.parse(car[Helper.tbFleetKm]);
          fc.fleetCaster = int.parse(car[Helper.tbFleetCaster]);
          cars.add(fc);
        }
        return cars;
      }
      return cars;
    } catch (e) {
      return e;
    }
  }
}
