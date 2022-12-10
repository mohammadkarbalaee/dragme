import 'package:flutter/material.dart';

class DragMeApp extends StatelessWidget {
  const DragMeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 10,
              width: MediaQuery.of(context).size.width / 3,
              decoration: const BoxDecoration(
                color: Colors.red
              ),
            )
          ],
        ),
      ),
    );
  }
}
