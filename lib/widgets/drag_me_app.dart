import 'dart:async';
import 'dart:math';

import 'package:dragme/widgets/swipe_direction.dart';
import 'package:flutter/material.dart';

class DragMeApp extends StatelessWidget {
  const DragMeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double squareSize = MediaQuery.of(context).size.height / 7;
    double initialLeft = (MediaQuery.of(context).size.width - squareSize) / 2;
    double initialTop = (MediaQuery.of(context).size.height - squareSize) / 2;

    return Scaffold(
      body: DraggableSquare(
        squareSize: squareSize,
        initialLeft: initialLeft,
        initialTop: initialTop,
        velocity: 0
      )
    );
  }
}


class DraggableSquare extends StatefulWidget {
  double initialTop;
  double initialLeft;
  double squareSize;
  double velocity;

  DraggableSquare({required this.squareSize, required this.initialTop,
    required this.initialLeft, required this.velocity});

  @override
  State createState() => _DraggableSquareState();
}

class _DraggableSquareState extends State<DraggableSquare> {
  double _left = 0;
  double _top = 0;
  Timer activeTimer = Timer(const Duration(seconds: 0), (){});

  @override
  void initState() {
    super.initState();
    _left = widget.initialLeft;
    _top = widget.initialTop;
  }

  SwipeDirection detectSwipeDirection(double dx) {
    if(dx > 0) {
      return SwipeDirection.right;
    } else {
      return SwipeDirection.left;
    }
  }

  bool isOnRightEnd(double left, double validLeftValue) {
    bool isOnRightEnd = false;
    if(left.floor() == validLeftValue.floor()) {
      isOnRightEnd = true;
    }
    return isOnRightEnd;
  }

  bool isOnLeftEnd(double left) {
    bool isOnRightEnd = false;
    if(left.floor() == 0) {
      isOnRightEnd = true;
    }
    return isOnRightEnd;
  }

  @override
  Widget build(BuildContext context) {
    double validTopValue = MediaQuery.of(context).size.height - widget.squareSize;
    double validLeftValue = MediaQuery.of(context).size.width - widget.squareSize;

    return Stack(
      children: <Widget>[
        Positioned(
          left: _left,
          top: _top,
          child: GestureDetector(
              onHorizontalDragUpdate: (DragUpdateDetails details) {

              },
              onHorizontalDragEnd: (DragEndDetails details) {
                activeTimer.cancel();
                SwipeDirection directionToGo = detectSwipeDirection(details.velocity.pixelsPerSecond.dx);
                activeTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
                  if(directionToGo == SwipeDirection.right) {
                    if(isOnRightEnd(_left, validLeftValue)) {
                      directionToGo = SwipeDirection.left;
                    }
                  } else if(directionToGo == SwipeDirection.left) {
                    if(isOnLeftEnd(_left)) {
                      directionToGo = SwipeDirection.right;
                    }
                  }
                  setState(() {
                    if(directionToGo == SwipeDirection.right) {
                      _left = _left + 1;
                    } else if(directionToGo == SwipeDirection.left) {
                      _left = _left - 1;
                    }
                  });
                });
              },
              onPanUpdate: (DragUpdateDetails details) {
                double newTop = min(max(0, _top + details.delta.dy), validTopValue);
                double newLeft = min(max(0, _left + details.delta.dx), validLeftValue);
                setState(() {
                  _top = widget.velocity + newTop;
                  _left = widget.velocity + newLeft;
                });
              },
              child: Container(
                height: widget.squareSize,
                width: widget.squareSize,
                color: Colors.red,
              )
          ),
        ),
      ],
    );
  }
}
