import 'dart:async';
import 'dart:math';

import 'package:dragme/widgets/edges.dart';
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
  Timer activeTimerHorizontal = Timer(const Duration(seconds: 0), (){});
  Timer activeTimerVertical = Timer(const Duration(seconds: 0), (){});

  @override
  void initState() {
    super.initState();
    _left = widget.initialLeft;
    _top = widget.initialTop;
  }

  SwipeDirection detectSwipeDirection(double difference,bool isHorizontal) {
    if(isHorizontal) {
      if(difference > 0) {
        return SwipeDirection.right;
      } else {
        return SwipeDirection.left;
      }
    } else {
      if(difference > 0) {
        return SwipeDirection.bottom;
      } else {
        return SwipeDirection.top;
      }
    }
  }


  Edge whichWallIsIt({required double left, required double top, required double validTop, required double validLeft}) {
    if(left.floor() == validLeft) {
      return Edge.right;
    } else if(left.floor() == 0) {
      return Edge.left;
    } else if(top.floor() == 0) {
      return Edge.top;
    } else {
      return Edge.bottom;
    }
  }

  void swipeAction() {

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
              onVerticalDragEnd: (DragEndDetails details) {
                activeTimerVertical.cancel();
                SwipeDirection directionToGo = detectSwipeDirection(details.velocity.pixelsPerSecond.dy, false);
                print(directionToGo);
                activeTimerVertical = Timer.periodic(const Duration(milliseconds:  10), (timer) {
                  Edge edge = whichWallIsIt(left: _left, top: _top, validTop: validTopValue, validLeft: validLeftValue);
                  if(directionToGo == SwipeDirection.bottom) {
                    if(edge == Edge.bottom) {
                      directionToGo = SwipeDirection.top;
                    }
                  } else if(directionToGo == SwipeDirection.top) {
                    if(edge == Edge.top) {
                      directionToGo = SwipeDirection.bottom;
                    }
                  }
                  setState(() {
                    if(directionToGo == SwipeDirection.bottom) {
                      _top = _top + 1;
                    } else if(directionToGo == SwipeDirection.top) {
                      _top = _top - 1;
                    }
                  });
                });
              },
              // onHorizontalDragEnd: (DragEndDetails details) {
              //   activeTimerHorizontal.cancel();
              //   SwipeDirection directionToGo = detectSwipeDirection(details.velocity.pixelsPerSecond.dx, true);
              //   activeTimerHorizontal = Timer.periodic(const Duration(milliseconds: 10), (timer) {
              //     Edge edge = whichWallIsIt(left: _left, top: _top, validTop: validTopValue, validLeft: validLeftValue);
              //     if(directionToGo == SwipeDirection.right) {
              //       if(edge == Edge.right) {
              //         directionToGo = SwipeDirection.left;
              //       }
              //     } else if(directionToGo == SwipeDirection.left) {
              //       if(edge == Edge.left) {
              //         directionToGo = SwipeDirection.right;
              //       }
              //     }
              //     // setState(() {
              //     //   if(directionToGo == SwipeDirection.right) {
              //     //     _left = _left + 1;
              //     //   } else if(directionToGo == SwipeDirection.left) {
              //     //     _left = _left - 1;
              //     //   }
              //     // });
              //   });
              // },
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
