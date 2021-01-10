import 'package:dino_run/game/game.dart';
import 'package:flutter/material.dart';

/// This class is responsible for creating an instance of [DinoGame]
/// and returning its widget.
class GamePlay extends StatelessWidget {
  final DinoGame _dinoGame = DinoGame();

  GamePlay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _dinoGame.widget,
    );
  }
}
