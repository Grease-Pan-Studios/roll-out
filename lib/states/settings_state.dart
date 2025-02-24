
import 'package:hive/hive.dart';
part 'settings_state.g.dart';

@HiveType(typeId:2)
class SettingsState{

  @HiveField(0)
  double _volume = 0.5;

  @HiveField(1)
  double _tiltSensitivity = 0.5;

  @HiveField(2)
  double _tiltRange = 0.5;

  @HiveField(3)
  bool hapticEnabled = true;

  @HiveField(4)
  bool isDarkMode = false;

  set volume(double value){
    _volume = value.clamp(0, 1);
  }

  double get volume => _volume.clamp(0, 1);

  set tiltSensitivity(double value){
    _tiltSensitivity = value.clamp(0, 1);
  }

  double get tiltSensitivity => _tiltSensitivity.clamp(0, 1);

  set tiltRange(double value){
    _tiltRange = value.clamp(0, 1);
  }

  double get tiltRange => _tiltRange.clamp(0, 1);

}