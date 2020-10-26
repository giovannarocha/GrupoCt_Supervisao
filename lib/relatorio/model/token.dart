import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:grupoct_supervisao/bd/helper.dart';

class Token {
  String clientEmail;
  String clientName;
  int codPost;

  Token();

  Token.fromMap(Map map) {
    clientName = map[Helper.tbTokenClientName];
    clientEmail = map[Helper.tbTokenClientEmail];
    codPost = map[Helper.tbTokenCodPost];
  }

  Map topMap() {
    Map<String, dynamic> map = {
      Helper.tbTokenClientName: clientName,
      Helper.tbTokenClientEmail: clientEmail,
      Helper.tbTokenCodPost: codPost
    };
    return map;
  }

  static save(Token token) async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.insert(Helper.tbToken, token.topMap());
    } catch (e) {}
  }

  static delete() async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.delete(Helper.tbToken);
    } catch (e) {}
  }

  static Future<List<Token>> select(codPost) async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      List listMap = await db.rawQuery(
          "select * from ${Helper.tbToken} where ${Helper.tbTokenCodPost} = $codPost");
      List<Token> list = List();
      for (Map map in listMap) {
        list.add(Token.fromMap(map));
      }
      return list;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getTokens() async {
    try {
      var url = 'http://grupoct.com.br/supervision/crud/geradorToken.php';
      var response = await http.post(url, body: {'tolken': '14913'});

      if (response.statusCode == 200) {
        print(response.body);
        List listResponse = json.decode(response.body);
        delete();
        for (var tokens in listResponse) {
          Token token = Token();
          token.clientEmail = tokens['clientEmail'];
          token.clientName = tokens['clientName'];
          token.codPost = int.parse(tokens['codPost']);

          save(token);
        }
        return "ATUALIZADO COM SUCESSO";
      }
      return "ERRO AO ATUALIZAR";
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> sendTokenToClient(clientEmail, codPost) async {
    try {
      var url = 'http://grupoct.com.br/supervision/crud/geradorToken.php';
      var response = await http.post(url, body: {
        'tolken': '14913',
        'op': '1',
        'clientEmail': '$clientEmail',
        'codPost': '$codPost',
      });
      if (response.statusCode == 200) {
        return response.body;
      }
      return false;
    } catch (e) {
      return e;
    }
  }

  Future validateToken(token, codPost) async {
    try {
      if (token == 0 || token == null || token == "") {
        token = 7;
      }
      var url = 'http://grupoct.com.br/supervision/crud/geradorToken.php';
      var response = await http.post(url, body: {
        'tolken': '14913',
        'op': '2',
        'token': '$token',
        'codPost': '$codPost',
      });
      if (response.statusCode == 200) {
        return response.body;
      }
      return false;
    } catch (e) {
      return e;
    }
  }
}
