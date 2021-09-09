import 'package:dino_run/game/dino.dart';
import 'package:dino_run/game/enemy_manager.dart';
import 'package:dino_run/models/player_data.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/parallax.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DinoRun extends BaseGame with TapDetector, HasCollidables {
  static const _imageAssets = [
    'DinoSprites - tard.png',
    'AngryPig/Walk (36x30).png',
    'Bat/Flying (46x30).png',
    'Rino/Run (52x34).png',
    'parallax/plx-1.png',
    'parallax/plx-2.png',
    'parallax/plx-3.png',
    'parallax/plx-4.png',
    'parallax/plx-5.png',
    'parallax/plx-6.png',
  ];

  late Dino _dino;
  late PlayerData playerData;

  @override
  Future<void> onLoad() async {
    playerData = await _readPlayerData();
    await images.loadAll(_imageAssets);

    this.viewport = FixedResolutionViewport(Vector2(320, 180));

    final parallaxBackground = await loadParallaxComponent(
      [
        ParallaxImageData('parallax/plx-1.png'),
        ParallaxImageData('parallax/plx-2.png'),
        ParallaxImageData('parallax/plx-3.png'),
        ParallaxImageData('parallax/plx-4.png'),
        ParallaxImageData('parallax/plx-5.png'),
        ParallaxImageData('parallax/plx-6.png'),
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
    );

    add(parallaxBackground);

    _dino = Dino(images.fromCache('DinoSprites - tard.png'), playerData);

    _dino.anchor = Anchor.bottomLeft;
    _dino.position = Vector2(32, size.y - 22);
    _dino.size = Vector2.all(24);
    _dino.current = DinoAnimationStates.Run;

    add(_dino);

    final enemyManager = EnemyManager();
    add(enemyManager);

    return super.onLoad();
  }

  @override
  Color backgroundColor() => Colors.grey;

  @override
  void onTapDown(TapDownInfo info) {
    _dino.jump();
    super.onTapDown(info);
  }

  Future<PlayerData> _readPlayerData() async {
    final playerDataBox =
        await Hive.openBox<PlayerData>('DinoRun.PlayerDataBox');
    final playerData = playerDataBox.get('DinoRun.PlayerData');
    if (playerData == null) {
      playerDataBox.put('DinoRun.PlayerData', PlayerData());
    }
    return playerDataBox.get('DinoRun.PlayerData')!;
  }
}
