import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/screens/main_menu.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  await performInitialSetup();
  runApp(MyApp());
}

// This function is responsible for setting up
// full-screen, landscape mode, user preferences
// and pre-caching of audio.
Future performInitialSetup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.util.fullScreen();
  await Flame.util.setLandscape();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  await AudioManager.instance
      .init(['8Bit Platformer Loop.wav', 'hurt7.wav', 'jump14.wav']);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dino Run',
      theme: ThemeData(
        fontFamily: 'Audiowide',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainMenu(),
    );
  }
}
