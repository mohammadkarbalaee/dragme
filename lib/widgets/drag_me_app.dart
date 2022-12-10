import 'dart:math';

import 'package:flutter/material.dart';

class DragMeApp extends StatelessWidget {
  const DragMeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyWidget()
    );
  }
}


class MyWidget extends StatefulWidget {

  @override
  State createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {

  double _left = 0;
  double _top = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: _left,
          top: _top,
          child: GestureDetector(
              onTap: () => print('I was tapped!'),
              onPanUpdate: (details) => setState(() {
                _top = max(0, _top + details.delta.dy);
                _left = max(0, _left + details.delta.dx);
              }),
              child: Container(
                height: 100,
                width: 100,
                color: Colors.red,
              )
          ),
        ),
      ],
    );
  }
}
