import 'dart:math';
import 'dart:ui';

import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/game/game.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/time.dart';
import 'package:flutter/cupertino.dart';

// This class is responsible for spawning random enemies at certain
// interval of time depending upon players current score.
class EnemyManager extends Component with HasGameRef<DinoGame> {
  /// Random generator required for randomly selecting [EnemyType]
  Random _random;

  // Timer to decide when to spawn next enemy.
  Timer _timer;

  // This indicates how aggressively enemies are spawned.
  int _spawnLevel;

  EnemyManager() {
    _random = Random();
    _spawnLevel = 0;
    _timer = Timer(4, repeat: true, callback: () {
      spawnRandomEnemy();
    });
  }

  /// This method is responsible for spawning an enemy of random [EnemyType].
  void spawnRandomEnemy() {
    /// Get a random integer from 0 to number of [EnemyType]s -1.
    final randomNumber = _random.nextInt(EnemyType.values.length);
    final randomEnemyType = EnemyType.values.elementAt(randomNumber);
    final newEnemy = Enemy(randomEnemyType);
    gameRef.addLater(newEnemy);
  }

  /// This method starts the [_timer]. It get called when this [EnemyManager]
  /// gets added to an [Game] instance.
  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  /// Not needed for [EnemyManager] but [Component] class forces to implement it.
  @override
  void render(Canvas c) {}

  @override
  void update(double t) {
    _timer.update(t);

    /// This increases [_spawnLevel] by 1, every 500 score points.
    var newSpawnLevel = (gameRef.score ~/ 500);
    if (_spawnLevel < newSpawnLevel) {
      _spawnLevel = newSpawnLevel;

      // y = 4 / (1 + 0.1 * x)
      var newWaitTime = (4 / (1 + (0.1 * _spawnLevel)));

      _timer.stop();
      _timer = Timer(newWaitTime, repeat: true, callback: () {
        spawnRandomEnemy();
      });
      _timer.start();
    }
  }
}
