import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Helper {
  static final String tbUpdateController = "tbUpdateController";

  static final String tbName = "tbName";
  static final String lastUpdate = "lastUpdate";

  //--------------bloc table
  static final String tbSupervisor = "tbSupervisor";

  static final String tbSupId = "tbSupId";
  static final String tbSupName = "tbSupName";
  static final String tbSupShift = "tbSupShift";
  static final String tbSupArea = "tbSupArea";
  static final String tbSupPicture = "tbSupPicture";
  static final String tbSupPhoneNumber = "tbSupPhoneNumber";

  //--------------bloc table
  static final String tbSupReport = "tbSupReport";

  static final String tbSupRepId = "tbSupRepId";
  static final String tbSupRepSupId = "tbSupRepSupId";
  static final String tbSupRepDtBegin = "tbSupRepDtBegin";
  static final String tbSupRepStatus = "tbSupRepStatus";
  static final String tbSupRepRoute = "tbSupRoute";
  static final String tbSupRepDateTimeEnd = "tbSupDateTimeEnd";
  static final String tbSupRepHasMeal = "tbSupRepHasMeal";
  static final String tbSupRepDtMealBegin = "tbSupRepDtMealBegin";
  static final String tbSupRepDtMealEnd = "tbSupRepDtMealEnd";
  //--------------bloc table
  static final String tbFleetCars = "tbFleetCars";

  static final String tbFleetNick = "tbFleetNick";
  static final String tbFleetBoard = "tbFleetBoard";
  static final String tbFleetKm = "tbFleetKm";
  static final String tbFleetStatus = "tbFleetStatus";
  static final String tbFleetCaster = "tbFleetCaster";
  //--------------bloc table
  static final String tbReportMov = "tbReportMov";

  static final String tbReportMovId = "tbReportMovId";
  static final String tbReportMovRepId = "tbReportMovRepId";
  static final String tbReportMovDateTime = "tbReportMovDateTime";
  static final String tbReportMovType = "tbReportMovType";
  static final String tbReportMovHasImage = "tbReportMovHasImage";
  static final String tbReportMovDescr = "tbReportMovDescr";
  static final String tbReportMovIsPost = "tbReportMovIsPost";
  static final String tbReportMovClientContact = "tbReportMovClientContact";
  static final String tbReportMovDateTimeFinish = "tbReportMovDateTimeFinish";
  static final String tbReportMovCodPost = "tbReportMovCodPost";

  //--------------bloc table
  static final String tbReportMovImages = "tbReportMovImages";

  static final String tbReportMovImagesRelationalId =
      "tbReportMovImagesRelationalId";
  static final String tbReportMovImagesName = "tbReportMovImagesName";
  static final String tbReportMovImagesImage = "tbReportMovImagesImage";

  static final String tbReportMovImagesDesc = "tbReportMovImagesDesc";
  static final String tbReportMovImagesType = "tbReportMovImagesType";
  //--------------bloc table

  static final String tbPost = "tbPosts";

  static final String tbPostCod = "COD_POST";
  static final String tbPostPostName = "NAME_POST";
  static final String tbPostArea = "AREA_POST";
  static final String tbPostShift = "SHIFT_POST";
  static final String tbPostRoute = "ROUTE_POST";
  static final String tbPostLatitude = "LATITUDE";
  static final String tbPostLongitude = "LONGITUDE";
  static final String tbPostHasToken = "HAVE_TOKEN";

  //--------------bloc table
  static final String tbCurrentPost = "tbCurrentPost";

  static final String tbCurrentPostCod = "tbCurrentPostCod";
  static final String tbCurrentPostName = "tbCurrentPostName";
  static final String tbCurrentPostLatitude = "tbCurrentPostLatitude";
  static final String tbCurrentPostLongitude = "tbCurrentPostLongitude";
  static final String tbCurrentPostReportId = "tbCurrentPostReportId";
  static final String tbCurrentPostMovId = "tbCurrentPostMovId";
  static final String tbCurrentPostDate = "tbCurrentPostDate";
  static final String tbCurrentPostHasToken = "tbCurrentPostHasToken";
  static final String tbPostoAtualContatoComCliente =
      "tbPostoAtualContatoComCliente";
  //--------------bloc table
  static final String tbReportItem = "tbReportItem";

  static final String tbReportItemId = "tbReportItemId";
  static final String tbReportItemTitle = "tbReportItemTitle";
  static final String tbReportItemRelationalId = "tbReportItemRelationalId";
  static final String tbReportItemHasImage = "tbReportItemHasImage";
  static final String tbReportItemDescr = "tbReportItemDescr";
  static final String tbReportItemThisDate = "tbReportItemThisDate";
  //--------------bloc table
  static final String tbReportToUpdate = "tbReportToUpdate";

  static final String tbReportToUpdateId = "tbReportToUpdateId";
  static final String tbReportToUpdateDt = "tbReportToUpdateDt";
  static final String tbReportToUpdateClientContact =
      "tbReportToUpdateClientContact";

  static final String tbReportToUpdateType = "tbReportToUpdateType";

  //--------------bloc table

  static final String tbToken = "tbToken";

  static final String tbTokenClientEmail = "tbTokenClientEmail";
  static final String tbTokenClientName = "tbTokenClientName";
  static final String tbTokenCodPost = "tbTokenCodPost";

  //--------------end bloc tables

  static final Helper _instance = Helper.internal();

  factory Helper() => _instance;

  Helper.internal();

  Database _db;

  deleteDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "sup_ct.db");
    deleteDatabase(path);
  }

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "sup_ct.db");
    return await openDatabase(path, version: 3,
        onCreate: (Database db, int newVersion) async {
      await db.execute(""
          "CREATE TABLE $tbSupervisor($tbSupId INTEGER PRIMARY KEY, $tbSupName TEXT,$tbSupShift INTEGER,$tbSupArea INTEGER, $tbSupPicture TEXT,$tbSupPhoneNumber TEXT); ");
      await db.execute(""
          "CREATE TABLE $tbSupReport($tbSupRepId TEXT PRIMARY KEY, $tbSupRepSupId INTEGER, $tbSupRepDtBegin TEXT, $tbSupRepStatus INTEGER, $tbSupRepRoute INTEGER, $tbSupRepDateTimeEnd TEXT, $tbSupRepHasMeal INTEGER, $tbSupRepDtMealBegin TEXT, $tbSupRepDtMealEnd TEXT);");
      await db.execute(""
          "CREATE TABLE $tbUpdateController($tbName TEXT PRIMARY KEY, $lastUpdate INTEGER);");
      await db.execute(""
          "CREATE TABLE $tbFleetCars($tbFleetNick TEXT, $tbFleetBoard TEXT PRIMARY KEY, $tbFleetKm INTEGER, $tbFleetStatus INTEGER, $tbFleetCaster INTEGER);");
      await db.execute(""
          "CREATE TABLE $tbReportMov($tbReportMovId TEXT, $tbReportMovRepId TEXT, $tbReportMovDateTime TEXT,$tbReportMovHasImage INTEGER, $tbReportMovType TEXT, $tbReportMovDescr TEXT, $tbReportMovIsPost INTEGER, $tbReportMovClientContact INTEGER, $tbReportMovDateTimeFinish TEXT, $tbReportMovCodPost INTEGER);");
      await db.execute(""
          "CREATE TABLE $tbReportMovImages($tbReportMovImagesRelationalId TEXT, $tbReportMovImagesImage TEXT, $tbReportMovImagesDesc TEXT,$tbReportMovImagesType TEXT,$tbReportMovImagesName TEXT);");
      await db.execute(""
          "CREATE TABLE $tbPost($tbPostCod INTEGER, $tbPostPostName TEXT, $tbPostArea INTEGER, $tbPostShift INTEGER, $tbPostRoute TEXT, $tbPostLatitude TEXT, $tbPostLongitude TEXT, $tbPostHasToken INTEGER);");
      await db.execute(""
          "CREATE TABLE $tbCurrentPost($tbCurrentPostCod INTEGER, $tbCurrentPostLatitude TEXT, $tbCurrentPostLongitude TEXT, $tbCurrentPostMovId TEXT, $tbCurrentPostName TEXT, $tbCurrentPostReportId TEXT,$tbCurrentPostDate TEXT, $tbCurrentPostHasToken INTEGER, $tbPostoAtualContatoComCliente INTEGER);");
      await db.execute(""
          "CREATE TABLE $tbReportItem($tbReportItemTitle TEXT, $tbReportItemRelationalId TEXT, $tbReportItemHasImage INTEGER, $tbReportItemDescr TEXT, $tbReportItemThisDate TEXT, $tbReportItemId TEXT);");
      await db.execute(""
          "CREATE TABLE $tbReportToUpdate($tbReportToUpdateId TEXT, $tbReportToUpdateDt TEXT, $tbReportToUpdateClientContact INTEGER, $tbReportToUpdateType INTEGER);");
      await db.execute(""
          "CREATE TABLE $tbToken($tbTokenClientEmail TEXT, $tbTokenClientName TEXT, $tbTokenCodPost INTEGER);");
    });
  }
}
