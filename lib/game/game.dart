import 'package:dino_run/game/dino.dart';
import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/game/enemy_manager.dart';
import 'package:flame/components/parallax_component.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flutter/widgets.dart';

class DinoGame extends BaseGame with TapDetector {
  // This variable stores the current score of player.
  int score;

  // This is the main character component.
  Dino _dino;

  /// This component displays the [score] at top-center of the screen.
  TextComponent _scoreText;

  // This component is responsible for spawning random enemies.
  EnemyManager _enemyManager;

  // This component creates the moving parallax background.
  ParallaxComponent _parallaxComponent;

  /// This default constructor is responsible for creating all the components
  /// and adding them to [DinoGame]'s components list.
  DinoGame() {
    /// Last [ParallaxImage] uses [LayerFill.none] so that ground does not
    /// take up the whole screen.
    _parallaxComponent = ParallaxComponent(
      [
        ParallaxImage('parallax/plx-1.png'),
        ParallaxImage('parallax/plx-2.png'),
        ParallaxImage('parallax/plx-3.png'),
        ParallaxImage('parallax/plx-4.png'),
        ParallaxImage('parallax/plx-5.png'),
        ParallaxImage('parallax/plx-6.png', fill: LayerFill.none),
      ],
      baseSpeed: Offset(100, 0),
      layerDelta: Offset(20, 0),
    );
    add(_parallaxComponent);

    _dino = Dino();
    add(_dino);

    _enemyManager = EnemyManager();
    add(_enemyManager);

    score = 0;
    _scoreText = TextComponent(score.toString());
    add(_scoreText);
  }

  @override
  void resize(Size size) {
    super.resize(size);

    /// This makes sure that [_scoreText] is placed at the top-center of the screen.
    _scoreText.setByPosition(
        Position(((size.width / 2) - (_scoreText.width / 2)), 0));
  }

  /// This method comes from [TapDetector] mixin and it gets called everytime
  /// the screen is tapped.
  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    _dino.jump();
  }

  @override
  void update(double t) {
    super.update(t);

    /// Here [60] is the rate of increase of score.
    score += (60 * t).toInt();
    _scoreText.text = score.toString();

    /// This code is responsible for hit detection of [_dino]
    /// with all the [Enemy]'s current in game world.
    components.whereType<Enemy>().forEach((enemy) {
      if (_dino.distance(enemy) < 30) {
        _dino.hit();
      }
    });
  }
}
