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
        velocity: 3
      )
    );
  }
}


class DraggableSquare extends StatefulWidget {
  double initialTop;
  double initialLeft;
  double squareSize;
  int velocity;

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
      if(difference >= 0) {
        return SwipeDirection.right;
      } else {
        return SwipeDirection.left;
      }
    } else {
      if(difference >= 0) {
        return SwipeDirection.bottom;
      } else {
        return SwipeDirection.top;
      }
    }
  }


  bool isOnRightEdge(double validLeft) {
    bool isOnRightEdge = false;
    if(_left.floor() == validLeft.floor()) {
      isOnRightEdge = true;
    }
    return isOnRightEdge;
  }

  bool isOnLeftEdge() {
    bool isOnLeftEdge = false;
    if(_left.floor() == 0) {
      isOnLeftEdge = true;
    }
    return isOnLeftEdge;
  }

  bool isOnTopEdge() {
    bool isOnTopEdge = false;
    if(_top.floor() == 0) {
      isOnTopEdge = true;
    }
    return isOnTopEdge;
  }

  bool isOnBottomEdge(double validTop) {
    bool isOnBottomEdge = false;
    if(_top.floor() == validTop.floor()) {
      isOnBottomEdge = true;
    }
    return isOnBottomEdge;
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
                activeTimerVertical = Timer.periodic(Duration(milliseconds: widget.velocity), (timer) {
                    if(directionToGo == SwipeDirection.bottom) {
                      if(isOnBottomEdge(validTopValue)) {
                        directionToGo = SwipeDirection.top;
                      }
                    } else if(directionToGo == SwipeDirection.top) {
                      if(isOnTopEdge()) {
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
                  }
                );
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                activeTimerHorizontal.cancel();
                SwipeDirection directionToGo = detectSwipeDirection(details.velocity.pixelsPerSecond.dx, true);
                activeTimerHorizontal = Timer.periodic(Duration(milliseconds: widget.velocity), (timer) {
                    if(directionToGo == SwipeDirection.right) {
                      if(isOnRightEdge(validLeftValue)) {
                        directionToGo = SwipeDirection.left;
                      }
                    } else if(directionToGo == SwipeDirection.left) {
                      if(isOnLeftEdge()) {
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
                  }
                );
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
