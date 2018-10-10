import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';

import './pager_indicator.dart';

class PageDragger extends StatefulWidget {
  final bool canDragLeftToRight;
  final bool canDragRightToLeft;
  final StreamController<SlideUpdate> slideUpdateStream;

  PageDragger({
    this.canDragLeftToRight,
    this.canDragRightToLeft,
    this.slideUpdateStream,
  });

  @override
  _PageDraggerState createState() => _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  static const FULL_TRANSITION_PX = 200.0;

  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent = 0.0;

  onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;
      final dx = dragStart.dx - newPosition.dx;

      if (dx > 0.0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / FULL_TRANSITION_PX).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }

      widget.slideUpdateStream.add(
        SlideUpdate(
          udpateType: UpdateType.dragging,
          direction: slideDirection,
          slidePercent: slidePercent,
        ),
      );

      print('Dragging $slideDirection at $slidePercent%');
    }
  }

  onDragEnd(DragEndDetails details) {
    widget.slideUpdateStream.add(
      SlideUpdate(
        udpateType: UpdateType.doneDragging,
        direction: SlideDirection.none,
        slidePercent: 0.0,
      ),
    );

    dragStart = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
    );
  }
}

enum TransitionGoal {
  open,
  close,
}

class AnimatedPageDragger {
  static const PERCENT_PER_MILLISECOND = 0.001;

  final slideDirection;
  final transitionGoal;

  AnimationController completionAnimationController;

  AnimatedPageDragger({
    this.slideDirection,
    this.transitionGoal,
    slidePercent,
    StreamController<SlideUpdate> slideUpdateStream,
    TickerProvider vsync,
  }) {
    final startSlidePercent = slidePercent;
    var endSlidePercent;
    var duration;

    if (transitionGoal == TransitionGoal.open) {
      final slideRemaining = 1.0 - slidePercent;

      endSlidePercent = 1.0;
      duration = Duration(
        milliseconds: (slideRemaining / PERCENT_PER_MILLISECOND).round(),
      );
    } else {
      endSlidePercent = 0.0;
      duration = Duration(
        milliseconds: (slidePercent / PERCENT_PER_MILLISECOND).round(),
      );
    }

    completionAnimationController = AnimationController(
      duration: duration,
      vsync: vsync,
    )
      ..addListener(() {
        slideUpdateStream.add(
          SlideUpdate(
            direction: slideDirection,
            slidePercent: lerpDouble(
              startSlidePercent,
              endSlidePercent,
              completionAnimationController.value,
            ),
            udpateType: UpdateType.animating,
          ),
        );
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          slideUpdateStream.add(
            SlideUpdate(
              udpateType: UpdateType.doneAnimating,
              slidePercent: endSlidePercent,
            ),
          );
        }
      });
  }

  run() => completionAnimationController.forward(from: 0.0);

  dispose() => completionAnimationController.dispose();
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

class SlideUpdate {
  final udpateType;
  final direction;
  final slidePercent;

  SlideUpdate({
    this.udpateType,
    this.direction,
    this.slidePercent,
  });
}
