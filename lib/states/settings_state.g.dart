// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsStateAdapter extends TypeAdapter<SettingsState> {
  @override
  final int typeId = 2;

  @override
  SettingsState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsState()
      .._volume = fields[0] as double
      .._tiltSensitivity = fields[1] as double
      .._tiltRange = fields[2] as double
      ..hapticEnabled = fields[3] as bool
      ..isDarkMode = fields[4] as bool;
  }

  @override
  void write(BinaryWriter writer, SettingsState obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj._volume)
      ..writeByte(1)
      ..write(obj._tiltSensitivity)
      ..writeByte(2)
      ..write(obj._tiltRange)
      ..writeByte(3)
      ..write(obj.hapticEnabled)
      ..writeByte(4)
      ..write(obj.isDarkMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
