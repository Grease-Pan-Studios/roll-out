
import 'package:amaze_game/states/settings_state.dart';

import 'package:vibration/vibration.dart';

class HapticEngineService{


  SettingsState settingsState;

  late bool canVibrate;

  bool _isVibrating = false;
  int bufferTime = 250; // in milliseconds

  HapticEngineService({
    required this.settingsState
  });

  Future<void> initialize() async{
    // canVibrate = await Haptics.canVibrate();
    canVibrate = await Vibration.hasVibrator();
  }

  Future<void> vibrate({required int amplitude}) async{

    if (_isVibrating
        || !settingsState.hapticEnabled
        || !canVibrate){
      return;
    }
    _isVibrating = true;

    amplitude = amplitude.clamp(1, 255);

    if (canVibrate){
      await Vibration.vibrate(
          duration: 5,
          amplitude: amplitude
      );
    }

    Future.delayed(Duration(milliseconds: bufferTime), (){
      _isVibrating = false;
    });

  }

  Future<void> selection() async {

    if (!settingsState.hapticEnabled
        || !canVibrate
        || _isVibrating){
      return;
    }

    await Vibration.vibrate(
      duration: 10,
      amplitude: 15
    );
  }





}