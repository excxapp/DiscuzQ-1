import 'package:flutter/material.dart';

import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/users/userHomeDelegate.dart';
import 'package:discuzq/widgets/common/discuzAvatar.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/ui/ui.dart';

///
/// 用于显示用户搜索结果的用户Tile组件
/// 可以查看用户头像，点击查看用户主页详情
class UserListTile extends StatelessWidget {
  ///
  /// 用于显示的用户
  final UserModel user;

  UserListTile({@required this.user});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: DiscuzApp.themeOf(context).backgroundColor),
      child: Column(
        children: <Widget>[
          DiscuzListTile(
            leading: DiscuzAvatar(
              url: user.avatarUrl,
              size: 40,
            ),
            title: DiscuzText(
              user.username,
              fontWeight: FontWeight.bold,
            ),
            onTap: () => DiscuzRoute.open(
                context: context,
                widget: UserHomeDelegate(
                  user: user,
                )),
          ),
          const DiscuzDivider(padding: 0),
        ],
      ),
    );
  }
}
