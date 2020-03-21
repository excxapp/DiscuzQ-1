import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/models/threadModel.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/models/postModel.dart';
import 'package:discuzq/widgets/threads/ThreadsCacher.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/widgets/users/userLink.dart';
import 'package:discuzq/widgets/threads/ThreadFavoritesAndRewards.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/ui/ui.dart';

final ThreadsCacher _threadsCacher = ThreadsCacher();

///
/// 主题下回复的快照
/// 一般ThreadCard中显示的数据只会有3条的
///
/// ThreadPostSnapshot 包含点赞，打赏的信息，还有回复，并增加全部...条回复
///
class ThreadPostSnapshot extends StatelessWidget {
  ///
  /// 主题
  final ThreadModel thread;

  ///
  /// 第一条post
  final PostModel firstPost;

  ///
  /// 最近三条
  final List<dynamic> lastThreePosts;

  ///
  /// 回复总条数
  final int replyCounts;

  ThreadPostSnapshot(
      {@required this.lastThreePosts,
      @required this.thread,
      @required this.firstPost,
      this.replyCounts = 0});

  @override
  Widget build(BuildContext context) {
    if (lastThreePosts == null || lastThreePosts.length == 0) {
      ///
      /// 没有回复，仅显示点赞和打赏记录
      ///
      return _wrapper(
          context: context,
          child: ThreadFavoritesAndRewards(
            thread: thread,
            firstPost: firstPost,
          ));
    }

    ///
    /// 构造回复组件
    ///
    final List<Widget> _repliesWidgets = lastThreePosts.map((dynamic p) {
      final PostModel post = _threadsCacher.posts
          .where((PostModel e) => e.id == int.tryParse(p['id']))
          .toList()[0];

      ///
      /// 查询回帖用户
      final List<UserModel> userReplayThreads = _threadsCacher.users
          .where((UserModel u) =>
              u.id == int.tryParse(post.relationships.user['data']['id']))
          .toList();

      /// 查询二级回复关联用户（查询活肤评论的用户）
      /// post.relationships.replyUser 不一定每个 post中都会存在
      /// todo: 排查故障
      final List<UserModel> userReplyPosts = post.attributes.replyUserID != null
          ? _threadsCacher.users
              .where((UserModel u) => u.id == post.attributes.replyUserID)
              .toList()
          : null;

      return Container(
        alignment: Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            /// 用户
            UserLink(
              user: userReplayThreads[0],
            ),

            ///
            /// 有的可能是多次回复 也就是 某某 回复 某某的
            userReplyPosts == null || userReplyPosts.length == 0
                ? const SizedBox()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DiscuzText(
                        '回复',
                        color: DiscuzApp.themeOf(context).greyTextColor,
                      ),
                      UserLink(
                        user: userReplyPosts[0],
                      )
                    ],
                  ),

            ///
            /// 回复内容
            Flexible(
              child: Container(
                child: DiscuzText(
                  post.attributes.content,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      );
    }).toList();

    return _wrapper(
        context: context,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /// 点赞和打赏记录
              ThreadFavoritesAndRewards(
                thread: thread,
                firstPost: firstPost,
              ),

              /// 渲染所有回复记录
              ..._repliesWidgets,

              ///
              /// 回复
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  DiscuzLink(
                    padding: const EdgeInsets.only(top: 5),
                    label: '全部${(replyCounts - 1).toString()}条回复',
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: const DiscuzIcon(SFSymbols.chevron_compact_right,
                        size: 16),
                  ),
                ],
              )
            ]));
  }

  ///
  /// 用于包裹组件
  Widget _wrapper({@required BuildContext context, @required Widget child}) =>
      Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 5,
          top: 5,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: DiscuzApp.themeOf(context).scaffoldBackgroundColor),
        child: child,
      );
}
