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

    enemy.anchor = Anchor.bottomLeft;

    enemy.position = Vector2(
      gameRef.size.x + 32,
      gameRef.size.y - 24,
    );

    if (enemyData.canFly) {
      final newHeight = _random.nextDouble() * 2 * enemyData.textureSize.y;
      enemy.position.y -= newHeight;
    }

    enemy.size = enemyData.textureSize;
    gameRef.add(enemy);
  }

  @override
  void onMount() {
    this.shouldRemove = false;
    _data.addAll([
      EnemyData(
        image: gameRef.images.fromCache('AngryPig/Walk (36x30).png'),
        nFrames: 16,
        stepTime: 0.1,
        textureSize: Vector2(36, 30),
        speedX: 80,
        canFly: false,
      ),
      EnemyData(
        image: gameRef.images.fromCache('Bat/Flying (46x30).png'),
        nFrames: 7,
        stepTime: 0.1,
        textureSize: Vector2(46, 30),
        speedX: 100,
        canFly: true,
      ),
      EnemyData(
        image: gameRef.images.fromCache('Rino/Run (52x34).png'),
        nFrames: 6,
        stepTime: 0.09,
        textureSize: Vector2(52, 34),
        speedX: 150,
        canFly: false,
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

  void removeAllEnemies() {
    final enemies = gameRef.components.whereType<Enemy>();
    enemies.forEach((element) => element.remove());
  }
}
