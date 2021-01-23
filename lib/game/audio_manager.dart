import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

/// This class is the common interface between [DinoRun]
/// and [Flame] engine's audio APIs.
class AudioManager {
  AudioManager._internal();

  /// [_instance] represents the single static instance of [AudioManager].
  static AudioManager _instance = AudioManager._internal();

  /// A getter to access the single instance of [AudioManager].
  static AudioManager get instance => _instance;

  /// This method is responsible for initializing
  /// [listenableBgm] and [listenableSfx] by reading user preferences.
  /// It is also responsible for pre-caching given list of [files].
  Future<void> init(List<String> files) async {
    Flame.bgm.initialize();
    await Flame.audio.loadAll(files);

    _pref = await Hive.openBox('preferences');

    // On first launch of the game SFX will be null,
    // so set it to true.
    if (_pref.get('sfx') == null) {
      _pref.put('sfx', true);
    }

    // On first launch of the game BGM will be null,
    // so set it to true.
    if (_pref.get('bgm') == null) {
      _pref.put('bgm', true);
    }

    _sfx = ValueNotifier(_pref.get('sfx'));
    _bgm = ValueNotifier(_pref.get('bgm'));
  }

  Box _pref;
  ValueNotifier<bool> _sfx;
  ValueNotifier<bool> _bgm;

  // Provides value of SFX as a listenable.
  ValueNotifier<bool> get listenableSfx => _sfx;

  // Provides value of BGM as a listenable.
  ValueNotifier<bool> get listenableBgm => _bgm;

  // Use this method to change state of SFX.
  void setSfx(bool flag) {
    _pref.put('sfx', flag);
    _sfx.value = flag;
  }

  // Use this method to change state of BGM.
  void setBgm(bool flag) {
    _pref.put('bgm', flag);
    _bgm.value = flag;
  }

  // Starts the given audio file as BGM on loop.
  void startBgm(String fileName) {
    if (_bgm.value) {
      Flame.bgm.play(fileName, volume: 0.4);
    }
  }

  // Pauses currently playing BGM if any.
  void pauseBgm() {
    if (_bgm.value) {
      Flame.bgm.pause();
    }
  }

  // Resumes currently paused BGM if any.
  void resumeBgm() {
    if (_bgm.value) {
      Flame.bgm.resume();
    }
  }

  // Stops currently playing BGM if any.
  void stopBgm() {
    if (_bgm.value) {
      Flame.bgm.stop();
    }
  }

  // Plays the given audio file once.
  void playSfx(String fileName) {
    if (_sfx.value) {
      Flame.audio.play(fileName);
    }
  }
}
