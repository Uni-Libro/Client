import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../services/localization/strs.dart';
import '../animations/animation_widget.dart';

class AuthorsView extends StatelessWidget {
  const AuthorsView({
    super.key,
    required this.delegates,
    required this.position,
  });

  final int position;
  final List<AuthorContentDelegate> delegates;

  static const double tileHeight = 130;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        AnimationBuilder(
          position,
          0,
          -50,
          _buildListHeader(context),
        ),
        const SizedBox(height: 5),
        AuthorsListContent(
          tileHeight: tileHeight,
          delegates: delegates,
          basePos: position,
        ),
      ],
    );
  }

  Widget _buildListHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Strs.authors.tr,
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          CupertinoButton(
            minSize: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(Strs.more.tr, style: Theme.of(context).textTheme.caption),
                const SizedBox(width: 5),
                Icon(
                  CupertinoIcons.chevron_down,
                  size: 18,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ],
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

class AuthorsListContent extends StatelessWidget {
  const AuthorsListContent({
    Key? key,
    required this.tileHeight,
    required this.delegates,
    required this.basePos,
  }) : super(key: key);

  final int basePos;
  final double tileHeight;
  final List<AuthorContentDelegate> delegates;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: SizedBox(
        height: tileHeight + 30,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: delegates.length,
          itemBuilder: (context, index) {
            return AnimationBuilder(
              index + basePos,
              50,
              0,
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipSmoothRect(
                          radius: SmoothBorderRadius(
                            cornerRadius: 20,
                            cornerSmoothing: 1,
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              imageUrl: delegates[index].avatar,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Card(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        delegates[index].name,
                        style: Theme.of(context).textTheme.subtitle1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AuthorContentDelegate {
  final String name;
  final String avatar;

  AuthorContentDelegate(this.name, this.avatar);
}
