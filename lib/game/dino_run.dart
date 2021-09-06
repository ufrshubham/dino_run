import 'package:dino_run/game/dino.dart';
import 'package:dino_run/game/enemy_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';

class DinoRun extends BaseGame with TapDetector, HasCollidables {
  static const _imageAssets = [
    'DinoSprites - tard.png',
    'AngryPig/Walk (36x30).png',
    'Bat/Flying (46x30).png',
    'Rino/Run (52x34).png',
  ];

  late Dino _dino;

  @override
  Future<void> onLoad() async {
    debugMode = true;
    await images.loadAll(_imageAssets);

    this.viewport = FixedResolutionViewport(Vector2(320, 180));

    _dino = Dino.fromFrameData(images.fromCache('DinoSprites - tard.png'));

    _dino.anchor = Anchor.center;
    _dino.position = size / 2;
    _dino.size = Vector2.all(24);
    _dino.current = DinoAnimationStates.Run;

    add(_dino);

    final enemyManager = EnemyManager();
    add(enemyManager);

    add(ScreenCollidable());

    return super.onLoad();
  }

  @override
  Color backgroundColor() => Colors.grey;

  @override
  void onTap() {
    _dino.current = DinoAnimationStates.Idle;
    super.onTap();
  }
}
