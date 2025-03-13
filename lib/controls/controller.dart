
import 'dart:async';
import 'dart:math';
import 'package:amaze_game/states/settings_state.dart';
import 'package:sensors_plus/sensors_plus.dart';


class Controller {

  late final StreamSubscription<AccelerometerEvent> _accelerometerSubscription;

  double x = 0; // Based on Pitch
  double y = 0; // Based on Roll

  double maxRollRange = 90;
  double maxPitchRange = 90;

  double minRollRange = 15;
  double minPitchRange = 15;

  // double rollRange = 30; // in degrees (-rollRange, rollRange)
  // double pitchRange = 30; // in degrees (-pitchRange, pitchRange)

  SettingsState settingsState;

  Controller({
    required this.settingsState,
  }) {

    _accelerometerSubscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.normalInterval,
    ).listen(
          (AccelerometerEvent event) {

        // Calculate roll and pitch in degrees.
        double roll = atan2(event.y, event.z) * (180 / pi);
        double pitch = atan2(-event.x, sqrt(event.y * event.y + event.z * event.z)) * (180 / pi);

        double rollRange = minRollRange + settingsState.tiltRange * (maxRollRange - minRollRange);
        double pitchRange = minPitchRange + settingsState.tiltRange * (maxPitchRange - minPitchRange);

        double clippedRoll = roll.clamp(-rollRange, rollRange);
        double clippedPitch = pitch.clamp(-pitchRange, pitchRange);

        x = clippedPitch / pitchRange;
        y = clippedRoll / rollRange;

        // Print the computed orientation values.
        // print("Roll: $roll, Pitch: $pitch");
        // print("X: $x, Y: $y");
      },

      onDone: () {
        print("Task Done");
      },

      cancelOnError: false,

      onError: (e) {
        print("Error: $e");
      },
    );
  }

  void dispose() {
    _accelerometerSubscription.cancel();
  }
}
