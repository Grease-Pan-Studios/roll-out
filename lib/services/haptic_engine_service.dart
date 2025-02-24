
import 'package:amaze_game/states/settings_state.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class HapticEngineService{


  SettingsState settingsState;

  late bool canVibrate;

  bool _isVibrating = false;
  int bufferTime = 200; // in milliseconds

  HapticEngineService({
    required this.settingsState
  });

  Future<void> initialize() async{
    canVibrate = await Haptics.canVibrate();
  }

  Future<void> vibrate({required HapticsType type}) async{


    if (_isVibrating
        || !settingsState.hapticEnabled
        || !canVibrate){
      return;
    }

    _isVibrating = true;

    if (canVibrate){
      Haptics.vibrate(type);
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

    await vibrate(type: HapticsType.selection);
  }
}