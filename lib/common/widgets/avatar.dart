import 'package:flutter/material.dart';
import 'package:juai/common/assets.dart';
import 'package:juai/common/routers/routeFade.dart';
import 'package:juai/common/config.dart';
import 'package:juai/common/utils/qiniu_sdk.dart';

import 'image_browser.dart';

Widget avatar({String? avatarUrl, double radius = 22, Function? onClick, BuildContext? context}) {
  avatarUrl = (avatarUrl == null || avatarUrl.isEmpty) ? Assets.defaultAvatar : avatarUrl;
  debugPrint("avatarUrlavatarUrlavatarUrlavatarUrl$avatarUrl");
  ImageProvider? image;
  if (avatarUrl.isEmpty) {
    image = const AssetImage(Assets.robotAvatar);
  } else if (avatarUrl.startsWith("assets/")) {
    image = AssetImage(avatarUrl);
  } else {
    image = NetworkImage(QiniuUtil.getImageThumbnail(QINIU_DOMAIN + avatarUrl, width: 90, height: 90));
  }
  return InkWell(
    child: CircleAvatar(
      backgroundImage: image,
      radius: radius,
    ),
    onTap: () {
      if (onClick == null) {
        if (context != null) {
          Navigator.of(context).push(
            RouteFade(
              page: GxImageBrowser(imgDataArr: [avatarUrl!], index: 0),
            ),
          );
        }
      } else {
        onClick.call();
      }
    },
  );
}

Widget aiAvatar(String? url, {Function? onClick, double radius = 22}) {
  if (url == null || url.isEmpty) {
    return InkWell(
      child: CircleAvatar(
        backgroundImage: const AssetImage(Assets.robotAvatar),
        radius: radius,
      ),
      onTap: () => onClick,
    );
  }
  return avatar(avatarUrl: url, onClick: onClick, radius: radius);
}
