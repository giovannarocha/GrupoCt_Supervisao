import 'package:flutter/material.dart';
import 'package:grupoct_supervisao/base/telas/loader.dart';
import 'package:grupoct_supervisao/imagem/views/take_picture.dart';
import 'package:grupoct_supervisao/relatorio/model/item_de_relatorio.dart';
import 'package:grupoct_supervisao/relatorio/model/item_de_relatorio_posto.dart';
import 'package:grupoct_supervisao/relatorio/model/posto_atual.dart';
import 'package:grupoct_supervisao/relatorio/model/relatorio.dart';
import 'package:grupoct_supervisao/relatorio/model/token.dart';
import 'package:grupoct_supervisao/utils/my_colors.dart';
import 'package:grupoct_supervisao/utils/nav.dart';
import 'package:grupoct_supervisao/widgets/drawer_default.dart';
import 'package:grupoct_supervisao/widgets/listtile_default.dart';
import 'package:grupoct_supervisao/widgets/raised_button_default.dart';
import 'package:grupoct_supervisao/widgets/text_subtitle_default.dart';
import 'package:grupoct_supervisao/widgets/textfield_default.dart';

class TelaClienteSelecionado extends StatefulWidget {
  @override
  _TelaClienteSelecionadoState createState() => _TelaClienteSelecionadoState();
}

