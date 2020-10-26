import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:grupoct_supervisao/base/model/post.dart';
import 'package:grupoct_supervisao/base/model/supervisor.dart';
import 'package:grupoct_supervisao/frota/models/frota.dart';
import 'package:grupoct_supervisao/frota/views/tela_selecionar_viatura.dart';
import 'package:grupoct_supervisao/frota/views/view_checklist.dart';
import 'package:grupoct_supervisao/imagem/model/tb_image.dart';
import 'package:grupoct_supervisao/relatorio/model/item_de_relatorio.dart';
import 'package:grupoct_supervisao/relatorio/model/item_de_relatorio_posto.dart';
import 'package:grupoct_supervisao/relatorio/model/relatorio.dart';
import 'package:grupoct_supervisao/relatorio/model/token.dart';
import 'package:grupoct_supervisao/relatorio/telas/tela_cliente_selecionado.dart';
import 'package:grupoct_supervisao/relatorio/telas/tela_movimentacao.dart';
import 'package:grupoct_supervisao/relatorio/telas/tela_selecionar_cliente.dart';
import 'package:grupoct_supervisao/utils/nav.dart';
import 'package:grupoct_supervisao/utils/my_colors.dart';
import 'package:grupoct_supervisao/widgets/drawer_default.dart';
import 'package:grupoct_supervisao/widgets/listtile_default.dart';
import 'package:intl/intl.dart';

import '../../relatorio/telas/meal.dart';

