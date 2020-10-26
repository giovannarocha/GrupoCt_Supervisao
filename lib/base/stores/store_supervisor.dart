import 'package:grupoct_supervisao/base/model/supervisor.dart';
import 'package:mobx/mobx.dart';
part 'store_supervisor.g.dart';

class StoreSupervisor = _StoreSupervisorBase with _$StoreSupervisor;

abstract class _StoreSupervisorBase with Store {
  @observable
  Supervisor supervisor;

  @action
  setData() async {
    supervisor = await Supervisor.getOnlySupervisorStatic();
  }
}
