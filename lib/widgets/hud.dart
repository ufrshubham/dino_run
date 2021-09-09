import 'package:dino_run/game/dino_run.dart';
import 'package:dino_run/models/player_data.dart';
import 'package:dino_run/widgets/pause_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Hud extends StatelessWidget {
  final DinoRun gameRef;
  static const id = 'Hud';

  const Hud(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gameRef.playerData,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Selector<PlayerData, int>(
              selector: (_, playerData) => playerData.currentScore,
              builder: (_, score, __) {
                return Text(
                  'Score: $score',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                );
              },
            ),
            TextButton(
              onPressed: () {
                gameRef.overlays.remove(Hud.id);
                gameRef.overlays.add(PauseMenu.id);
                gameRef.pauseEngine();
              },
              child: Icon(Icons.pause, color: Colors.white),
            ),
            Selector<PlayerData, int>(
              selector: (_, playerData) => playerData.remainingLives,
              builder: (_, lives, __) {
                return Row(
                  children: List.generate(5, (index) {
                    if (index < lives) {
                      return Icon(
                        Icons.favorite,
                        color: Colors.red,
                      );
                    } else {
                      return Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      );
                    }
                  }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
