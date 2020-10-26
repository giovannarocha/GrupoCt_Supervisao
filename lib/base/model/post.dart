import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:grupoct_supervisao/bd/helper.dart';

class Post {
  int codPost;
  String postTitle;
  int area;
  int shift;
  String route;
  String latitude;
  String longitude;
  int hasToken;
  Post({
    this.codPost,
    this.postTitle,
    this.area,
    this.route,
    this.latitude,
    this.longitude,
    this.hasToken,
  });

  Map toMap() {
    Map<String, dynamic> map = {
      Helper.tbPostCod: codPost,
      Helper.tbPostPostName: postTitle,
      Helper.tbPostArea: area,
      Helper.tbPostShift: shift,
      Helper.tbPostRoute: route,
      Helper.tbPostLatitude: latitude,
      Helper.tbPostLongitude: longitude,
      Helper.tbPostHasToken: hasToken,
    };
    return map;
  }

  Post.fromMap(Map map) {
    codPost = map[Helper.tbPostCod];
    postTitle = map[Helper.tbPostPostName];
    area = map[Helper.tbPostArea];
    shift = map[Helper.tbPostShift];
    route = map[Helper.tbPostRoute];
    latitude = map[Helper.tbPostLatitude];
    longitude = map[Helper.tbPostLongitude];
    hasToken = map[Helper.tbPostHasToken];
  }

  static Future<dynamic> getHttpPosts() async {
    try {
      var url = 'http://grupoct.com.br/supervision/crud/getPosts.php';
      var response = await http.post(url, body: {'tolken': '14913'});
      if (response.statusCode == 200) {
        List listResponse = json.decode(response.body);
        deletePosts();

        for (var post in listResponse) {
          Post p = Post();
          p.codPost = int.parse(post[Helper.tbPostCod]) ?? 0;
          p.postTitle = post[Helper.tbPostPostName] ?? "1";
          p.shift = int.parse(post[Helper.tbPostShift]) ?? 0;
          p.area = int.parse(post[Helper.tbPostArea]) ?? 0;
          p.route = post[Helper.tbPostRoute] ?? "1";
          p.latitude = post[Helper.tbPostLatitude] ?? "0";
          p.longitude = post[Helper.tbPostLongitude] ?? "0";
          p.hasToken = int.parse(post[Helper.tbPostHasToken]) ?? 0;
          savePost(p);
        }
        return "ATUALIZADO COM SUCESSO";
      }
    } catch (e) {
      return "ERRO AO ATUALIZAR";
    }
  }

  static savePost(Post post) async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.insert(Helper.tbPost, post.toMap());
    } catch (e) {
      print(e);
    }
  }

  static deletePosts() async {
    try {
      Helper helper = Helper();
      var db = await helper.db;
      db.delete(Helper.tbPost);
    } catch (e) {}
  }

  static getMyPosts(area, shift) async {
    try {
      String tbpost = Helper.tbPost;
      Helper helper = Helper();
      var db = await helper.db;
      List listMap = await db.rawQuery(
          "select * from $tbpost where ${Helper.tbPostArea} = $area and ${Helper.tbPostShift} = $shift or ${Helper.tbPostArea} = 10 or ${Helper.tbPostArea} = $area and ${Helper.tbPostShift} = 3");
      List<Post> posts = List();
      for (Map map in listMap) {
        posts.add(Post.fromMap(map));
      }
      return posts;
    } catch (e) {}
  }

  static getPosts() async {
    try {
      String tbpost = Helper.tbPost;
      Helper helper = Helper();
      var db = await helper.db;
      List listMap = await db.rawQuery("select * from $tbpost");
      List<Post> posts = List();
      for (Map map in listMap) {
        posts.add(Post.fromMap(map));
      }
      return posts;
    } catch (e) {}
  }

  static relatarErroNaGeolocalicazao(latitude, longitude, codPosto) async {
    try {
      var url =
          'http://grupoct.com.br/supervision/crud/atualizarGeolocalizacao.php';
      var response = await http.post(url, body: {
        'tolken': '14913',
        'latitude': '$latitude',
        'longitude': "$longitude",
        'codPosto': "$codPosto",
      });
      if (response.statusCode == 200) {
        print(response.body);
        if (response.body == "ok") {
          return true;
        }
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  String toString() {
    return 'Post(codPost: $codPost, postTitle: $postTitle, area: $area, shift: $shift, route: $route, latitude: $latitude, longitude: $longitude)';
  }
}
