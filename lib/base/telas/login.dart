import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grupoct_supervisao/base/model/post.dart';
import 'package:grupoct_supervisao/base/model/supervisor.dart';
import 'package:grupoct_supervisao/base/telas/loader.dart';
import 'package:grupoct_supervisao/relatorio/model/token.dart';
import 'package:grupoct_supervisao/utils/nav.dart';
import 'package:grupoct_supervisao/utils/my_colors.dart';
import 'package:grupoct_supervisao/widgets/raised_button_default.dart';
import 'package:grupoct_supervisao/widgets/text_subtitle_default.dart';
import 'package:grupoct_supervisao/widgets/textfield_default.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loginError = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MyColors.defaultBlue,
      body: ListView(
        children: <Widget>[
          _header(size),
          Divider(
            height: size.height * .12,
            color: Colors.transparent,
          ),
          TextSubtitleDefault("USUÁRIO"),
          TextFieldDefault(size, userController, false),
          Divider(
            color: Colors.transparent,
          ),
          TextSubtitleDefault("SENHA"),
          TextFieldDefault(size, passwordController, true),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: MyColors.defaultBlue,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButtonDefault("ENTRAR", _login, size),
            Visibility(
                visible: loginError,
                child: Container(
                    margin: EdgeInsets.all(8.0),
                    child: Text(
                      "Login ou senha incorreto",
                      style: TextStyle(color: Colors.yellow, fontSize: 20.0),
                    )))
          ],
        ),
      ),
    );
  }

  _header(Size size) {
    return Container(
      padding: EdgeInsets.all(50),
      child: Image.asset("assets/images/logo.jpg"),
      width: size.width,
      height: size.height / 3.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(140.0)),
      ),
    );
  }

  _login() async {
    if (userController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        loginError = true;
      });
    } else {
      await _httpLogin();
    }
  }

  Future _httpLogin() async {
    String user = userController.text;
    String password = passwordController.text;
    var url = 'http://grupoct.com.br/supervision/crud/login.php';
    var response = await http.post(url,
        body: {'login': '$user', 'password': '$password', 'tolken': '14913'});

    if (response.statusCode == 200) {
      Supervisor sup = Supervisor();
      Map mapResponse = json.decode(response.body);
      bool validator = mapResponse["haveSupervisor"];
      if (validator) {
        setState(() {
          loginError = false;
        });
        sup.id = int.parse(mapResponse["tbSupId"]);
        sup.name = mapResponse["tbSupName"];
        sup.shift = int.parse(mapResponse["tbSupShift"]);
        sup.area = int.parse(mapResponse["tbSupArea"]);
        sup.picture = mapResponse["tbSupPicture"];
        sup.phoneNumber = mapResponse["tbSupPhoneNumber"];
        sup.saveSupervisor(sup);
        Post.getHttpPosts();
        Token.getTokens();
        push(context, Loader(), replace: true);
      } else {
        setState(() {
          loginError = true;
        });
      }
    } else {
      setState(() {
        loginError = true;
      });
    }
  }
}
