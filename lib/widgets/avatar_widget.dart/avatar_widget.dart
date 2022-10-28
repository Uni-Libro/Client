import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    this.url,
    this.size = 45,
  });

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return _buildErrorWidget();
    }
    return Card(
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 15,
          cornerSmoothing: 1,
        ),
      ),
      margin: EdgeInsets.zero,
      child: CachedNetworkImage(
        imageUrl: url!,
        height: size,
        width: size,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => _buildErrorWidget(),
        placeholder: (context, url) => _buildErrorWidget(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Card(
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 15,
          cornerSmoothing: 1,
        ),
      ),
      margin: EdgeInsets.zero,
      child: SizedBox(
        height: size,
        width: size,
        child: const Icon(
          CupertinoIcons.person,
          size: 30,
        ),
      ),
    );
  }
}
