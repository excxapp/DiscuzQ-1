import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'package:discuzq/utils/global.dart';
import 'package:discuzq/models/threadModel.dart';

class ShareNative {
  
  ///
  /// 分享主题
  /// 调用系统分享，生成网页链接分享主题
  /// 
  static Future<void> shareThread({@required ThreadModel thread}) async {
    if (thread.id == 0) {
      return;
    }

    final String webUrl = '${Global.domain}/details/${thread.id.toString()}';
    final String shareContent = '''
    ${thread.attributes.title}
    $webUrl
    ''';
    return await Share.share(shareContent);
  }
}
