import 'package:dino_run/game/audio_manager.dart';
import 'package:flutter/material.dart';

/// This class displays the settings menu on [MainMenu].
class Settings extends StatelessWidget {
  final Function onBackPressed;

  const Settings({
    Key key,
    @required this.onBackPressed,
  })  : assert(onBackPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Settings',
            style: TextStyle(fontSize: 60.0, color: Colors.white),
          ),
          ValueListenableBuilder(
            valueListenable: AudioManager.instance.listenableSfx,
            builder: (BuildContext context, bool isSfxOn, Widget child) {
              return SwitchListTile(
                value: isSfxOn,
                title: Text(
                  'SFX',
                  style: TextStyle(fontSize: 30.0, color: Colors.white),
                ),
                onChanged: (bool value) {
                  AudioManager.instance.setSfx(value);
                },
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: AudioManager.instance.listenableBgm,
            builder: (BuildContext context, bool isBgmOn, Widget child) {
              return SwitchListTile(
                value: isBgmOn,
                title: Text(
                  'BGM',
                  style: TextStyle(fontSize: 30.0, color: Colors.white),
                ),
                onChanged: (bool value) {
                  AudioManager.instance.setBgm(value);
                },
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 30.0,
              color: Colors.white,
            ),
            onPressed: onBackPressed,
          ),
        ],
      ),
    );
  }
}
