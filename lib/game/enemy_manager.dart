import 'dart:math';

import 'package:dino_run/game/dino_run.dart';
import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/models/enemy_data.dart';
import 'package:flame/components.dart';

class EnemyManager extends BaseComponent with HasGameRef<DinoRun> {
  final List<EnemyData> _data = [];

  Random _random = Random();
  Timer _timer = Timer(2, repeat: true);

  EnemyManager() {
    _timer.callback = spawnRandomEnemy;
  }

  void spawnRandomEnemy() {
    final randomIndex = _random.nextInt(_data.length);
    final enemyData = _data.elementAt(randomIndex);
    final enemy = Enemy(enemyData);

    final randomPosition = Vector2.random();

    enemy.position = Vector2(
      randomPosition.x * (gameRef.size.x - enemyData.textureSize.x),
      randomPosition.y * (gameRef.size.y - enemyData.textureSize.y),
    );
    enemy.size = enemyData.textureSize;
    gameRef.add(enemy);
  }

  @override
  void onMount() {
    _data.addAll([
      EnemyData(
        image: gameRef.images.fromCache('AngryPig/Walk (36x30).png'),
        nFrames: 16,
        stepTime: 0.1,
        textureSize: Vector2(36, 30),
      ),
      EnemyData(
        image: gameRef.images.fromCache('Bat/Flying (46x30).png'),
        nFrames: 7,
        stepTime: 0.1,
        textureSize: Vector2(46, 30),
      ),
      EnemyData(
        image: gameRef.images.fromCache('Rino/Run (52x34).png'),
        nFrames: 6,
        stepTime: 0.09,
        textureSize: Vector2(52, 34),
      ),
    ]);
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }
}
