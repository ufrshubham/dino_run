import 'dart:math';
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/foundation.dart';

import 'constants.dart';

// This enum defines all the enemy types.
enum EnemyType { AngryPig, Bat, Rino }

/// This class holds all the necessary data for creation of an [Enemy].
class EnemyData {
  // Path to sprite sheet of this enemy.
  final String imageName;

  /// Width of a single sprite from the sprite sheet located at [imageName].
  final int textureWidth;

  /// Height of a single sprite from the sprite sheet located at [imageName].
  final int textureHeight;

  /// Number of columns in sprite sheet located at [imageName].
  final int nColumns;

  /// Number of rows in sprite sheet located at [imageName].
  final int nRows;

  /// Indicates if this enemy can fly. If true, spawns this enemy
  /// at two different height randomly.
  final bool canFly;

  // Speed along x direction.
  final int speed;

  const EnemyData({
    @required this.imageName,
    @required this.textureWidth,
    @required this.textureHeight,
    @required this.nColumns,
    @required this.nRows,
    @required this.canFly,
    @required this.speed,
  });
}

// This class represents enemy characters.
class Enemy extends AnimationComponent {
  /// Reference to [EnemyData] used for creation of this enemy.
  EnemyData _myData;

  /// A shared random generator for all the [Enemy]s.
  static Random _random = Random();

  /// A shared constant map of [EnemyType] and their corresponding [EnemyData].
  static const Map<EnemyType, EnemyData> _enemyDetails = {
    EnemyType.AngryPig: EnemyData(
      imageName: 'AngryPig/Walk (36x30).png',
      nColumns: 16,
      nRows: 1,
      textureHeight: 30,
      textureWidth: 36,
      canFly: false,
      speed: 250,
    ),
    EnemyType.Bat: EnemyData(
      imageName: 'Bat/Flying (46x30).png',
      nColumns: 7,
      nRows: 1,
      textureHeight: 30,
      textureWidth: 46,
      canFly: true,
      speed: 300,
    ),
    EnemyType.Rino: EnemyData(
      imageName: 'Rino/Run (52x34).png',
      nColumns: 6,
      nRows: 1,
      textureHeight: 34,
      textureWidth: 52,
      canFly: false,
      speed: 350,
    ),
  };

  Enemy(EnemyType enemyType) : super.empty() {
    /// First get reference to correct [EnemyData].
    _myData = _enemyDetails[enemyType];

    final spriteSheet = SpriteSheet(
      imageName: _myData.imageName,
      textureWidth: _myData.textureWidth,
      textureHeight: _myData.textureHeight,
      columns: _myData.nColumns,
      rows: _myData.nRows,
    );

    this.animation = spriteSheet.createAnimation(0,
        from: 0, to: (_myData.nColumns - 1), stepTime: 0.1);

    // Makes sure that origin is at center of enemy sprite.
    this.anchor = Anchor.center;
  }

  @override
  void resize(Size size) {
    super.resize(size);

    /// The scale factor to be multiplied with [this.width] to make it
    /// equal to dino's width.
    double scaleFactor =
        (size.width / numberOfTilesAlongWidth) / _myData.textureWidth;

    /// Resizes dino sprite such that exactly [numberOfTilesAlongWidth] number of
    /// enemies can fix horizontally.
    this.height = _myData.textureHeight * scaleFactor;
    this.width = _myData.textureWidth * scaleFactor;

    /// Places enemy a little off screen on right end and just above on ground.
    this.x = size.width + this.width;
    this.y = size.height - groundHeight - (this.height / 2);

    /// If this enemy can fly, place it randomly along y-axis.
    if (_myData.canFly && _random.nextBool()) {
      this.y -= this.height;
    }
  }

  @override
  void update(double t) {
    super.update(t);
    this.x -= _myData.speed * t;
  }

  // This method is used by the flame engine to check if this component should be destroyed.
  @override
  bool destroy() {
    // Let the framework know that this enemy can be destroyed
    // once it goes off screen from left end.
    return (this.x < (-this.width));
  }
}
