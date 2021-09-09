import 'package:dino_run/models/player_data.dart';
import 'package:dino_run/widgets/hud.dart';
import 'package:dino_run/widgets/main_menu.dart';
import 'package:dino_run/widgets/pause_menu.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'game/dino_run.dart';

DinoRun _dinoRun = DinoRun();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  await initHive();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dino Run',
      theme: ThemeData(
        fontFamily: 'Audiowide',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: GameWidget(
          loadingBuilder: (conetxt) => Center(
            child: Container(
              width: 200,
              child: LinearProgressIndicator(),
            ),
          ),
          overlayBuilderMap: {
            MainMenu.id: (_, DinoRun gameRef) => MainMenu(gameRef),
            PauseMenu.id: (_, DinoRun gameRef) => PauseMenu(gameRef),
            Hud.id: (_, DinoRun gameRef) => Hud(gameRef),
          },
          initialActiveOverlays: [MainMenu.id],
          game: _dinoRun,
        ),
      ),
    );
  }
}

Future<void> initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter<PlayerData>(PlayerDataAdapter());
}
