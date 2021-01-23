import 'package:dino_run/screens/game_play.dart';
import 'package:flutter/material.dart';

/// This class displays the first menu on [MainMenu]
/// with play and settings buttons.
class Menu extends StatelessWidget {
  final Function onSettingsPressed;

  const Menu({
    Key key,
    @required this.onSettingsPressed,
  })  : assert(onSettingsPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Dino Run',
          style: TextStyle(fontSize: 60.0, color: Colors.white),
        ),
        RaisedButton(
          child: Text(
            'Play',
            style: TextStyle(fontSize: 30.0),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => GamePlay(),
              ),
            );
          },
        ),
        RaisedButton(
          child: Text(
            'Settings',
            style: TextStyle(fontSize: 30.0),
          ),
          onPressed: onSettingsPressed,
        )
      ],
    );
  }
}
