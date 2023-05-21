import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:guxin_ai/common/server.dart';

enum CacheImageType { network, local, asserts }

class ImageCacheWidget extends StatefulWidget {
  final String imageUrl;
  final CacheImageType cacheImageType;
  final double? width;
  final double? height;
  const ImageCacheWidget(this.imageUrl, {super.key, this.cacheImageType = CacheImageType.network, this.width, this.height});

  @override
  _ImageCacheWidgetState createState() => _ImageCacheWidgetState();
}

class _ImageCacheWidgetState extends State<ImageCacheWidget> {
  void _retryLoading() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cacheImageType == CacheImageType.network && widget.imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: (widget.imageUrl.startsWith("http") ? "" : Qiniu_External_domain) + widget.imageUrl,
        errorWidget: (context, url, error) => GestureDetector(
          onTap: _retryLoading,
          child: const Icon(
            Icons.image_not_supported_outlined,
            size: 60,
          ),
        ),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 200),
        width: widget.width,
        height: widget.height,
        progressIndicatorBuilder: (context, url, downloadProgress) => LinearProgressIndicator(value: downloadProgress.progress),
      );
    } else if (widget.cacheImageType == CacheImageType.asserts) {
      return Image.asset(
        widget.imageUrl,
        fit: BoxFit.cover,
        width: widget.width,
        height: widget.height,
      );
    } else {
      return Image.file(
        File(widget.imageUrl),
        fit: BoxFit.cover,
        width: widget.width,
        height: widget.height,
      );
    }
  }
}