class _TelaClienteSelecionadoState extends State<TelaClienteSelecionado> {
  PostoAtual postoAtual = PostoAtual();
  List<Token> tokens;
  var textController = TextEditingController();
  var tokenController = TextEditingController();
  var justificouContatoComCliente = false;
  @override
  initState() {
    super.initState();
    PostoAtual.select().then((value) {
      setState(() {
        postoAtual = value;
        if (postoAtual.teveContatoComCliente == 1) {
          justificouContatoComCliente = true;
        }
      });
      if (postoAtual.temToken == 1) {
        Token.select(postoAtual.cod).then((value) {
          tokens = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return;
      },
      child: Scaffold(
        backgroundColor: MyColors.defaultBlue,
        drawer: DrawerDefault(size),
        appBar: AppBar(
          title: postoAtual == null ? "" : Text("${postoAtual.name}"),
          backgroundColor: Colors.grey,
        ),
        body: _body(size, context),
      ),
    );
  }

  _body(size, context) {
    return Builder(builder: (context) {
      return ListView(
        children: <Widget>[
          ListTileDefault(size, "CONTATO COM O CLIENTE",
              () => _mostrarTelaContatoComOCliente(size)),
          ListTileDefault(
              size,
              "CONTATO COM O FUNCIONÁRIO",
              () =>
                  _contatoComFuncionario(context, "CONTATO COM O FUNCIONÁRIO")),
          ListTileDefault(size, "LIVRO DE OCORRÊNCIAS",
              () => _mostrarCategoriasDeLivroDeOcorrencias(size)),
          ListTileDefault(size, "MATERIAL POSTO",
              () => _mostrarCategoriaMaterialCarga(size)),
          ListTileDefault(size, "UNIFORME", () => _tirarFoto("UNIFORME")),
          ListTileDefault(size, "DOCUMENTOS\n(CNV /CRACHÁ)",
              () => _tirarFoto("DOCUMENTOS\n(CNV /CRACHÁ)")),
          ListTileDefault(size, "OCORRÊNCIAS", () => _ocorrencia()),
          ListTileDefault(size, "ENCERRAR VISITA", () => _encerrarVisita()),
        ],
      );
    });
  }

  _contatoComCliente(context, title) {
    _showDialog(context, title, true);
  }

  _contatoComFuncionario(context, title) {
    _showDialog(context, title, false);
  }

  _ocorrencia() {
    ItemDeRelatorioPosto itemDeRelatorio = ItemDeRelatorioPosto();
    itemDeRelatorio.titulo = "OCORRÊNCIA";
    itemDeRelatorio.descricao = "";
    itemDeRelatorio.id = DateTime.now().millisecondsSinceEpoch.toString();
    itemDeRelatorio.idDoRelatorioPosto = postoAtual.movId;
    itemDeRelatorio.temImagem = 0;
    itemDeRelatorio.salvarLocalETentarEnviarHttp(itemDeRelatorio);
    push(
        context,
        TakePicture(
          telaDestinoAposFoto: Loader(),
          idRelacionadoAFoto: itemDeRelatorio.id,
          tipo: 2,
        ));
  }

  _tirarFoto(text) {
    push(
        context,
        TakePicture(
          telaDestinoAposFoto: Loader(),
          idRelacionadoAFoto: text,
          tipo: 2,
        ));
  }

  _mostrarTelaContatoComOCliente(size) {
    if (postoAtual.temToken == 0) {
      _contatoComCliente(context, "CONTATO COM CLIENTE");
    } else {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Card(
              color: MyColors.defaultBlue,
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextSubtitleDefault("ENVIAR TOKEN"),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: tokens.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTileDefault(size, tokens[index].clientName,
                          () async {
                        Token token = Token();
                        token.sendTokenToClient(
                            tokens[index].clientEmail, tokens[index].codPost);
                        _alertSend();
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextSubtitleDefault("VALIDAR TOKEN"),
                  SizedBox(
                    height: 10,
                  ),
                  TextFieldDefault(
                    size,
                    tokenController,
                    false,
                    keyBoardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButtonDefault("VALIDAR", () async {
                    var aux = await _validarToken();
                    if (aux == "ok") {
                      tokenController.clear();
                      Navigator.pop(context);
                      _contatoComCliente(
                          context, "CONTATO COM O CLIENTE - TOKEN VALIDADO");
                    } else {
                      _alert(tokenController.text);
                      tokenController.clear();
                    }
                  }, size),
                ],
              ));
        },
      );
    }
  }

  _validarToken() async {
    Token token = Token();
    var aux = await token.validateToken(tokenController.text, postoAtual.cod);
    if (aux == "ok") {
      return "ok";
    } else {
      return "nok";
    }
  }

  _mostrarCategoriaMaterialCarga(size) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Card(
          color: MyColors.defaultBlue,
          child: ListView(
            children: <Widget>[
              ListTileDefault(size, "CONFERÊNCIA DE MATERIAL - CONFORME",
                  () => _tirarFoto("MATERIAL CARGA - CONFERÊNCIA - CONFORME")),
              ListTileDefault(
                  size,
                  "CONFERÊNCIA DE MATERIAL - NÃO CONFORME",
                  () => _tirarFoto(
                      "MATERIAL CARGA - CONFERÊNCIA - NÃO CONFORME")),
              ListTileDefault(size, "ENTREGA DE MATERIAL",
                  () => _tirarFoto("MATERIAL CARGA - ENTREGA DE MATERIAL")),
              ListTileDefault(size, "RETIRADA DE MATERIAL",
                  () => _tirarFoto("MATERIAL CARGA - RETIRADA DE MATERIAL")),
            ],
          ),
        );
      },
    );
  }

  _encerrarVisita() async {
    if (justificouContatoComCliente == false) {
      _showDialog(context, "JUSTIFICATIVA DE NÃO CONTATO COM O CLIENTE", false,
          justificativa: true);
    } else {
      Relatorio relatorio = Relatorio();
      relatorio = await relatorio.retornarRelatorio();
      relatorio.status = 2;
      PostoAtual.delete();
      ReportComplement reportComplement = ReportComplement();
      reportComplement.tbReportToUpdateId = postoAtual.movId;
      reportComplement.tbReportToUpdateType = 2;
      reportComplement.tbReportToUpdateDt = DateTime.now().toString();
      reportComplement.doAlIWant(reportComplement);
      await relatorio.atualizarRelatorio(relatorio);
      push(context, Loader());
    }
  }

  _mostrarCategoriasDeLivroDeOcorrencias(size) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Card(
          color: MyColors.defaultBlue,
          child: ListView(
            children: <Widget>[
              ListTileDefault(size, "PÁGINA DO DIA",
                  () => _tirarFoto("LIVRO DE OCORRÊNCIAS - PÁGINA DO DIA")),
              ListTileDefault(
                  size,
                  "PÁGINA PARA DIVERGÊNCIA",
                  () => _tirarFoto(
                      "LIVRO DE OCORRÊNCIAS - PÁGINA PARA DIVERGÊNCIA")),
              ListTileDefault(
                  size,
                  "PÁGINA DE RELATO DE OCORRÊNCIA",
                  () => _tirarFoto(
                      "LIVRO DE OCORRÊNCIAS - PÁGINA DE RELATO DE OCORRÊNCIA")),
              ListTileDefault(
                  size,
                  "PÁGINA COM ORIENTAÇÃO PARA A EQUIPE",
                  () => _tirarFoto(
                      "LIVRO DE OCORRÊNCIAS - PÁGINA COM ORIENTAÇÃO PARA A EQUIPE")),
            ],
          ),
        );
      },
    );
  }

  _alert(token) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: Colors.red,
            content: Text(
              "TOKEN $token INCORRETO",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            actions: [
              FlatButton(
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  _alertSend() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: MyColors.defaultBlue,
            content: Text(
              "TOKEN ENVIADO COM SUCESSO",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            actions: [
              FlatButton(
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  _showDialog(context, title, contatoComCliente, {bool justificativa = false}) {
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
                      onPressed: () {
                        ItemDeRelatorioPosto itemDeRelatorioPosto =
                            ItemDeRelatorioPosto();
                        if (textController.text.isNotEmpty) {
                          itemDeRelatorioPosto.titulo = title;
                          itemDeRelatorioPosto.descricao = textController.text;
                          itemDeRelatorioPosto.idDoRelatorioPosto =
                              postoAtual.movId;
                          itemDeRelatorioPosto.salvarLocalETentarEnviarHttp(
                              itemDeRelatorioPosto);
                          if (justificativa) {
                            justificouContatoComCliente = true;
                            postoAtual.teveContatoComCliente = 1;
                            PostoAtual.update(postoAtual);
                            _encerrarVisita();
                          }

                          textController.clear();
                          if (contatoComCliente) {
                            justificouContatoComCliente = true;
                            postoAtual.teveContatoComCliente = 1;
                            PostoAtual.update(postoAtual);
                            ReportComplement reportComplement =
                                ReportComplement();
                            reportComplement.tbReportToUpdateId =
                                postoAtual.movId;
                            reportComplement.tbReportToUpdateClientContact = 1;
                            reportComplement.tbReportToUpdateType = 1;
                            reportComplement.doAlIWant(reportComplement);
                          }
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
}
