
import 'dart:math';
import 'package:amaze_game/states/settings_state.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService {

  final List<String> sfxAssets;
  final SettingsState settingsState;

  final List<AudioPlayer> _sfxPlayers = [];

  bool _isPlayingSfx = false;
  int bufferTime = 200; // in milliseconds

  AudioPlayerService({
    required this.sfxAssets,
    required this.settingsState
  });

  Future<void> initialize() async {

    for (String asset in sfxAssets){
      final player = AudioPlayer();
      await player.setAsset(asset);
      _sfxPlayers.add(player);
    }

  }

  Future<void> playSfxSound({double volume = 1, int? index}) async {

    if (_isPlayingSfx
    // || !settingsState.sfxEnabled
    || _sfxPlayers.isEmpty
    ){
      return;
    }
    _isPlayingSfx = true;

    assert(index == null
        || (index >= 0 && index < _sfxPlayers.length),
          'Invalid Index');

    index ??= Random().nextInt(_sfxPlayers.length);

    AudioPlayer player = _sfxPlayers[index];

    /* Pitch range 0.95 to 1.05 */
    player.setPitch(1 + (Random().nextDouble() - 0.5) * 0.1);
    player.setVolume(2 * volume);

    await player.seek(Duration.zero);

    try{
      await player.play();
    } catch (e) {
      print("Error Playing SFX: $e");
    } finally {

      Future.delayed(Duration(milliseconds: bufferTime), (){
        _isPlayingSfx = false;
      });

      // _isPlayingSfx = false;
    }


  }

}