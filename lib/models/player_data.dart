import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'player_data.g.dart';

@HiveType(typeId: 0)
class PlayerData extends ChangeNotifier with HiveObjectMixin {
  @HiveField(1)
  int highScore = 0;

  int _lives = 5;
  int get remainingLives => _lives;

  int _currentScore = 0;
  int get currentScore => _currentScore;

  void increaseScoreBy(int value) {
    _currentScore += value;

    if (highScore < _currentScore) {
      highScore = _currentScore;
    }

    notifyListeners();
    save();
  }

  void reduceLife() {
    if (_lives > 0) {
      _lives -= 1;
      notifyListeners();
    }
  }
}
