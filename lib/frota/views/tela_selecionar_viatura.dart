import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grupoct_supervisao/frota/models/frota.dart';
import 'package:grupoct_supervisao/frota/stores/store_selecionar_viatura.dart';
import 'package:grupoct_supervisao/frota/views/view_checklist.dart';
import 'package:grupoct_supervisao/utils/my_colors.dart';
import 'package:grupoct_supervisao/utils/nav.dart';

class TelaSelecionarViatura extends StatefulWidget {
  final relatorio;
  TelaSelecionarViatura({this.relatorio});

  @override
  _TelaSelecionarViaturaState createState() => _TelaSelecionarViaturaState();
}

class _TelaSelecionarViaturaState extends State<TelaSelecionarViatura> {
  final _listaDeViaturasMobx = StoreSelecionarViatura();

  @override
  void initState() {
    super.initState();
    _listaDeViaturasMobx.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.defaultBlue,
      body: _body(),
    );
  }

  _body() {
    return Observer(builder: (_) {
      List<Frota> _listaDeViaturas = _listaDeViaturasMobx.viaturas;
      if (_listaDeViaturasMobx.error != null) {
        return _showError();
      }
      if (_listaDeViaturas == null) {
        return _showLoad();
      }

      return _showCars(_listaDeViaturas);
    });
  }

  _showError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10.0),
          child: Text(
            "ERRO - Não foi possível estabelecer conexão para obter as informações \n Clique no simbolo abaixo para tentar recarregar",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 26),
          ),
        ),
        GestureDetector(
          onTap: _listaDeViaturasMobx.fetch,
          child: Icon(
            Icons.refresh,
            color: Colors.white,
            size: 152,
          ),
        )
      ],
    );
  }

  _showLoad() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    );
  }

  _showCars(_listCars) {
    return ListView.builder(
      itemCount: _listCars != null ? _listCars.length : 0.0,
      itemBuilder: (context, index) {
        return _listItem(_listCars[index]);
      },
    );
  }

  _listItem(Frota viatura) {
    String text = "";
    DateTime.now().weekday == viatura.fleetCaster
        ? text = "RODIZIO"
        : text = "";
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.white,
        Colors.white30,
      ])),
      margin: EdgeInsets.all(2.0),
      child: ListTile(
        onTap: () => _selectCar(viatura),
        trailing: Text(
          text,
          style: TextStyle(
            color: Colors.yellowAccent,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        leading: Icon(
          Icons.directions_car,
          color: MyColors.defaultBlue,
          size: 45.0,
        ),
        title: Text(
          viatura.fleetBoard,
          style: TextStyle(
              color: MyColors.defaultBlue,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Text("VIATURA: " + viatura.fleetNick),
      ),
    );
  }

  _selectCar(Frota viatura) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: MyColors.defaultBlue,
            title: Text(
              "CONFIRMAR VIATURA",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              "Você selecionou a viatura com a placa ${viatura.fleetBoard}, tem certeza que deseja continuar?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "CONTINUAR",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Frota.save(viatura);
                  push(context, TelaCheckListDeViatura(viatura, true),
                      replace: true);
                },
              ),
              FlatButton(
                child: Text(
                  "CANCELAR",
                  style: TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
