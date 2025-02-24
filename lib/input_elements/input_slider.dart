
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:flutter/material.dart';

class InputSlider extends StatelessWidget {

  final double value;

  final void Function(double) onChange;

  final ColorPaletteLogic colorPalette;

  const InputSlider({
    super.key,
    required this.value,
    required this.onChange,
    required this.colorPalette,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: const SliderThemeData(
        trackShape: _CustomSliderTrackShape(),
        thumbShape: CustomSliderThumbShape(),
        // overlayShape: _CustomSliderOverlayShape(),
        overlayShape: CustomOverlaySliderOverlayShape(overlayRadius: 10.0),

      ),
      child: Slider(
        value: value,
        onChanged: onChange,
        activeColor: colorPalette.activeElementBorder,
        inactiveColor: colorPalette.inactiveElementBorder,
      ),
    );
  }
}


class _CustomSliderTrackShape extends RoundedRectSliderTrackShape {
  const _CustomSliderTrackShape();
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class CustomSliderThumbShape extends RoundSliderThumbShape {
  const CustomSliderThumbShape({
    super.enabledThumbRadius = 6,
    super.disabledThumbRadius = 1,
    super.pressedElevation = 1,
  });

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    super.paint(context,
        center,
        activationAnimation: activationAnimation,
        enableAnimation: enableAnimation,
        isDiscrete: isDiscrete,
        labelPainter: labelPainter,
        parentBox: parentBox,
        sliderTheme: sliderTheme,
        textDirection: textDirection,
        value: value,
        textScaleFactor: textScaleFactor,
        sizeWithOverflow: sizeWithOverflow
    );
  }
}

class CustomOverlaySliderOverlayShape extends RoundSliderOverlayShape {
  final double overlayRadius;
  const CustomOverlaySliderOverlayShape({this.overlayRadius = 5.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(overlayRadius);

  // Optionally, you can also override paint to customize the appearance
  // or leave it as is to maintain default behavior.
  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    // You can call super.paint to keep the default overlay painting,
    // which will use the overlayRadius for its drawing.
    super.paint(
      context,
      center,
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      isDiscrete: isDiscrete,
      labelPainter: labelPainter,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      textDirection: textDirection,
      value: value,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
    );
  }
}
