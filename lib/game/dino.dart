import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flame/time.dart';

import 'constants.dart';

/// This class represents the main dino character.
class Dino extends AnimationComponent {
  // Holds a reference to run animation.
  Animation _runAnimation;

  // Holds a reference to hit animation.
  Animation _hitAnimation;

  /// This timer is used to automatically reset [animation]
  ///  to [_runAnimation] once [hit] is called.
  Timer _timer;

  // Indicates if dino is current hit or not.
  bool _isHit;

  // Dino's current speed along y-axis.
  double speedY = 0.0;

  // The max distance from top of the screen beyond which
  // dino should never go. Basically the screen height - ground height
  double yMax = 0.0;

  Dino() : super.empty() {
    // 0 - 3 = idle
    // 4 - 10 = run
    // 11 - 13 = kick
    // 14 - 16 = hit
    // 17 - 23 = Sprint

    /// Reads the sprite sheet for dino and creates a [SpriteSheet] object.
    final spriteSheet = SpriteSheet(
      imageName: 'DinoSprites - tard.png',
      textureWidth: 24,
      textureHeight: 24,
      columns: 24,
      rows: 1,
    );

    _runAnimation =
        spriteSheet.createAnimation(0, from: 4, to: 10, stepTime: 0.1);

    _hitAnimation =
        spriteSheet.createAnimation(0, from: 14, to: 16, stepTime: 0.1);

    // By default Dino will be running.
    this.animation = _runAnimation;

    /// Calls [run] method after 1 second
    /// everytime [_timer.start] is called.
    _timer = Timer(1, callback: () {
      run();
    });
    _isHit = false;

    // This makes sure that origin of dino is at its center, instead of top-left corner.
    this.anchor = Anchor.center;
  }

  @override
  void resize(Size size) {
    super.resize(size);

    /// Resizes dino sprite such that exactly [numberOfTilesAlongWidth] number of
    /// dinos can fix horizontally.
    this.height = this.width = size.width / numberOfTilesAlongWidth;

    this.x = this.width;
    this.y =
        size.height - groundHeight - (this.height / 2) + dinoTopBottomSpacing;
    this.yMax = this.y;
  }

  @override
  void update(double t) {
    super.update(t);
    // v = u + at
    this.speedY += GRAVITY * t;

    // d = s0 + s * t
    this.y += this.speedY * t;

    /// This code makes sure that dino never goes beyond [yMax].
    if (isOnGround()) {
      this.y = this.yMax;
      this.speedY = 0.0;
    }

    // NOTE: Never forget to update the timer, because Flame's timer
    // depends on gameloop's update for its calculations.
    _timer.update(t);
  }

  // Returns true if dino is on ground.
  bool isOnGround() {
    return (this.y >= this.yMax);
  }

  /// Sets [animation] to [_runAnimation]
  void run() {
    _isHit = false;
    this.animation = _runAnimation;
  }

  /// Sets [animation] to [_hitAnimation]
  void hit() {
    // Ignore if already in hit state.
    if (!_isHit) {
      this.animation = _hitAnimation;

      /// Start the timer so that animation is reset to [_runAnimation]
      /// after 1 seconds.
      _timer.start();
    }
  }

  // Makes the dino jump.
  void jump() {
    // Jump only if dino is on ground.
    if (isOnGround()) {
      this.speedY = -500;
    }
  }
}
