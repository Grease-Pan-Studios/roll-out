

import 'package:flutter/material.dart';

class ColorPaletteLogic{

  double hue;
  bool isColored;
  bool isDarkMode;

  Color primary;
  Color secondary;

  Color activeElementBackground;
  Color activeElementText;
  Color activeElementBorder;

  Color inactiveElementBackground;
  Color inactiveElementText;
  Color inactiveElementBorder;

  VoidCallback? updateTrigger;

  ColorPaletteLogic({
    required this.hue,
    required this.isColored,
    required this.isDarkMode,
    required this.primary,
    required this.secondary,
    required this.activeElementBackground,
    required this.activeElementText,
    required this.activeElementBorder,
    required this.inactiveElementBackground,
    required this.inactiveElementText,
    required this.inactiveElementBorder,
  });


  factory ColorPaletteLogic.fromHue(double hue, {bool isDarkMode = false}){

    if (isDarkMode){
      return ColorPaletteLogic(
        hue: hue,
        isColored: true,
        isDarkMode: true,
        primary: HSLColor.fromAHSL(1, hue, 0.52, 0.12).toColor(),
        secondary: HSLColor.fromAHSL(1, hue, 0.30, 0.28).toColor(),
        activeElementBackground: HSLColor.fromAHSL(1, hue, 0.30, 0.13).toColor(),
        activeElementText: HSLColor.fromAHSL(1, hue, 0.13, 0.78).toColor(),
        activeElementBorder: HSLColor.fromAHSL(0.85, hue, 0.13, 0.78).toColor(),
        inactiveElementBackground: HSLColor.fromAHSL(1, hue, 0.35, 0.18).toColor(),
        inactiveElementText: HSLColor.fromAHSL(1, hue, 0.18, 0.42).toColor(),
        inactiveElementBorder: HSLColor.fromAHSL(0.85, hue, 0.18, 0.42).toColor(),
      );
    }


    return ColorPaletteLogic(
      hue: hue,
      isColored: true,
      isDarkMode: false,
      primary: HSLColor.fromAHSL(1, hue, 0.97, 0.87).toColor(),
      secondary: HSLColor.fromAHSL(1, hue, 1, 0.82).toColor(),
      activeElementBackground: HSLColor.fromAHSL(1, hue, 0.94, 0.93).toColor(),
      activeElementText: HSLColor.fromAHSL(1, hue, 0.2, 0.18).toColor(),
      activeElementBorder: HSLColor.fromAHSL(0.9, hue, 0.2, 0.18).toColor(),
      inactiveElementBackground: HSLColor.fromAHSL(1, hue, 0.95, 0.95).toColor(),
      inactiveElementText: HSLColor.fromAHSL(1, hue, 0.1, 0.5).toColor(),
      inactiveElementBorder: HSLColor.fromAHSL(0.9, hue, 0.1, 0.5).toColor(),
    );
  }

  factory ColorPaletteLogic.asMonochrome({required bool isDarkMode}){
    if (isDarkMode){
      return ColorPaletteLogic.asBlackTheme();
    }
    return ColorPaletteLogic.asWhiteTheme();
  }


  factory ColorPaletteLogic.asWhiteTheme(){
    return ColorPaletteLogic(
      hue: 0,
      isColored: false,
      isDarkMode: false,
      primary: HSLColor.fromAHSL(1, 0, 0, 0.87).toColor(),
      secondary: HSLColor.fromAHSL(1, 0, 0, 0.82).toColor(),
      activeElementBackground: HSLColor.fromAHSL(1, 0, 0, 0.93).toColor(),
      activeElementText: HSLColor.fromAHSL(1, 0, 0, 0.18).toColor(),
      activeElementBorder: HSLColor.fromAHSL(0.9, 0, 0, 0.18).toColor(),
      inactiveElementBackground: HSLColor.fromAHSL(1, 0, 0, 0.95).toColor(),
      inactiveElementText: HSLColor.fromAHSL(1, 0, 0, 0.5).toColor(),
      inactiveElementBorder: HSLColor.fromAHSL(0.9, 0, 0, 0.5).toColor(),
    );

  }

  factory ColorPaletteLogic.asBlackTheme(){
    return ColorPaletteLogic(
      hue: 0,
      isColored: false,
      isDarkMode: true,
      primary: HSLColor.fromAHSL(1, 0, 0, 0.13).toColor(),
      secondary: HSLColor.fromAHSL(1, 0, 0, 0.18).toColor(),
      activeElementBackground: HSLColor.fromAHSL(1, 0, 0, 0.07).toColor(),
      activeElementText: HSLColor.fromAHSL(1, 0, 0, 0.82).toColor(),
      activeElementBorder: HSLColor.fromAHSL(0.9, 0, 0, 0.82).toColor(),
      inactiveElementBackground: HSLColor.fromAHSL(1, 0, 0, 0.05).toColor(),
      inactiveElementText: HSLColor.fromAHSL(1, 0, 0, 0.5).toColor(),
      inactiveElementBorder: HSLColor.fromAHSL(0.9, 0, 0, 0.5).toColor(),
    );
  }

