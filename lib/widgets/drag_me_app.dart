import 'dart:math';

import 'package:flutter/material.dart';

class DragMeApp extends StatelessWidget {
  const DragMeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DraggableSquare()
    );
  }
}


class DraggableSquare extends StatefulWidget {
  DraggableSquare({super.key});
  @override
  State createState() => _DraggableSquareState();
}

class _DraggableSquareState extends State<DraggableSquare> {
  double _left = 0;
  double _top = 0;

  @override
  Widget build(BuildContext context) {
    double squareSize = MediaQuery.of(context).size.width / 5;
    double validTopValue = MediaQuery.of(context).size.height - squareSize;
    double validLeftValue = MediaQuery.of(context).size.width - squareSize;

    return Stack(
      children: <Widget>[
        Positioned(
          left: _left,
          top: _top,
          child: GestureDetector(
              onPanUpdate: (details) {
                double newTop = min(max(0, _top + details.delta.dy), validTopValue);
                double newLeft = min(max(0, _left + details.delta.dx), validLeftValue);
                setState(() {
                  _top = newTop;
                  _left =newLeft;
                });
              },
              child: Container(
                height: squareSize,
                width: squareSize,
                color: Colors.red,
              )
          ),
        ),
      ],
    );
  }
}
