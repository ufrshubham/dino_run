import 'dart:ui';

import 'package:eduplay_ads/eduplay_ads.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/widgets/hud.dart';
import '/game/dino_run.dart';
import '/widgets/main_menu.dart';
import '/models/player_data.dart';
import '/game/audio_manager.dart';

// This represents the game over overlay, displayed when dino runs out of
// lives. EduPlay integration: the death detection lives in DinoRun.update()
// and is kept pristine; the educational ad-break is shown from here, the
// natural restart screen, because it has a BuildContext (required by
// EduPlayRewardedAd.show()) and is the natural pause point. The break is shown
// exactly once when this overlay first mounts; the existing Restart/Exit
// buttons handle resume unchanged (the WebView route pops back to this card).
class GameOverMenu extends StatefulWidget {
  // An unique identified for this overlay.
  static const id = 'GameOverMenu';

  // Reference to parent game.
  final DinoRun game;

  const GameOverMenu(this.game, {super.key});

  @override
  State<GameOverMenu> createState() => _GameOverMenuState();
}

class _GameOverMenuState extends State<GameOverMenu> {
  // Your game's identifier from the EduPlay developer portal. Placeholder for
  // the mock-mode evaluation — replace with your real placement ID to ship.
  static const _placementId = 'pl_mock00000000000000000000';

  EduPlayRewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    // Preload, then show the educational break once after the first frame so a
    // valid BuildContext is mounted for EduPlayRewardedAd.show().
    _loadAndShowAd();
  }

  void _loadAndShowAd() {
    EduPlayRewardedAd.load(
      placementId: _placementId,
      // Mock mode (set in main.dart) ignores the token; pass empty for eval.
      studentToken: '',
      adLoadCallback: EduPlayAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          ad.fullScreenContentCallback = EduPlayFullScreenContentCallback(
            // Always resume here (correct answer, wrong answer, or skip). The
            // game stays paused behind this overlay; the Restart/Exit buttons
            // remain the resume path, so just dispose and re-arm the next ad.
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
            },
            // Do not block the restart flow if the break fails to show.
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
            },
          );
          // Defer to after the first frame so Navigator/context are ready.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            ad.show(
              context: context,
              onUserEarnedReward: (ad, reward) {
                // reward.amount == 1 for a correct answer; grant a bonus here
                // (e.g. an extra life) if desired. No-op for the evaluation.
              },
            );
          });
        },
        // Loading the break is best-effort; never block the game-over screen.
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    return ChangeNotifierProvider.value(
      value: game.playerData,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.black.withAlpha(100),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 100,
                ),
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    const Text(
                      'Game Over',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    Selector<PlayerData, int>(
                      selector: (_, playerData) => playerData.currentScore,
                      builder: (_, score, __) {
                        return Text(
                          'You Score: $score',
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      child: const Text(
                        'Restart',
                        style: TextStyle(fontSize: 30),
                      ),
                      onPressed: () {
                        game.overlays.remove(GameOverMenu.id);
                        game.overlays.add(Hud.id);
                        game.resumeEngine();
                        game.reset();
                        game.startGamePlay();
                        AudioManager.instance.resumeBgm();
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Exit', style: TextStyle(fontSize: 30)),
                      onPressed: () {
                        game.overlays.remove(GameOverMenu.id);
                        game.overlays.add(MainMenu.id);
                        game.resumeEngine();
                        game.reset();
                        AudioManager.instance.resumeBgm();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