  Color getLightPrimary(){
    if (isDarkMode){
      print("We are Dark");
      return secondary;
    }
    print("We are Light");
    return primary;
  }

  Color getDarkPrimary(){
    if (isDarkMode){
      print("We are Dark");
      return primary;
    }
    print("We are Light");
    return secondary;
  }

  void switchColorMode({required bool isDarkMode}){
    if (isDarkMode){
      if (isColored){
        update(ColorPaletteLogic.fromHue(hue, isDarkMode: true));
      }else{
        update(ColorPaletteLogic.asBlackTheme());
      }
    }else{
      if (isColored){
        update(ColorPaletteLogic.fromHue(hue, isDarkMode: false));
      }else {
        update(ColorPaletteLogic.asWhiteTheme());
      }
    }
  }


  Color getPrimary({
    double? hue,
    bool isDarkMode = false,
    bool isWhiteMode = false}
  ){
    if (isWhiteMode){
      return ColorPaletteLogic.asWhiteTheme().primary;
    }
    if (hue == null){
      return primary;
    }
    return ColorPaletteLogic.fromHue(hue, isDarkMode: isDarkMode).primary;
  }

  Color getSecondary({
    double? hue,
    bool isDarkMode = false,
    bool isWhiteMode = false}){
    if (isWhiteMode){
      return ColorPaletteLogic.asWhiteTheme().secondary;
    }
    if (hue == null){
      return secondary;
    }
    return ColorPaletteLogic.fromHue(hue, isDarkMode: isDarkMode).secondary;
  }

  Color getActiveElementBackground({
    double? hue,
    bool isDarkMode = false,
    bool isWhiteMode = false}){
    if (isWhiteMode){
      return ColorPaletteLogic.asWhiteTheme().activeElementBackground;
    }
    if (hue == null){
      return activeElementBackground;
    }
    return ColorPaletteLogic.fromHue(hue, isDarkMode: isDarkMode)
        .activeElementBackground;
  }

  Color getActiveElementText({
    double? hue,
    bool isDarkMode = false,
    bool isWhiteMode = false
  }){
    if (isWhiteMode){
      return ColorPaletteLogic.asWhiteTheme().activeElementText;
    }
    if (hue == null){
      return activeElementText;
    }
    return ColorPaletteLogic.fromHue(hue, isDarkMode: isDarkMode)
        .activeElementText;
  }

  Color getActiveElementBorder({
    double? hue,
    bool isDarkMode = false,
    bool isWhiteMode = false
  }){
    if (isWhiteMode){
      return ColorPaletteLogic.asWhiteTheme().activeElementBorder;
    }
    if (hue == null){
      return activeElementBorder;
    }
    return ColorPaletteLogic.fromHue(hue, isDarkMode: isDarkMode)
        .activeElementBorder;
  }

  Color getInactiveElementBackground({
    double? hue,
    bool isDarkMode = false,
    bool isWhiteMode = false
  }){
    if (isWhiteMode){
      return ColorPaletteLogic.asWhiteTheme().inactiveElementBackground;
    }
    if (hue == null){
      return inactiveElementBackground;
    }
    return ColorPaletteLogic.fromHue(hue, isDarkMode: isDarkMode)
        .inactiveElementBackground;
  }

  Color getInactiveElementText({
    double? hue,
    bool isDarkMode = false,
    bool isWhiteMode = false
  }){
    if (isWhiteMode){
      return ColorPaletteLogic.asWhiteTheme().inactiveElementText;
    }
    if (hue == null){
      return inactiveElementText;
    }
    return ColorPaletteLogic.fromHue(hue, isDarkMode: isDarkMode)
        .inactiveElementText;
  }

  Color getInactiveElementBorder({
    double? hue,
    bool isDarkMode = false,
    bool isWhiteMode = false
  }){
    if (isWhiteMode){
      return ColorPaletteLogic.asWhiteTheme().inactiveElementBorder;
    }
    if (hue == null){
      return inactiveElementBorder;
    }
    return ColorPaletteLogic.fromHue(hue, isDarkMode: isDarkMode)
        .inactiveElementBorder;
  }

  void setUpdateTrigger(VoidCallback trigger){
    updateTrigger = trigger;
  }

  void update(ColorPaletteLogic newColorPalette){
    hue = newColorPalette.hue;
    isColored = newColorPalette.isColored;
    primary = newColorPalette.primary;
    secondary = newColorPalette.secondary;
    activeElementBackground = newColorPalette.activeElementBackground;
    activeElementText = newColorPalette.activeElementText;
    activeElementBorder = newColorPalette.activeElementBorder;
    inactiveElementBackground = newColorPalette.inactiveElementBackground;
    inactiveElementText = newColorPalette.inactiveElementText;
    inactiveElementBorder = newColorPalette.inactiveElementBorder;

    if (updateTrigger != null){
      updateTrigger!();
    }

  }

}