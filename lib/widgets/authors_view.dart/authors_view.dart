import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flex_with_main_child/flex_with_main_child.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../models/author_model.dart';
import '../../services/localization/strs.dart';
import '../animations/animation_widget.dart';

class AuthorsView extends StatelessWidget {
  const AuthorsView({
    super.key,
    required this.delegates,
    required this.position,
  });

  final int position;
  final List<AuthorModel> delegates;

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
          //   CupertinoButton(
          //     minSize: 0,
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     child: Row(
          //       children: [
          //         Text(Strs.more.tr, style: Theme.of(context).textTheme.caption),
          //         const SizedBox(width: 5),
          //         Icon(
          //           CupertinoIcons.chevron_down,
          //           size: 18,
          //           color: Theme.of(context).textTheme.caption?.color ??
          //               Theme.of(context).colorScheme.onBackground,
          //         ),
          //       ],
          //     ),
          //     onPressed: () {},
          //   )
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
  final List<AuthorModel> delegates;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: SizedBox(
        height: tileHeight + 30,
        child: ListView.builder(
          clipBehavior: Clip.none,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: delegates.length,
          itemBuilder: (context, index) {
            final mainChildKey = GlobalKey();
            return AnimationBuilder(
              index + basePos,
              50,
              0,
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ColumnWithMainChild(
                    mainChildKey: mainChildKey,
                    children: [
                      Expanded(
                        key: mainChildKey,
                        child: ClipSmoothRect(
                          radius: SmoothBorderRadius(
                            cornerRadius: 20,
                            cornerSmoothing: 1,
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              imageUrl: delegates[index].imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Card(
                                margin: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        delegates[index].name!,
                        style: Theme.of(context).textTheme.bodyText2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
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
