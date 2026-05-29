import 'package:audioplayers/audioplayers.dart';

class MusicService {

  static final AudioPlayer player =
      AudioPlayer();

  static bool started = false;

  static bool isMuted = false;

  static Future<void> startMusic() async {

    if (started) return;

    started = true;

    isMuted = false;

    await player.setReleaseMode(
      ReleaseMode.loop,
    );

    await player.play(
      AssetSource(
        "sounds/theme.mp3",
      ),
    );

  }

  static Future<void> toggleMusic() async {

    if (isMuted) {

      await player.resume();

      isMuted = false;

    } else {

      await player.pause();

      isMuted = true;

    }

  }

  static Future<void> pauseMusic() async {

    await player.pause();

  }

  static Future<void> resumeMusic() async {

    if (!isMuted) {

      await player.resume();

    }

  }

}