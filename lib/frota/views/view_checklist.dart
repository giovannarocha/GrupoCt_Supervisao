import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grupoct_supervisao/base/model/supervisor.dart';
import 'package:grupoct_supervisao/base/telas/home.dart';
import 'package:grupoct_supervisao/base/telas/loader.dart';
import 'package:grupoct_supervisao/frota/models/frota.dart';
import 'package:grupoct_supervisao/frota/models/mvoimentacao_de_frota.dart';
import 'package:grupoct_supervisao/frota/stores/store_checklist.dart';
import 'package:grupoct_supervisao/imagem/views/take_picture.dart';
import 'package:grupoct_supervisao/relatorio/model/item_de_relatorio.dart';
import 'package:grupoct_supervisao/relatorio/model/relatorio.dart';
import 'package:grupoct_supervisao/utils/my_colors.dart';
import 'package:grupoct_supervisao/utils/nav.dart';
import 'package:grupoct_supervisao/widgets/raised_button_default.dart';
import 'package:grupoct_supervisao/widgets/text_subtitle_default.dart';
import 'package:grupoct_supervisao/widgets/textfield_default.dart';

class TelaCheckListDeViatura extends StatefulWidget {
  final bool isBegin;
  final Frota selectedCar;
  TelaCheckListDeViatura(this.selectedCar, this.isBegin);

  @override
  _TelaCheckListDeViaturaState createState() => _TelaCheckListDeViaturaState();
}

class _TelaCheckListDeViaturaState extends State<TelaCheckListDeViatura> {
  final _observableItems = StoreCheckList();
  var kmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.defaultBlue,
      body: _body(size),
      bottomNavigationBar: RaisedButtonDefault("AVANÇAR", _validation, size),
    );
  }

  _body(size) {
    Frota viatura = widget.selectedCar;
    return ListView(
      children: <Widget>[
        _sizedBox(),
        Text(
          "VIATURA SELECIONADA ${viatura.fleetBoard}",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        _sizedBox(),
        TextSubtitleDefault("VALIDAR KM"),
        TextFieldDefault(
          size,
          kmController,
          false,
          keyBoardType: TextInputType.number,
        ),
        Text(
          "Apenas números sem ponto ou virgula",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        _sizedBox(),
        TextSubtitleDefault("NÍVEL DO COMBUSTIVEL"),
        _selectFuelLvl(),
        _sizedBox(),
        TextSubtitleDefault("PROBLEMAS A SEREM RELATADOS?"),
        _hasBreakDOwn(),
      ],
    );
  }

  _selectFuelLvl() {
    return Observer(builder: (_) {
      double _fuelValue = _observableItems.fuelValue;
      String _fuelLevel = _observableItems.fuelLevel;
      return Column(
        children: <Widget>[
          Center(
            child: Text(
              _fuelLevel,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.yellowAccent,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Slider(
                  activeColor: Colors.white,
                  max: 4.0,
                  min: 0.0,
                  divisions: 4,
                  value: _fuelValue,
                  onChanged: (_newValue) {
                    _observableItems.fuelChange(_newValue);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  _hasBreakDOwn() {
    return Observer(builder: (_) {
      int _radioValue = _observableItems.radioValue;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "SIM",
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          ),
          Theme(
            data: ThemeData.dark(),
            child: Radio(
              value: 1,
              groupValue: _radioValue,
              onChanged: _observableItems.radioValueChange,
            ),
          ),
          SizedBox(
            width: 35.0,
          ),
          Text(
            "NÃO",
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          ),
          Theme(
            data: ThemeData.dark(),
            child: Radio(
              value: 0,
              groupValue: _radioValue,
              onChanged: _observableItems.radioValueChange,
            ),
          ),
        ],
      );
    });
  }

  _validation() {
    if (kmController.text.isEmpty || int.tryParse(kmController.text) == null) {
      return _alertDialog(
        "KM ERRADO",
        "Não é permitido espaço em branco ou números com ponto ou virgula!",
        action1: _flatButton(
          "OK",
          () => Navigator.pop(context),
        ),
      );
    }
    Frota viatura = widget.selectedCar;
    if (viatura.fleetKm > int.tryParse(kmController.text)) {
      return _alertDialog(
        "KM divergente",
        "O KM digitado é menor do que o último KM registrado",
        action1: _flatButton("OK", () => Navigator.pop(context)),
      );
    }

    _done(viatura);
  }

  _done(car) async {
    Relatorio relatorio = Relatorio();
    relatorio = await relatorio.retornarRelatorio();
    MovimentacaoDeFrota mov = MovimentacaoDeFrota();
    mov.board = car.fleetBoard;
    mov.fuelLvl = _observableItems.fuelValue.toInt();
    mov.hasBreakDown = _observableItems.radioValue;
    mov.dataHourMov = DateTime.now().toString();
    mov.km = int.parse(kmController.text);
    mov.reportId = relatorio.id;
    mov.typeMov = 1;
    mov.id = DateTime.now().microsecondsSinceEpoch.toString();

    bool isSave = await mov.saveMov(mov);

    if (isSave == false) {
      return _alertDialog("Erro ao salvar",
          "Não foi possível salvar devido a uma falha de conexão",
          action1: _flatButton("OK", () => Navigator.pop(context)));
    }

    ItemDeRelatorio itemDeRelatorio = ItemDeRelatorio();

    itemDeRelatorio.reportId = mov.reportId;
    itemDeRelatorio.id = mov.id;
    itemDeRelatorio.dateTime = mov.dataHourMov;
    itemDeRelatorio.isPost = 2;
    if (widget.isBegin) {
      itemDeRelatorio.type =
          "VIATURA - CHECKLIST RETIRADA - PLACA ${mov.board}";
    } else {
      itemDeRelatorio.type =
          "VIATURA - CHECKLIST DEVOLUÇÃO - PLACA ${mov.board}";
    }
    itemDeRelatorio.doAlIWant(itemDeRelatorio);

    relatorio.status = widget.isBegin ? 2 : 1;
    await relatorio.atualizarRelatorio(relatorio);
    Frota viatura = widget.selectedCar;
    viatura.fleetKm = mov.km;

    await viatura.updateKm(viatura);
    if (mov.hasBreakDown == 1) {
      var page = Loader();
      push(
          context,
          TakePicture(
            telaDestinoAposFoto: page,
            idRelacionadoAFoto: mov.id.toString(),
            tipo: widget.isBegin ? 1 : 1,
          ),
          replace: true);
    } else {
      Supervisor sup = Supervisor();
      sup = await sup.getOnlySupervisor();
      push(
          context,
          Home(
            supervisor: sup,
          ),
          replace: true);
    }
  }

  _flatButton(text, onPressed) {
    return FlatButton(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        onPressed: onPressed);
  }

  _alertDialog(title, content, {action1, action2}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: Colors.red,
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            actions: <Widget>[
              action1,
              action2,
            ],
          );
        });
  }

  _sizedBox() {
    return SizedBox(
      height: 30.0,
    );
  }
}
