// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelStateAdapter extends TypeAdapter<LevelState> {
  @override
  final int typeId = 0;

  @override
  LevelState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LevelState(
      state: fields[0] as LevelStateEnum,
      rating: fields[1] as int,
      completionTime: fields[2] as Duration,
    );
  }

  @override
  void write(BinaryWriter writer, LevelState obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.state)
      ..writeByte(1)
      ..write(obj.rating)
      ..writeByte(2)
      ..write(obj.completionTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LevelStateEnumAdapter extends TypeAdapter<LevelStateEnum> {
  @override
  final int typeId = 1;

  @override
  LevelStateEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LevelStateEnum.locked;
      case 1:
        return LevelStateEnum.unlocked;
      case 2:
        return LevelStateEnum.completed;
      default:
        return LevelStateEnum.locked;
    }
  }

  @override
  void write(BinaryWriter writer, LevelStateEnum obj) {
    switch (obj) {
      case LevelStateEnum.locked:
        writer.writeByte(0);
        break;
      case LevelStateEnum.unlocked:
        writer.writeByte(1);
        break;
      case LevelStateEnum.completed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelStateEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
