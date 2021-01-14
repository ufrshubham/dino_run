import 'package:dino_run/game/dino.dart';
import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/game/enemy_manager.dart';
import 'package:dino_run/widgets/game_over_menu.dart';
import 'package:dino_run/widgets/hud.dart';
import 'package:dino_run/widgets/pause_menu.dart';
import 'package:flame/components/parallax_component.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// This is the main game class.
class DinoGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  // This variable stores the current score of player.
  int score;

  // A temp variable for score calculations.
  double _elapsedTime = 0.0;

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
    _scoreText = TextComponent(
      score.toString(),
      config: TextConfig(fontFamily: 'Audiowide', color: Colors.white),
    );
    add(_scoreText);

    // This adds the pause button on top-left corner and
    // life indicators on top-right corner.
    addWidgetOverlay(
      'Hud',
      HUD(
        life: _dino.life,
        onPausePressed: pauseGame,
      ),
    );
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
    _elapsedTime += t;
    if (_elapsedTime > (1 / 60)) {
      _elapsedTime = 0.0;
      score += 1;
      _scoreText.text = score.toString();
    }

    /// This code is responsible for hit detection of [_dino]
    /// with all the [Enemy]'s current in game world.
    components.whereType<Enemy>().forEach((enemy) {
      if (_dino.distance(enemy) < 30) {
        _dino.hit();
      }
    });

    // If dino runs out of lives, game is over.
    if (_dino.life.value <= 0) {
      gameOver();
    }
  }

  // This method helps in detecting changes in app's life cycle state
  // and pause the game if it becomes inactive.
  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        this.pauseGame();
        break;
      case AppLifecycleState.paused:
        this.pauseGame();
        break;
      case AppLifecycleState.detached:
        this.pauseGame();
        break;
    }
  }

  // This method pauses the game.
  void pauseGame() {
    pauseEngine();
    // Adds the pause menu.
    addWidgetOverlay(
      'PauseMenu',
      PauseMenu(
        onResumePressed: resumeGame,
      ),
    );
  }

  // This method resumes the game.
  void resumeGame() {
    // First remove any pause menu and then resume the engine.
    removeWidgetOverlay('PauseMenu');
    resumeEngine();
  }

  // This method display the game over menu.
  void gameOver() {
    // First pause the game.
    pauseEngine();
    // Adds the game over menu.
    addWidgetOverlay(
      'GameOverMenu',
      GameOverMenu(
        score: score,
        onRestartPressed: reset,
      ),
    );
  }

  // This method takes care of resetting all the game data to initial state.
  void reset() {
    this.score = 0;
    _dino.life.value = 5;
    _dino.run();

    // Let enemy manager know that game needs to reset.
    _enemyManager.reset();

    // Removes all the enemies currently in the game world.
    components.whereType<Enemy>().forEach(
      (enemy) {
        this.markToRemove(enemy);
      },
    );

    removeWidgetOverlay('GameOverMenu');
    resumeEngine();
  }
}