class Home extends StatefulWidget {
  final Supervisor supervisor;
  const Home({Key key, this.supervisor}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var textController = TextEditingController();
  bool statusBegin = false;
  bool statusCheckCar = false;
  bool statusSupervision = false;
  Relatorio relatorio = Relatorio();
  Relatorio sr = Relatorio();

  @override
  void initState() {
    super.initState();
    _verificarQualStatus(widget.supervisor.id);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return;
        },
        child: Scaffold(
          appBar: _appBar(size),
          drawer: DrawerDefault(size),
          backgroundColor: MyColors.defaultBlue,
          body: ListView(
            children: <Widget>[
              _statusIniciarODia(size),
              _statusAntesSelecionarViatura(size),
              _statusInspecaoPosto(size),
            ],
          ),
        ),
      ),
    );
  }

  _appBar(Size size) {
    return AppBar(
      title: Center(
        child: Text(
          "CENTURION",
          style: TextStyle(
              color: MyColors.defaultBlue,
              fontSize: size.height * .04,
              fontWeight: FontWeight.bold),
        ),
      ),
      actions: <Widget>[
        Container(
            margin: EdgeInsets.all(size.width * .02),
            child: Image.asset("assets/images/icon.png")),
      ],
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: MyColors.defaultBlue,
      ),
    );
  }

  _statusInspecaoPosto(Size size) {
    return Visibility(
      visible: statusSupervision,
      child: Column(
        children: <Widget>[
          ListTileDefault(size, "INSPECIONAR POSTO", _inspectPost),
          ListTileDefault(size, "HORÁRIO DE REFEIÇÃO", _horarioDeRefeicao),
          ListTileDefault(size, "ABASTECIMENTO / LAVAGEM", _abastecimento),
          ListTileDefault(size, "APOIO LOGISTICO", _apoioLogistico),
          ListTileDefault(size, "RELATAR OCORRÊNCIA", _ocorrencia),
          ListTileDefault(size, "DEVOLVER VIATURA", _returnFleet),
        ],
      ),
    );
  }

  _ocorrencia() {
    _contentDialog("OCORRÊNCIA");
  }

  _apoioLogistico() {
    _contentDialog("APOIO LOGISTICO");
  }

  _abastecimento() {
    _contentDialog("ABASTECIMENTO / LAVAGEM");
  }

  _movimentacaoDeEfetivo() {
    push(context, TelaMovimentacao());
  }

  _contentDialog(title) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: MyColors.defaultBlue,
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: TextField(
                      controller: textController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                      minLines: 1,
                      maxLines: 10,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: FlatButton(
                      child: Text(
                        "CANCELAR",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: FlatButton(
                      onPressed: () async {
                        ItemDeRelatorio reportMov = ItemDeRelatorio();
                        if (textController.text.isNotEmpty) {
                          Relatorio supervisionReport = Relatorio();
                          supervisionReport =
                              await supervisionReport.retornarRelatorio();
                          reportMov.type = title;
                          reportMov.descr = textController.text;
                          reportMov.id =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          reportMov.reportId = supervisionReport.id.toString();
                          reportMov.dateTime = DateTime.now().toString();
                          reportMov.doAlIWant(reportMov);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "SALVAR",
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  _statusAntesSelecionarViatura(Size size) {
    return Visibility(
      visible: statusCheckCar,
      child: Column(
        children: <Widget>[
          ListTileDefault(size, "SELECIONAR VIATURA", _fleet),
          ListTileDefault(size, "MOVIMENTAÇÕES", _movimentacaoDeEfetivo),
          ListTileDefault(size, "RELATAR OCORRÊNCIA", _ocorrencia),
          ListTileDefault(size, "ENCERRAR PLANTÃO", _encerrarPlantao),
        ],
      ),
    );
  }

  _horarioDeRefeicao() {
    push(context, Meal());
  }

  _statusIniciarODia(Size size) {
    return Visibility(
        visible: statusBegin,
        child: ListTileDefault(size, "INICIAR O PLANTÃO", _iniciarPlantao));
  }

  _verificarQualStatus(id) async {
    Relatorio sr = Relatorio();
    sr = await sr.retornarRelatorio();
    if (sr == null) {
      _statusControlador(0);
    } else {
      _statusControlador(sr.status);
      relatorio = sr;
    }
  }

  _inspectPost() {
    push(context, TelaSelecionarCliente());
  }

  _statusControlador(status) {
    switch (status) {
      case 1:
        setState(() {
          statusBegin = false;
          statusCheckCar = true;
          statusSupervision = false;
        });
        break;
      case 2:
        setState(() {
          statusBegin = false;
          statusCheckCar = false;
          statusSupervision = true;
        });
        break;
      case 3:
        // meal
        push(context, Meal(mealBegin: true));
        break;
      case 4:
        push(context, TelaClienteSelecionado());
        break;
      case 9:
        setState(() {
          _enviarEncerramentoPlantaoViaHttp();
          statusBegin = false;
          statusCheckCar = false;
          statusSupervision = false;
        });
        break;
      default:
        setState(() {
          statusBegin = true;
          statusCheckCar = false;
          statusSupervision = false;
        });
        break;
    }
  }

  _iniciarPlantao() {
    DateTime now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy HH:mm');
    String formatted = formatter.format(now);
    _showDialog("INICIAR O PLANTÃO", "$formatted\n DESEJA INICIAR O PLANTÃO?",
        () {
      Relatorio beginSupReport = Relatorio();
      beginSupReport.id = now.microsecondsSinceEpoch.toString();
      beginSupReport.idDoSupervisor = widget.supervisor.id;
      beginSupReport.dataHoraComeco = now.toString();
      beginSupReport.status = 1;
      _saveAndUpdateSupReport(beginSupReport);
      Post.getHttpPosts();
      Token.getTokens();
      Navigator.pop(context);
    }, now: now);
  }

  _saveAndUpdateSupReport(sr) async {
    var ret = await sr.salvarHttpRelatorio(sr);
    if (ret == "true") {
      sr.salvarRelatorio(sr);
      _statusControlador(sr.status);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              backgroundColor: Colors.red,
              title: Text(
                "ERRO AO INICIAR",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Não possivel iniciar o plantão por falha na conexão, tente novamente",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "ok",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            );
          });
    }
  }

  _encerrarPlantao() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy HH:mm');
    String formatted = formatter.format(now);
    _showDialog("ENCERRAR O PLANTÃO", "$formatted\n DESEJA ENCERRAR O PLANTÃO?",
        () {
      _encerrarPlantaoVeificarEnviarTudo();
      Navigator.pop(context);
    }, now: now);
  }

  _returnFleet() async {
    Frota fleetCars = await Frota.select();
    push(context, TelaCheckListDeViatura(fleetCars, false));
  }

  _encerrarPlantaoVeificarEnviarTudo() async {
    Relatorio srEnd = Relatorio();
    srEnd = await srEnd.retornarRelatorio();
    srEnd.dataHoraFim = DateTime.now().toString();
    print("_endDutyVerifyIfSendAll $srEnd");
    srEnd.atualizarRelatorio(srEnd);
    ItemDeRelatorio reportMov = ItemDeRelatorio();
    bool validateReportMov = await reportMov.cleanDbReportMov();
    ItemDeRelatorioPosto reportItem = ItemDeRelatorioPosto();
    bool validadeReportItem =
        await reportItem.tentarEnviarViaHTTPPraLimparBanco();
    TbImage image = TbImage();
    bool validateImages = await image.upload();
    print(
        "ItemDeRelatorio: $validateReportMov ItemDeRelatorioPosto: $validadeReportItem Images: $validateImages");
    if (validateReportMov && validadeReportItem && validateImages) {
      _enviarEncerramentoPlantaoViaHttp();
    } else {
      _showRegularDialog();
    }
  }

  _enviarEncerramentoPlantaoViaHttp() async {
    sr = await sr.retornarRelatorio();
    sr.status = 0;
    var ret = await sr.atualizarHttpRelatorio(sr);
    if (ret == "true") {
      await relatorio.delete();
      Frota.delete();
      Relatorio supr = Relatorio();
      supr.status = 0;
      sr = null;
      relatorio = supr;
      _statusControlador(relatorio.status);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              backgroundColor: Colors.red,
              title: Text(
                "ERRO AO ENCERRAR",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Não possivel encerrar o plantão por falha na conexão, tente novamente",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "ok",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            );
          });
    }
  }

  _fleet() {
    push(
        context,
        TelaSelecionarViatura(
          relatorio: relatorio,
        ));
  }

  _showRegularDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          content: Text(
            "NÃO FOI POSSÍVEL FINALIZAR DEVIDO FALHA NA CONEXÃO, TENTE NOVAMENTE.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        );
      },
    );
  }

  _showDialog(title, text, action, {now}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              backgroundColor: MyColors.defaultBlue,
              title: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "CANCELAR",
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () => action(),
                  child: Text(
                    "CONTINUAR",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 16.0,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
