import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class BookImgWidget extends StatelessWidget {
  const BookImgWidget({super.key, this.imgUrl, this.bR = 20});

  final String? imgUrl;
  final double bR;

  @override
  Widget build(BuildContext context) {
    return ClipSmoothRect(
      radius: SmoothBorderRadius(
        cornerRadius: bR,
        cornerSmoothing: 1,
      ),
      child: AspectRatio(
        aspectRatio: 1 / 1.6,
        child: CachedNetworkImage(
          imageUrl: imgUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Card(
            margin: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
