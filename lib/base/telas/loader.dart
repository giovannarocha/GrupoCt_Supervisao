import 'package:flutter/material.dart';
import 'package:grupoct_supervisao/base/model/supervisor.dart';
import 'package:grupoct_supervisao/base/telas/home.dart';
import 'package:grupoct_supervisao/utils/nav.dart';
import 'package:grupoct_supervisao/utils/my_colors.dart';

import 'login.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _firstPage(context);
    Size size = MediaQuery.of(context).size;
    return Container(
        color: MyColors.defaultBlue,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/icon.png",
                width: size.width / 3,
              ),
              Spacer(),
              Center(
                child: SizedBox(
                  width: size.width / 4,
                  height: size.width / 4,
                  child: CircularProgressIndicator(
                    strokeWidth: 10.0,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25.0),
                child: Center(
                  child: Text(
                    "AGUARDE",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        decoration: TextDecoration.none),
                  ),
                ),
              ),
              Spacer(),
              Spacer(),
            ],
          ),
        ));
  }

  _firstPage(context) async {
    Supervisor supervisor = Supervisor();
    List list = await supervisor.getSupervisor();
    if (list.length < 1) {
      push(context, Login(), replace: true);
    } else {
      supervisor = list[0];
      push(context, Home(supervisor: supervisor), replace: true);
    }
  }
}
