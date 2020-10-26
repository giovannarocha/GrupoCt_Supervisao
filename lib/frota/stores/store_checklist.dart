import 'package:mobx/mobx.dart';
part 'store_checklist.g.dart';

class StoreCheckList = _StoreCheckListBase with _$StoreCheckList;

abstract class _StoreCheckListBase with Store {
  @observable
  String fuelLevel = "VAZIO";
  @observable
  double fuelValue = 0.0;
  @observable
  int radioValue = 0;

  @action
  fuelChange(value) {
    switch (value.toInt()) {
      case 1:
        fuelLevel = "1/4";
        fuelValue = value;
        break;
      case 2:
        fuelLevel = "2/4";
        fuelValue = value;
        break;
      case 3:
        fuelLevel = "3/4";
        fuelValue = value;
        break;
      case 4:
        fuelLevel = "CHEIO";
        fuelValue = value;
        break;
      default:
        fuelLevel = "VAZIO";
        fuelValue = value;
        break;
    }
  }

  @action
  radioValueChange(int value) {
    radioValue = value;
  }
}
