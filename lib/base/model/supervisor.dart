import 'package:grupoct_supervisao/bd/helper.dart';

class Supervisor {
  int id;
  String name;
  int shift;
  int area;
  String picture;
  String phoneNumber;

  Supervisor();


  Supervisor.fromMap(Map map) {
    id = map[Helper.tbSupId];
    name = map[Helper.tbSupName];
    shift = map[Helper.tbSupShift];
    area = map[Helper.tbSupArea];
    picture = map[Helper.tbSupPicture];
    phoneNumber = map[Helper.tbSupPhoneNumber];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      Helper.tbSupId: id,
      Helper.tbSupName: name,
      Helper.tbSupShift: shift,
      Helper.tbSupArea: area,
      Helper.tbSupPicture: picture,
      Helper.tbSupPhoneNumber: phoneNumber
    };
    return map;
  }

  Future<Supervisor> saveSupervisor(Supervisor supervisor) async {
    Helper helper = Helper();
    var db = await helper.db;
    db.insert(Helper.tbSupervisor, supervisor.toMap());
    return supervisor;
  }

  Future<List> getSupervisor() async {
    String tabSupervisor = Helper.tbSupervisor;
    Helper helper = Helper();
    var db = await helper.db;
    List listMap = await db.rawQuery("select * from $tabSupervisor");
    List<Supervisor> supervisor = List();
    for (Map map in listMap) {
      supervisor.add(Supervisor.fromMap(map));
    }
    return supervisor;
  }
  Future<Supervisor> getOnlySupervisor() async {
    String tabSupervisor = Helper.tbSupervisor;
    Helper helper = Helper();
    var db = await helper.db;
    List listMap = await db.rawQuery("select * from $tabSupervisor");
    List<Supervisor> supervisor = List();
    for (Map map in listMap) {
      supervisor.add(Supervisor.fromMap(map));
    }
    return supervisor[0];
  }
  
  static Future<Supervisor> getOnlySupervisorStatic() async {
    String tabSupervisor = Helper.tbSupervisor;
    Helper helper = Helper();
    var db = await helper.db;
    List listMap = await db.rawQuery("select * from $tabSupervisor");
    List<Supervisor> supervisor = List();
    for (Map map in listMap) {
      supervisor.add(Supervisor.fromMap(map));
    }
    return supervisor[0];
  }

  removeSupervisor() async {
    Helper helper = Helper();
    var db = await helper.db;
    db.delete(Helper.tbSupervisor);
  }

  updateSupervisor(Supervisor supervisor) async {
    Helper helper = Helper();
    var db = await helper.db;
    String idColumn = Helper.tbSupId;
    db.update(Helper.tbSupervisor, supervisor.toMap(),
        where: "$idColumn =?", whereArgs: [supervisor.id]);
  }

  @override
  String toString() {
    return 'Supervisor(id: $id, name: $name, shift: $shift, area: $area, picture: $picture, phoneNumber: $phoneNumber)';
  }
}
