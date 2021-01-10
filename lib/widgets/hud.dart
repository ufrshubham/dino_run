import 'package:flutter/material.dart';

// Builds the heads-up display for this game.
class HUD extends StatelessWidget {
  // This function will be called when pause button is pressed.
  final Function onPausePressed;

  // A value notifier to update the health bar.
  final ValueNotifier<int> life;

  const HUD({
    Key key,
    @required this.onPausePressed,
    @required this.life,
  })  : assert(onPausePressed != null),
        assert(life != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            Icons.pause,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () {
            onPausePressed.call();
          },
        ),
        ValueListenableBuilder(
          valueListenable: life,
          builder: (BuildContext context, value, Widget child) {
            final list = List<Widget>();

            // This loop decides how many hearts are filled and how many are empty
            // depending upon the current dino life.
            for (int i = 0; i < 5; ++i) {
              list.add(
                Icon(
                  (i < value) ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              );
            }

            return Row(
              children: list,
            );
          },
        )
      ],
    );
  }
}
