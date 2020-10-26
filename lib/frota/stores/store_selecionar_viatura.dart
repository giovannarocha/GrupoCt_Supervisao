import 'package:grupoct_supervisao/frota/models/frota.dart';
import 'package:mobx/mobx.dart';
part 'store_selecionar_viatura.g.dart';

class StoreSelecionarViatura = _StoreSelecionarViaturaBase
    with _$StoreSelecionarViatura;

abstract class _StoreSelecionarViaturaBase with Store {
  @observable
  List<Frota> viaturas;

  @observable
  Exception error;

  @action
  fetch() async {
    try {
      error = null;
      viaturas = await Frota.getHttpFleetCars();
    } catch (e) {
      error = Exception("erro");
    }
  }
}
