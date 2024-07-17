import 'package:flutter/material.dart';

enum TailPosition { left, right }

class MessageBubbleShape extends ShapeBorder {
  final TailPosition tailPosition;

  MessageBubbleShape({this.tailPosition = TailPosition.right});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(20));

    path.addRRect(rrect);

    const tailWidth = 10.0;
    const tailHeight = 15.0;

    switch (tailPosition) {
      case TailPosition.right:
        path.moveTo(rect.width - tailWidth, rect.height - tailHeight * 2);
        path.quadraticBezierTo(
          rect.width,
          rect.height - tailHeight,
          rect.width - tailWidth,
          rect.height,
        );
        break;
      case TailPosition.left:
        path.moveTo(tailWidth, rect.height - tailHeight * 2);
        path.quadraticBezierTo(
          0,
          rect.height - tailHeight,
          tailWidth,
          rect.height,
        );
        break;
    }

    return path;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  ShapeBorder scale(double t) => this;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
}
