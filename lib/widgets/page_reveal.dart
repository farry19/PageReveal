import 'package:flutter/material.dart';

import 'dart:math';

class PageReveal extends StatelessWidget {
  final double revealPercent;
  final Widget child;

  PageReveal({
    this.revealPercent,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipper: CircleRevealClipper(
        revealPercent: revealPercent,
      ),
      child: child,
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;

  CircleRevealClipper({this.revealPercent});

  @override
  Rect getClip(Size size) {
    final epicenter = Offset(size.width / 2, size.height);

    double theta = atan(epicenter.dy / epicenter.dx);
    final distanceToCenter = epicenter.dy / sin(theta);

    final radius = distanceToCenter * revealPercent;
    final diameter = 2 * radius;

    return Rect.fromLTWH(epicenter.dx - radius, epicenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
