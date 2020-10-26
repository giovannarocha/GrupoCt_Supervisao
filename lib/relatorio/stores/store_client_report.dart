import 'package:grupoct_supervisao/base/model/post.dart';
import 'package:grupoct_supervisao/base/model/supervisor.dart';
import 'package:mobx/mobx.dart';
part 'store_client_report.g.dart';

class StoreClientReport = _StoreClientReportBase with _$StoreClientReport;

abstract class _StoreClientReportBase with Store {
  @observable
  int listController = 0;

  @action
  controller(newValue, area, shift) {
    listController = newValue;
    newValue == 0 ? getMyPosts() : getAllPosts();
  }

  @observable
  bool isEnabled = true;

  @action
  setIsEnabled() {
    if (isEnabled) {
      isEnabled = false;
    } else {
      isEnabled = true;
    }
  }

  @observable
  List<Post> posts;
  @action
  getAllPosts() async {
    posts = await Post.getPosts();
  }

  @observable
  List<Post> myPosts;
  getMyPosts() async {
    Supervisor supervisor = Supervisor();
    List list = await supervisor.getSupervisor();
    supervisor = list[0];
    int area = supervisor.area;
    int shift = supervisor.shift;
    posts = await Post.getMyPosts(area, shift);
  }
}
