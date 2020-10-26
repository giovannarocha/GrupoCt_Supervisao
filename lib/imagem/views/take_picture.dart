import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grupoct_supervisao/imagem/model/tb_image.dart';
import 'package:grupoct_supervisao/imagem/stores/store_take_picture.dart';
import 'package:grupoct_supervisao/imagem/utils/image_take.dart';
import 'package:grupoct_supervisao/relatorio/model/item_de_relatorio_posto.dart';
import 'package:grupoct_supervisao/relatorio/model/posto_atual.dart';
import 'package:grupoct_supervisao/utils/my_colors.dart';
import 'package:grupoct_supervisao/utils/nav.dart';
import 'package:grupoct_supervisao/widgets/raised_button_default.dart';
import 'package:grupoct_supervisao/widgets/text_subtitle_default.dart';
import 'package:grupoct_supervisao/widgets/textfield_default.dart';

class TakePicture extends StatefulWidget {
  final int tipo;
  final String idRelacionadoAFoto;
  final dynamic telaDestinoAposFoto;

  TakePicture(
      {Key key, this.tipo, this.idRelacionadoAFoto, this.telaDestinoAposFoto})
      : super(key: key);

  @override
  _TakePictureState createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
  var observableTakePicture = StoreTakePicture();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => push(context, widget.telaDestinoAposFoto),
      child: Scaffold(
        backgroundColor: MyColors.defaultBlue,
        body: ListView(
          children: <Widget>[
            Divider(color: Colors.transparent),
            TextSubtitleDefault("DESCRIÇÃO"),
            Divider(
              color: Colors.transparent,
            ),
            Observer(builder: (_) {
              return TextFieldDefault(
                size,
                observableTakePicture.controller,
                false,
              );
            }),
            Divider(
              color: Colors.transparent,
              height: 20,
            ),
            TextSubtitleDefault("INSIRA FOTO SE APLICÁVEL"),
            Divider(color: Colors.transparent),
            Center(
              child: GestureDetector(
                onTap: () => _onTap(),
                child: Observer(builder: (_) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0)),
                    padding: EdgeInsets.all(10),
                    width: size.width * 0.9,
                    height: size.height * .54,
                    child: observableTakePicture.file != null
                        ? Image.file(
                            observableTakePicture.file,
                            fit: BoxFit.contain,
                          )
                        : Icon(
                            Icons.photo_camera,
                            color: MyColors.defaultBlue,
                            size: size.width * .5,
                          ),
                  );
                }),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Builder(
          builder: (context) {
            return Observer(builder: (_) {
              return RaisedButtonDefault(
                "SALVAR",
                () => _onSubmited(context),
                size,
              );
            });
          },
        ),
      ),
    );
  }

  _onTap() async {
    File aux = await ImageTake.onClickCam();
    observableTakePicture.changeImage(aux);
  }

  _onSubmited(context) async {
    String id;
    if (observableTakePicture.file.path.isEmpty) {
      print("erro");
      return;
    }

    if (widget.tipo == 2) {
      PostoAtual postoAtual = PostoAtual();
      postoAtual = await PostoAtual.select();

      ItemDeRelatorioPosto itemDeRelatorio = ItemDeRelatorioPosto();
      id = itemDeRelatorio.id;
      itemDeRelatorio.idDoRelatorioPosto = postoAtual.movId;
      itemDeRelatorio.titulo = widget.idRelacionadoAFoto;
      itemDeRelatorio.temImagem = 1;
      itemDeRelatorio.salvarLocalETentarEnviarHttp(itemDeRelatorio);
    }
    if (id.isEmpty) {
      id = widget.idRelacionadoAFoto;
    }
    TbImage tbImage = TbImage();
    String imageName =
        "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
    tbImage
        .doAllIWant(
      observableTakePicture.file,
      imageName,
      observableTakePicture.controller.text,
      returnDirectory(),
      id,
    )
        .then((value) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            var page = widget.telaDestinoAposFoto;
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              backgroundColor: MyColors.defaultBlue,
              content: Text(
                "DESEJA ADICIONAR OUTRA FOTO?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("NÃO"),
                  onPressed: () => push(context, page, replace: true),
                ),
                FlatButton(
                  child: Text("SIM"),
                  onPressed: () {
                    observableTakePicture.changeImage(null);
                    observableTakePicture.clearValue();
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    });
  }

  returnDirectory() {
    switch (widget.tipo) {
      case 1:
        return "checklist";
        break;
      case 2:
        return "reportItem";
        break;
      default:
    }
  }
}
