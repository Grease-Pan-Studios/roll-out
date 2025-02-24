
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:amaze_game/ui_components/login_form.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LoginPage extends StatefulWidget {

  final ColorPaletteLogic colorPalette;
  final VoidCallback goToGame;

  const LoginPage({
    super.key,
    required this.colorPalette,
    required this.goToGame,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final PanelController _panelController = PanelController();

  double _panelSlide = 1;


  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      defaultPanelState: PanelState.OPEN,
      panel: LoginForm(
        colorPalette: widget.colorPalette,
        goToGame: widget.goToGame,
      ),

      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          _panelController.close();
        },
        onVerticalDragUpdate: (details){

          if (details.primaryDelta == null) return;

          if (details.primaryDelta! < -5){
            _panelController.open();
          }

        },
        child: Material(
          color: widget.colorPalette.secondary,
          child: Align(
            alignment: Alignment.lerp(
                Alignment(-0.1, -0.1), // Center
                Alignment(-0.7, -0.5), // Left ish
                _panelSlide)!
                .add(Alignment(0, 0.0)),
            child: Text(
              "Roll Out",
              style: TextStyle(
                fontFamily: "Advent",
                fontWeight: FontWeight.w700,
                color: widget.colorPalette.activeElementText,
                letterSpacing: -3.0,
                fontSize: 98,
              )
            ),
          )
        ),
      ),

      minHeight: 50.0,  // Height of the collapsed panel
      maxHeight: 400,
      controller: _panelController,
      boxShadow: [],
      onPanelSlide: (double pos) {
        setState(() {
          _panelSlide = pos;
        });
      },
    );
  }
}
