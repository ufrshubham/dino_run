import 'package:dino_run/game/dino.dart';
import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/game/enemy_manager.dart';
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
    addWidgetOverlay('Hud', _buildHud());
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

  // Build the HUD for this game.
  Widget _buildHud() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            Icons.pause,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () {
            pauseGame();
          },
        ),
        ValueListenableBuilder(
          valueListenable: _dino.life,
          builder: (BuildContext context, value, Widget child) {
            final list = List<Widget>();

            // This loop decides how many hearts are filled and how many are empty
            // depending upon the current dino life.
            for (int i = 0; i < 5; ++i) {
              list.add(
                Icon(
                  (i < value) ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              );
            }

            return Row(
              children: list,
            );
          },
        )
      ],
    );
  }

  // This method pauses the game.
  void pauseGame() {
    pauseEngine();
    // Adds the pause menu.
    addWidgetOverlay('PauseMenu', _buildPauseMenu());
  }

  // This method build the pause menu.
  Widget _buildPauseMenu() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 100.0,
            vertical: 50.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Paused',
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              ),
              IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () {
                  resumeGame();
                },
              )
            ],
          ),
        ),
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
    addWidgetOverlay('GameOverMenu', _getGameOverMenu());
  }

  // This method builds the game over menu.
  Widget _getGameOverMenu() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 100.0,
            vertical: 50.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Game Over',
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              ),
              Text(
                'Your score was $score',
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              ),
              IconButton(
                icon: Icon(
                  Icons.replay,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () {
                  // First reset all the necessary game data,
                  // then remove game over menu and resume the game.
                  reset();
                  removeWidgetOverlay('GameOverMenu');
                  resumeEngine();
                },
              )
            ],
          ),
        ),
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
  }
}
