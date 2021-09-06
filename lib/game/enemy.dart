import 'package:dino_run/models/enemy_data.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';

class Enemy extends SpriteAnimationComponent with Hitbox, Collidable {
  Enemy(EnemyData enemyData) {
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
  Future<void>? onLoad() {
    final shape = HitboxRectangle(relation: Vector2.all(0.8));
    addShape(shape);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    this.size *= 0.6;
    super.onGameResize(gameSize);
  }

  @override
  void update(double dt) {
    this.position.x -= 50 * dt;
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is ScreenCollidable) {
      remove();
    }
    super.onCollision(intersectionPoints, other);
  }
}
