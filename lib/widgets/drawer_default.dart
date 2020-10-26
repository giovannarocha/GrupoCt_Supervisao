import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grupoct_supervisao/base/model/post.dart';
import 'package:grupoct_supervisao/base/model/supervisor.dart';
import 'package:grupoct_supervisao/base/stores/store_supervisor.dart';
import 'package:grupoct_supervisao/base/telas/loader.dart';
import 'package:grupoct_supervisao/relatorio/model/token.dart';
import 'package:grupoct_supervisao/utils/my_colors.dart';
import 'package:grupoct_supervisao/utils/nav.dart';

class DrawerDefault extends StatelessWidget {
  final Size size;
  DrawerDefault(this.size);
  final supervisor = StoreSupervisor();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: size.width * .5,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: size.height * .03, bottom: size.height * .03),
                child: Center(
                  child: Observer(builder: (_) {
                    supervisor.setData();
                    return CircleAvatar(
                      backgroundImage: supervisor.supervisor != null
                          ? NetworkImage(
                              supervisor.supervisor.picture,
                            )
                          : null,
                      radius: size.width * .2,
                    );
                  }),
                ),
              ),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.defaultBlue,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.grey,
                        ),
                        _drawerListTIle("ATUALIZAR POSTOS", _actions),
                        Spacer(),
                        Visibility(
                          visible: false,
                          child: Container(
                            width: size.width,
                            child: FlatButton(
                                onPressed: () {
                                  Supervisor sup = Supervisor();
                                  sup.removeSupervisor();
                                  push(context, Loader(), replace: true);
                                },
                                child: Icon(
                                  Icons.power_settings_new,
                                  color: Colors.red,
                                  size: size.width * .15,
                                )),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  _actions() {
    Token.getTokens();
    Post.getHttpPosts();
  }

  _drawerListTIle(title, action) {
    return ListTile(
      onTap: () => action(),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
        ),
      ),
    );
  }
}
