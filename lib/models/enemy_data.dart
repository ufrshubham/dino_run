import 'package:flame/extensions.dart';

class EnemyData {
  final Image image;
  final int nFrames;
  final double stepTime;
  final Vector2 textureSize;

  const EnemyData({
    required this.image,
    required this.nFrames,
    required this.stepTime,
    required this.textureSize,
  });
}
