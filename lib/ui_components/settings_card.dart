
import 'package:amaze_game/input_elements/input_slider.dart';
import 'package:amaze_game/input_elements/toggle_switch.dart';
import 'package:amaze_game/input_elements/button.dart';

import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/services/haptic_engine_service.dart';
import 'package:amaze_game/services/storage_service.dart';
import 'package:amaze_game/states/settings_state.dart';

import 'package:flutter/material.dart';


class SettingsCard extends StatefulWidget {

  final ColorPaletteLogic colorPalette;
  final SettingsState settingsState;
  final StorageService storageService;
  final HapticEngineService hapticEngine;
  final VoidCallback onExit;

  const SettingsCard({
    super.key,
    required this.colorPalette,
    required this.settingsState,
    required this.storageService,
    required this.hapticEngine,
    required this.onExit
  });

  @override
  State<SettingsCard> createState() => _SettingsCardState();


  static void open(
    BuildContext context,
    ColorPaletteLogic colorPalette,
    SettingsState settingsState,
    StorageService storageService,
    HapticEngineService hapticEngine,
    {
      required VoidCallback onExit
    }
  ){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return SettingsCard(
          colorPalette: colorPalette,
          settingsState: settingsState,
          storageService: storageService,
          hapticEngine: hapticEngine,
          onExit: onExit
        );
      }
    );
  }


}

class _SettingsCardState extends State<SettingsCard> {


  @override
  void initState() {
    super.initState();
    print("Settings Card Opened");
  }

  @override
  void dispose() {
    print("Settings Card Closed");

    widget.onExit();
    widget.storageService.setSettingsState(
        value: widget.settingsState
    );
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        // 20 % of screen
        horizontal: (MediaQuery.of(context).size.width - 300) / 2,
        vertical: (MediaQuery.of(context).size.height - 540) / 2
      ),
      
      child: Material(
          color: widget.colorPalette.activeElementBackground,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: widget.colorPalette.activeElementBorder,
              width: 5.0,
              strokeAlign: BorderSide.strokeAlignCenter
            ),
            borderRadius: BorderRadius.circular(10.0),

          ),

          child: Padding(
            padding: const EdgeInsets.only(
                left: 18.0, right: 18.0, top: 25.0, bottom: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Center(
                  child: Text(
                      "Settings",
                      style: TextStyle(
                        fontFamily: 'Advent',
                        color: widget.colorPalette.activeElementText,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        letterSpacing: -1.08,
                      )
                  ),
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Volume",
                              style: TextStyle(
                                fontFamily: 'Advent',
                                color: widget.colorPalette.activeElementText,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.6,
                              )
                          ),
                  
                          InputSlider(
                            value: widget.settingsState.volume,
                            colorPalette: widget.colorPalette,
                            onChange: (double value){
                            // print(value);
                              setState(() {
                                widget.settingsState.volume = value;
                              });
                            }
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Haptics",
                            style: TextStyle(
                              fontFamily: 'Advent',
                              color: widget.colorPalette.activeElementText,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.6,
                            )
                          ),
                          ToggleSwitch(
                            state: widget.settingsState.hapticEnabled,
                            setState: (bool state) {
                              widget.settingsState.hapticEnabled = state;
                              setState(() {});
                            },
                            colorPalette: widget.colorPalette,
                          )
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "Color Mode",
                              style: TextStyle(
                                fontFamily: 'Advent',
                                color: widget.colorPalette.activeElementText,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.6,
                              )
                          ),
                          ToggleSwitch(
                            onLabel: "Dark",
                            offLabel: "Light",
                            state: widget.settingsState.isDarkMode,
                            setState: (bool state) {
                              widget.settingsState.isDarkMode = state;
                  
                              widget.colorPalette.switchColorMode(isDarkMode: state);
                  
                              setState(() {});
                            },
                            colorPalette: widget.colorPalette,
                          )
                        ],
                      ),

                      const SizedBox(height: 25),
                  
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Tilt Sensitivity",
                              style: TextStyle(
                                fontFamily: 'Advent',
                                color: widget.colorPalette.activeElementText,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.6,
                              )
                          ),
                          InputSlider(
                              value: widget.settingsState.tiltSensitivity,
                              onChange: (double value){
                                setState(() {
                                  widget.settingsState.tiltSensitivity = value;
                                });
                              },
                              colorPalette: widget.colorPalette
                          )
                        ],
                      ),

                      const SizedBox(height: 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Tilt Range",
                              style: TextStyle(
                                fontFamily: 'Advent',
                                color: widget.colorPalette.activeElementText,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.6,
                              )
                          ),
                          InputSlider(
                              value: widget.settingsState.tiltRange,
                              onChange: (double value){
                                setState(() {
                                  widget.settingsState.tiltRange = value;
                                });
                              },
                              colorPalette: widget.colorPalette
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),
                Center(
                  child: Button(
                    text: "Exit Panel",
                    onPressed: (){
                      widget.hapticEngine.selection();
                      Navigator.pop(context);
                    },
                    colorPalette: widget.colorPalette,
                    isDark: true,

                  ),
                )

              ],
            ),
          )
      ),
    );
  }
}
