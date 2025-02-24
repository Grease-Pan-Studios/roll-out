
import 'package:hive/hive.dart';
part 'level_state.g.dart';

@HiveType(typeId:0)
class LevelState{

  @HiveField(0)
  final LevelStateEnum state;

  @HiveField(1)
  final int rating;

  @HiveField(2)
  final Duration completionTime;

  LevelState({
    required this.state,
    this.rating = -1,
    this.completionTime = const Duration(seconds: 0),
  }){
    assert(state != LevelStateEnum.completed || rating >= 0 && rating <= 3);
    assert(state != LevelStateEnum.completed || completionTime.inMilliseconds > 0);
  }

  bool isCompleted(){
    return state == LevelStateEnum.completed;
  }

}


@HiveType(typeId:1)
enum LevelStateEnum {

  @HiveField(0)
  locked,

  @HiveField(1)
  unlocked,

  @HiveField(2)
  completed,
}
