import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grupoct_supervisao/base/telas/loader.dart';
import 'package:grupoct_supervisao/relatorio/model/relatorio.dart';
import 'package:grupoct_supervisao/relatorio/stores/store_meal.dart';
import 'package:grupoct_supervisao/utils/my_colors.dart';
import 'package:grupoct_supervisao/utils/nav.dart';
import 'package:grupoct_supervisao/widgets/text_subtitle_default.dart';

class Meal extends StatelessWidget {
  final bool mealBegin;

  Meal({this.mealBegin});

  final observableMeal = StoreMeal();

  @override
  Widget build(BuildContext context) {
    if (mealBegin == true) {
      observableMeal.changeStart("this");
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      backgroundColor: MyColors.defaultBlue,
      body: _body(),
    );
  }

  _body() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextSubtitleDefault("HORÁRIO DE REFEIÇÃO"),
          Container(
            margin: EdgeInsets.only(left: 60, right: 60, top: 25),
            child: Image.asset("assets/images/meal.png"),
          ),
          Observer(
            builder: (_) {
              return Column(
                children: <Widget>[
                  observableMeal.start == null
                      ? _iconButton(
                          Icons.play_arrow, "INICIAR HORÁRIO DE REFEIÇÃO")
                      : _iconButton(Icons.stop, "FINALZAR HORÁRIO DE REFEIÇÃO"),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  _iconButton(icon, text) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () => _onTap(context),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 5),
              child: Icon(
                icon,
                size: 90,
              ),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      );
    });
  }

  _onTap(context) async {
    if (observableMeal.start == null) {
      Relatorio supervisionReportBegin = Relatorio();
      supervisionReportBegin = await supervisionReportBegin.retornarRelatorio();
      DateTime now = new DateTime.now();
      observableMeal.changeStart(now.toString());
      supervisionReportBegin.status = 3;
      supervisionReportBegin.dataHoraInicioRefeicao = now.toString();
      supervisionReportBegin.fezRefeicao = 1;
      await supervisionReportBegin.atualizarRelatorio(supervisionReportBegin);
    } else {
      observableMeal.changeStart(null);
      Relatorio supervisionReportEnd = Relatorio();
      supervisionReportEnd = await supervisionReportEnd.retornarRelatorio();
      DateTime now = new DateTime.now();
      supervisionReportEnd.status = 2;
      supervisionReportEnd.dataHoraFimRefeicao = now.toString();
      await supervisionReportEnd.atualizarRelatorio(supervisionReportEnd);
      push(context, Loader());
    }
  }
}
