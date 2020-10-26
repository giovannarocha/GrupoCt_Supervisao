import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grupoct_supervisao/base/model/post.dart';
import 'package:grupoct_supervisao/relatorio/model/item_de_relatorio.dart';
import 'package:grupoct_supervisao/relatorio/model/posto_atual.dart';
import 'package:grupoct_supervisao/relatorio/model/relatorio.dart';
import 'package:grupoct_supervisao/relatorio/stores/store_client_report.dart';
import 'package:grupoct_supervisao/relatorio/telas/tela_cliente_selecionado.dart';
import 'package:grupoct_supervisao/utils/my_colors.dart';
import 'package:grupoct_supervisao/utils/nav.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class TelaSelecionarCliente extends StatefulWidget {
  @override
  _TelaSelecionarClienteState createState() => _TelaSelecionarClienteState();
}

class _TelaSelecionarClienteState extends State<TelaSelecionarCliente> {
  final _observableList = StoreClientReport();
  @override
  void initState() {
    super.initState();
    _observableList.getMyPosts();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.defaultBlue,
      body: _body(size, context),
    );
  }

  _body(size, context) {
    Size size = MediaQuery.of(context).size;
    return Observer(builder: (_) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Meus Postos",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Radio(
                value: 0,
                groupValue: _observableList.listController,
                onChanged: (value) => _observableList.controller(value, 1, 1),
              ),
              Text(
                "Todos",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Radio(
                value: 1,
                groupValue: _observableList.listController,
                onChanged: (value) => _observableList.controller(value, 1, 1),
              ),
            ],
          ),
          _lwbuilder(size),
        ],
      );
    });
  }

  ListView _lwbuilder(Size size) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount:
          _observableList.posts != null ? _observableList.posts.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return _listTilePost(size, _observableList.posts[index]);
      },
    );
  }

  _listTilePost(size, Post post) {
    return Observer(builder: (_) {
      return Container(
        padding: EdgeInsets.all(size.width * .017),
        margin: EdgeInsets.only(
            top: size.width * .02,
            right: size.width * .02,
            left: size.width * .02),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.white, Colors.white38])),
        child: ListTile(
          enabled: _observableList.isEnabled,
          onTap: () {
            _observableList.setIsEnabled();
            _validarGeolocalizao(post);
          },
          title: Center(
            child: Text(
              "${post.codPost} - ${post.postTitle}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: size.height * .025,
                  color: MyColors.defaultBlue,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    });
  }

  _validarGeolocalizao(Post post) async {
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    geolocator.checkGeolocationPermissionStatus();
    Location location = new Location();
    LocationData _locationData;
    _locationData = await location.getLocation();

    double postLatitude = double.parse(post.latitude);
    double postLongitude = double.parse(post.longitude);

    double diference = await Geolocator().distanceBetween(postLatitude,
        postLongitude, _locationData.latitude, _locationData.longitude);

    if (diference > 800) {
      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
          double.parse(post.latitude), double.parse(post.longitude));
      String texto =
          " POSTO : ${placemark[0].thoroughfare}, ${placemark[0].subThoroughfare}";
      List<Placemark> placemark2 = await Geolocator().placemarkFromCoordinates(
          _locationData.latitude, _locationData.longitude);
      texto +=
          "\n ESTA EM: ${placemark2[0].thoroughfare}, ${placemark2[0].subThoroughfare}";
      _alertErroGeoLocalizacao(
          texto, _locationData.latitude, _locationData.longitude, post.codPost);
    } else {
      _iniciarInspecaoNoPosto(post, _locationData.latitude.toString(),
          _locationData.longitude.toString());
    }
  }

  _alertErroGeoLocalizacao(texto, latitude, longitude, codPosto) {
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
              "POSTO FORA DA LOCALIZAÇÃO",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              texto,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    "CANCELAR",
                    style: TextStyle(fontSize: 17),
                  ),
                  onPressed: () {
                    _observableList.setIsEnabled();

                    Navigator.pop(context);
                  }),
              /*FlatButton(
                child: Text(
                  "RELATAR ERRO",
                  style: TextStyle(fontSize: 17),
                ),
                onPressed: () => Post.relatarErroNaGeolocalicazao(
                    latitude, longitude, codPosto),
              ),*/
            ],
          );
        });
  }

  _iniciarInspecaoNoPosto(Post post, latitude, longitude) async {
    Relatorio relatorio = Relatorio();
    relatorio = await relatorio.retornarRelatorio();
    relatorio.status = 4;
    relatorio.atualizarRelatorio(relatorio);
    ItemDeRelatorio itemDeRelatorio = ItemDeRelatorio();
    itemDeRelatorio.dateTime = DateTime.now().toString();
    itemDeRelatorio.id = DateTime.now().millisecondsSinceEpoch.toString();
    itemDeRelatorio.isPost = 1;
    itemDeRelatorio.type = "${post.codPost} - ${post.postTitle}";
    itemDeRelatorio.reportId = relatorio.id.toString();
    PostoAtual postoAtual = PostoAtual();
    postoAtual.cod = post.codPost;
    postoAtual.latitude = latitude;
    postoAtual.longitude = longitude;
    postoAtual.movId = itemDeRelatorio.id;
    postoAtual.name = post.postTitle;
    postoAtual.reportId = relatorio.id.toString();
    postoAtual.thisDate = itemDeRelatorio.dateTime;
    postoAtual.temToken = post.hasToken;
    PostoAtual.save(postoAtual);
    await itemDeRelatorio.doAlIWant(itemDeRelatorio);
    push(context, TelaClienteSelecionado(), replace: true);
    _observableList.setIsEnabled();
  }
}
