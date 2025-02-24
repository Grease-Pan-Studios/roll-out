import 'dart:math';
import 'package:amaze_game/states/settings_state.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final List<String> sfxAssets;
  final SettingsState settingsState;
  final List<AudioPlayer> _sfxPlayers = [];

  late AudioSession session;

  bool _isPlayingSfx = false;
  int bufferTime = 200; // in milliseconds

  AudioPlayerService({
    required this.sfxAssets,
    required this.settingsState,
  });

  Future<void> initialize() async {
    // Configure the audio session to not stop other apps' audio
    session = await AudioSession.instance;

    // Configuring the session to play audio in the background
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
      androidWillPauseWhenDucked: true,
    ));

    // Initialize the SFX players
    for (String asset in sfxAssets) {
      final player = AudioPlayer();
      await player.setAsset(asset);
      _sfxPlayers.add(player);
    }
  }

  Future<void> playSfxSound({double volume = 1, int? index}) async {
    if (_isPlayingSfx || _sfxPlayers.isEmpty) {
      return;
    }
    _isPlayingSfx = true;

    assert(index == null || (index >= 0 && index < _sfxPlayers.length), 'Invalid Index');

    index ??= Random().nextInt(_sfxPlayers.length);
    AudioPlayer player = _sfxPlayers[index];

    // Pitch range 0.95 to 1.05
    player.setPitch(1 + (Random().nextDouble() - 0.5) * 0.1);
    player.setVolume(2 * volume);

    if (await session.setActive(true)) {
      await player.seek(Duration.zero);
    }
    await session.setActive(false);

    try {
      await player.play();
    } catch (e) {
      print("Error Playing SFX: $e");
    } finally {
      Future.delayed(Duration(milliseconds: bufferTime), () {
        _isPlayingSfx = false;
      });
    }
  }
}
