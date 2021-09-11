import 'package:flame/geometry.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import '/game/dino_run.dart';
import '/models/enemy_data.dart';

// This represents an enemy in the game world.
class Enemy extends SpriteAnimationComponent
    with Hitbox, Collidable, HasGameRef<DinoRun> {
  // The data required for creation of this enemy.
  final EnemyData enemyData;

  Enemy(this.enemyData) {
    this.animation = SpriteAnimation.fromFrameData(
      enemyData.image,
      SpriteAnimationData.sequenced(
        amount: enemyData.nFrames,
        stepTime: enemyData.stepTime,
        textureSize: enemyData.textureSize,
      ),
    );
  }

  @override
  void onMount() {
    // Add a hitbox for this enemy.
    final shape = HitboxRectangle(relation: Vector2.all(0.8));
    addShape(shape);
    // Reduce the size of enemy as they look too
    // big compared to the dino.
    this.size *= 0.6;
    super.onMount();
  }

  @override
  void update(double dt) {
    this.position.x -= enemyData.speedX * dt;

    // Remove the enemy and increase player score
    // by 1, if enemy has gone past left end of the screen.
    if (this.position.x < -5) {
      remove();
      gameRef.playerData.currentScore += 1;
    }

    super.update(dt);
  }
}
