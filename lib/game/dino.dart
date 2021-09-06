import 'dart:ui';

import 'package:dino_run/game/enemy.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

enum DinoAnimationStates {
  Idle,
  Run,
  Kick,
  Hit,
  Sprint,
}

class Dino extends SpriteAnimationGroupComponent<DinoAnimationStates>
    with Hitbox, Collidable {
  static final _animationMap = {
    DinoAnimationStates.Idle: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
    ),
    DinoAnimationStates.Run: SpriteAnimationData.sequenced(
      amount: 7,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4) * 24, 0),
    ),
    DinoAnimationStates.Kick: SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4 + 7) * 24, 0),
    ),
    DinoAnimationStates.Hit: SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4 + 7 + 3) * 24, 0),
    ),
    DinoAnimationStates.Sprint: SpriteAnimationData.sequenced(
      amount: 7,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4 + 7 + 3 + 3) * 24, 0),
    ),
  };

  Dino.fromFrameData(Image image) : super.fromFrameData(image, _animationMap);

  @override
  void onMount() {
    final shape = HitboxRectangle(relation: Vector2(0.5, 0.7));
    addShape(shape);

    super.onMount();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Enemy) {
      this.current = DinoAnimationStates.Hit;
    }
    super.onCollision(intersectionPoints, other);
  }
}
