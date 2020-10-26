import 'package:flutter/material.dart';
import 'package:grupoct_supervisao/utils/my_colors.dart';
import 'package:grupoct_supervisao/widgets/text_subtitle_default.dart';
import 'package:grupoct_supervisao/widgets/textfield_default.dart';

class TelaMovimentacao extends StatefulWidget {
  const TelaMovimentacao({Key key}) : super(key: key);

  @override
  _TelaMovimentacaoState createState() => _TelaMovimentacaoState();
}

class _TelaMovimentacaoState extends State<TelaMovimentacao> {
  @override
  var posto = TextEditingController();
  String dropdownValue = 'ESCOLHA A OCORRÊNCIA';
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(
        backgroundColor: MyColors.defaultBlue,
        body: _firstChild(size),
      ),
    );
  }

  _firstChild(size) {
    return ListView(
      children: [
        SizedBox(
          height: 10,
        ),
        TextSubtitleDefault("POSTO"),
        TextFieldDefault(size, posto, false),
        SizedBox(
          height: 10,
        ),
        TextSubtitleDefault("OCORRÊNCIA"),
        DropdownButton<String>(
          value: dropdownValue,
          onChanged: (value) {
            setState(() {
              dropdownValue = value;
            });
          },
          items: <String>[
            'ESCOLHA A OCORRÊNCIA',
            'FALTA',
            'RECICLAGEM',
            'FÉRIAS',
            'CONTRATAÇÃO PENDENTE',
            'RECOLHIMENTO',
            'EFETIVAÇÃO',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
