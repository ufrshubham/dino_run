import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/dino_run.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dino Run',
      theme: ThemeData(
        fontFamily: 'Audiowide',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GameWidget(
        loadingBuilder: (conetxt) => Center(
          child: Container(
            width: 200,
            child: LinearProgressIndicator(),
          ),
        ),
        game: DinoRun(),
      ),
    );
  }
}
