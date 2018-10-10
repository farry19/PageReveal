import 'package:flutter/material.dart';
import 'dart:ui';

import '../views/page.dart';

class PagerIndicator extends StatelessWidget {
  final PagerIndicatorViewModel pageIndicatorViewModel;

  PagerIndicator({
    this.pageIndicatorViewModel,
  });

  @override
  Widget build(BuildContext context) {
    List<PageBubble> pageBubble = [];

    for (var i = 0; i < pageIndicatorViewModel.pages.length; ++i) {
      final page = pageIndicatorViewModel.pages[i];

      var percentActive;

      if (i == pageIndicatorViewModel.activeIndex) {
        percentActive = 1.0 - pageIndicatorViewModel.slidePercent;
      } else if (i == pageIndicatorViewModel.activeIndex - 1 &&
          pageIndicatorViewModel.slideDirection == SlideDirection.leftToRight) {
        percentActive = pageIndicatorViewModel.slidePercent;
      } else if (i == pageIndicatorViewModel.activeIndex + 1 &&
          pageIndicatorViewModel.slideDirection == SlideDirection.rightToLeft) {
        percentActive = pageIndicatorViewModel.slidePercent;
      } else {
        percentActive = 0.0;
      }

      bool isHollow = i > pageIndicatorViewModel.activeIndex ||
          (i == pageIndicatorViewModel.activeIndex &&
              pageIndicatorViewModel.slideDirection ==
                  SlideDirection.leftToRight);

      pageBubble.add(
        PageBubble(
          pageBubbleViewModel: PageBubbleViewModel(
            iconAssetPath: page.iconAssetPath,
            color: page.color,
            isHollow: isHollow,
            activePercent: percentActive,
          ),
        ),
      );
    }

    final BUBBLE_WIDTH = 50.0;
    final double baseTranslation = ((pageIndicatorViewModel.pages.length * BUBBLE_WIDTH) / 2) - (BUBBLE_WIDTH / 2);
    var translation = baseTranslation - (pageIndicatorViewModel.activeIndex * BUBBLE_WIDTH);

    if(pageIndicatorViewModel.slideDirection == SlideDirection.leftToRight) {
      translation += BUBBLE_WIDTH * pageIndicatorViewModel.slidePercent;
    } else if(pageIndicatorViewModel.slideDirection == SlideDirection.rightToLeft) {
      translation -= BUBBLE_WIDTH * pageIndicatorViewModel.slidePercent;
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        Transform(
          transform: Matrix4.translationValues(translation, 0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: pageBubble,
          ),
        )
      ],
    );
  }
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

class PagerIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PagerIndicatorViewModel({
    this.pages,
    this.activeIndex,
    this.slideDirection,
    this.slidePercent,
  });
}

class PageBubble extends StatelessWidget {
  final PageBubbleViewModel pageBubbleViewModel;

  PageBubble({
    this.pageBubbleViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 100.0,
      child: Center(
        child: Container(
          width: lerpDouble(10.0, 50.0, pageBubbleViewModel.activePercent),
          height: lerpDouble(10.0, 50.0, pageBubbleViewModel.activePercent),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: pageBubbleViewModel.isHollow
                ? const Color(0x88FFFFFF).withAlpha(
                    (0x88 * pageBubbleViewModel.activePercent).round())
                : const Color(0x88FFFFFF),
            border: Border.all(
              color: pageBubbleViewModel.isHollow
                  ? const Color(0x88FFFFFF).withAlpha(
                      (0x88 * (1.0 - pageBubbleViewModel.activePercent))
                          .round())
                  : Colors.transparent,
              width: 0.5,
            ),
          ),
          child: Opacity(
            opacity: pageBubbleViewModel.activePercent,
            child: Image.asset(
              pageBubbleViewModel.iconAssetPath,
              color: pageBubbleViewModel.color,
            ),
          ),
        ),
      ),
    );
  }
}

class PageBubbleViewModel {
  final String iconAssetPath;
  final Color color;
  final bool isHollow;
  final double activePercent;

  PageBubbleViewModel({
    this.iconAssetPath,
    this.color,
    this.isHollow,
    this.activePercent,
  });
}
