import 'package:mobx/mobx.dart';
part 'store_meal.g.dart';

class StoreMeal = _StoreMealBase with _$StoreMeal;

abstract class _StoreMealBase with Store {
  @observable
  String start;

  @action
  changeStart(newValue) => start = newValue;

  @observable
  String end;
  changeEnd(newValue) => end = newValue;
}
