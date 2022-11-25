import 'dart:math' as math;

import 'package:flutter/material.dart';

class SimpleSliverPinnedHeader extends StatelessWidget {
  const SimpleSliverPinnedHeader({
    Key? key,
    required this.builder,
    this.alignment = AlignmentDirectional.bottomStart,
    required this.maxExtent,
    required this.minExtent,
    this.padding,
    this.custom = false,
  }) : super(key: key);

  final Widget Function(
    BuildContext context,
    double maxOffset,
    double offsetRatio,
  ) builder;

  final AlignmentGeometry alignment;

  final double maxExtent;
  final double minExtent;
  final EdgeInsetsGeometry? padding;
  final bool custom;

  @override
  Widget build(BuildContext context) {
    final offsetHeight = maxExtent - minExtent;
    if (custom) {
      return SliverPersistentHeader(
        delegate: WrapSliverPersistentHeaderDelegate(
          maxExtent: maxExtent,
          minExtent: minExtent,
          onBuild: (
            BuildContext context,
            double shrinkOffset,
            bool overlapsContent,
          ) {
            return builder(
              context,
              offsetHeight,
              math.min(shrinkOffset / offsetHeight, 1.0),
            );
          },
        ),
        pinned: true,
      );
    }
    final theme = Theme.of(context);
    final bgcTween = ColorTween(
      begin: theme.backgroundColor,
      end: theme.cardColor,
    );
    return SliverPersistentHeader(
      delegate: WrapSliverPersistentHeaderDelegate(
        maxExtent: maxExtent,
        minExtent: minExtent,
        onBuild: (
          BuildContext context,
          double shrinkOffset,
          bool overlapsContent,
        ) {
          final offsetRatio = math.min(shrinkOffset / offsetHeight, 1.0);
          final bgc = bgcTween.transform(offsetRatio);
          return Container(
            alignment: alignment,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 30.0),
            decoration: BoxDecoration(
              color: bgc,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16.0)),
            ),
            child: builder(context, offsetHeight, offsetRatio),
          );
        },
      ),
      pinned: true,
    );
  }
}

class StackSliverPinnedHeader extends StatelessWidget {
  const StackSliverPinnedHeader({
    Key? key,
    required this.childrenBuilder,
    required this.maxExtent,
    required this.minExtent,
  }) : super(key: key);

  final List<Widget> Function(
    BuildContext context,
    double maxOffset,
    double ratio,
  ) childrenBuilder;
  final double maxExtent;
  final double minExtent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgcTween = ColorTween(
      begin: theme.backgroundColor,
      end: theme.cardColor,
    );
    final offsetHeight = maxExtent - minExtent;
    return SliverPersistentHeader(
      delegate: WrapSliverPersistentHeaderDelegate(
        maxExtent: maxExtent,
        minExtent: minExtent,
        onBuild: (
          BuildContext context,
          double shrinkOffset,
          bool overlapsContent,
        ) {
          final offsetRatio = math.min(shrinkOffset / offsetHeight, 1.0);
          final bgc = bgcTween.transform(offsetRatio);
          return Container(
            decoration: BoxDecoration(color: bgc),
            padding: const EdgeInsetsDirectional.only(
              start: 20.0,
              end: 20.0,
            ),
            child: Stack(
              children: childrenBuilder(context, offsetHeight, offsetRatio),
            ),
          );
        },
      ),
      pinned: true,
    );
  }
}

class WrapSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  WrapSliverPersistentHeaderDelegate({
    required this.maxExtent,
    required this.minExtent,
    required this.onBuild,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return onBuild(context, shrinkOffset, overlapsContent);
  }

  @override
  final double maxExtent;
  @override
  final double minExtent;
  final Function(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) onBuild;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
