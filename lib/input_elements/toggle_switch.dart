

import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';


class ToggleSwitch extends StatelessWidget {

  final ColorPaletteLogic colorPalette;
  final bool state;
  final void Function(bool) setState;

  final String onLabel;
  final String offLabel;


  const ToggleSwitch({
    super.key,
    required this.state,
    required this.setState,
    required this.colorPalette,
    this.offLabel = 'Off',
    this.onLabel = 'On',
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch.dual(
      current: state,
      onChanged: setState,
      first: true,
      second: false,
      height: 25,
      // minTouchTargetSize: 500,
      style: ToggleStyle(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        indicatorBorderRadius: BorderRadius.all(Radius.circular(7)),
        indicatorColor:  colorPalette.activeElementBorder,

        indicatorBorder: Border.all(
          color: colorPalette.activeElementBorder,
          strokeAlign: BorderSide.strokeAlignOutside,
          width: 2
        ),

        backgroundColor: colorPalette.inactiveElementBackground,
        borderColor: colorPalette.activeElementBorder,
      ),
      // minTouchTargetSize: 0,
      // textMargin: EdgeInsets.zero,
      indicatorSize: Size(55, 25),
      spacing: -15,
      animationOffset: Offset(0, 0),
      textBuilder: (bool state){
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            state ? offLabel : onLabel,
            style: TextStyle(
              fontFamily: 'Advent',
              color: colorPalette.inactiveElementText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.45,
              // height: 1
            ),
          ),
        );
      },
      iconBuilder: (bool state){
          return Text(
            state ? onLabel : offLabel,
            style: TextStyle(
              fontFamily: 'Advent',
              color: colorPalette.activeElementBackground,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.45,
              height: 0.1
            ),
          );
      },
      indicatorTransition: ForegroundIndicatorTransition.fading(),

    );
  }
}
